
import 'package:credencializacion_digital/src/services/eventos_service.dart';
import 'package:credencializacion_digital/src/widgets/lista_eventos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabPaginaEventos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final eventoService = Provider.of<EventosService>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _ListaCategorias(),
            Expanded(child: ListaEventos(eventos: eventoService.eventos,))
          ],
        )
      ),
    );
  }
}

class _ListaCategorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categorias=['Todos','Hoy','Esta Semana','Este Mes', 'Este año'];
    return Container(
      height: 50,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        itemBuilder: (BuildContext context,int index){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                MaterialButton(
                  child: Text(categorias[index]),
                  onPressed: (){}
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}