import 'package:credencializacion_digital/src/services/eventos_service.dart';
import 'package:credencializacion_digital/src/widgets/lista_eventos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabPaginaFavoritos extends StatefulWidget {

  @override
  _TabPaginaFavoritosState createState() => _TabPaginaFavoritosState();
}

class _TabPaginaFavoritosState extends State<TabPaginaFavoritos> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final eventoService = Provider.of<EventosService>(context);
    return Scaffold(
      body: ListaEventos(eventos:eventoService.obtenerFavoritos),
    );
  }
}