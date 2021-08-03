import 'package:credencializacion_digital/src/services/eventos_service.dart';
import 'package:credencializacion_digital/src/widgets/lista_eventos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabPaginaFavoritos extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final eventoService = Provider.of<EventosService>(context);
    return Scaffold(
      body: ListaEventos(eventos:eventoService.eventos ),
    );
  }
}