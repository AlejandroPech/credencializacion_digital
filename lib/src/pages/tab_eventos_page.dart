
import 'package:credencializacion_digital/src/services/eventos_service.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:credencializacion_digital/src/widgets/lista_eventos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabPaginaEventos extends StatefulWidget {
  @override
  _TabPaginaEventosState createState() => _TabPaginaEventosState();
}

class _TabPaginaEventosState extends State<TabPaginaEventos> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final eventoService = Provider.of<EventosService>(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _ListaCategorias(),
            if(!eventoService.estaCargando)
              Expanded(child: ListaEventos(eventos: eventoService.getEventosSeleccionados,)),
            if(eventoService.estaCargando)
              Expanded(child: Center(child: CircularProgressIndicator(),)),
          ],
        )
      ),
    );
  }
}

class _ListaCategorias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eventoService = Provider.of<EventosService>(context);
    final appTheme= Provider.of<ThemeChanger>(context).currentTheme;
    return Container(
      height: 50,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: eventoService.categorias.length,
        itemBuilder: (BuildContext context,int index){
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                MaterialButton(
                  child:(eventoService.categoriaSeleccionada==eventoService.categorias[index])
                      ? Text(eventoService.categorias[index],style: TextStyle(color:appTheme.accentColor ),)
                      :Text(eventoService.categorias[index]),
                  onPressed: (){
                    if(eventoService.categoriaSeleccionada!=eventoService.categorias[index]){
                      eventoService.categoriaSeleccionada=eventoService.categorias[index];
                    }
                  }
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}