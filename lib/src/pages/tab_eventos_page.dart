
import 'package:credencializacion_digital/src/services/eventos_service.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:credencializacion_digital/src/widgets/lista_eventos.dart';
import 'package:credencializacion_digital/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
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
    return DefaultTabController(
      length: eventoService.categorias.length,
      child: Scaffold(
         drawer: MenuWidget(),
          appBar: NewGradientAppBar(
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [appTheme.accentColor,Color(0xff81c784)]
            // ),
            bottom: TabBar(
              onTap: (index){
                if(eventoService.categoriaSeleccionada!=eventoService.categorias[index]){
                  eventoService.categoriaSeleccionada=eventoService.categorias[index];
                }
              },
              isScrollable: true,
              indicatorColor:appTheme.scaffoldBackgroundColor,
              // physics: NeverScrollableScrollPhysics(),
              tabs: List<Widget>.generate(eventoService.categorias.length, (index) {
                return Tab(
                  child: Text(eventoService.categorias[index]),
                );
              })
            ),
            title:Text('Eventos',),
          ),
        body: SafeArea(
            child: Column(
              children: [
                if(!eventoService.estaCargando)
                  Expanded(child: ListaEventos(eventos: eventoService.getEventosSeleccionados,)),
                if(eventoService.estaCargando)
                  Expanded(child: Center(child: CircularProgressIndicator(),)),
              ],
            )
          )
      ),
    );
  }
}