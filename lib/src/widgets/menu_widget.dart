import 'dart:typed_data';

import 'package:credencializacion_digital/src/pages/evento_page.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:credencializacion_digital/src/pages/credencial_page.dart';
import 'package:credencializacion_digital/src/pages/empresas_page.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class MenuWidget extends StatelessWidget {
  final List<_MenuSeleccion> opciones=[
    _MenuSeleccion(titulo: 'Credencial', icono: Icons.credit_card, redireccion: CredencialPage.routeName),
    _MenuSeleccion(titulo: 'Cupones', icono: Icons.business, redireccion: EmpresaPage.routeName),
    _MenuSeleccion(titulo: 'Eventos', icono: Icons.credit_card, redireccion: EventosPage.routeName),
  ];
  final prefUser = PrefUser();
  final urlImage="https://image.freepik.com/vector-gratis/hombre-muestra-gesto-gran-idea_10045-637.jpg";
  @override
  Widget build(BuildContext context) {
    final navegacionMenu=Provider.of<NavegacionMenuModel>(context);
    return Drawer(
      child: Container(
        child: ListView(  
          padding: EdgeInsets.zero,
          children: [
            _CabeceraDrawer(prefUser: prefUser),
            Column(
              children: List<Widget>.generate(opciones.length, (index) {
                return ListTile(
                  leading:(navegacionMenu.paginaActual==index) 
                    ?Icon(opciones[index].icono,color: appTheme.accentColor,)
                    :Icon(opciones[index].icono),
                  title:(navegacionMenu.paginaActual==index)
                    ?Text(opciones[index].titulo,style: TextStyle(color: appTheme.accentColor),)
                    :Text(opciones[index].titulo),
                  onTap: (){
                    navegacionMenu.paginaActual=index;
                    Navigator.pushReplacementNamed(context,opciones[index].redireccion);
                  }
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _CabeceraDrawer extends StatelessWidget {
  const _CabeceraDrawer({
    Key key,
    @required this.prefUser,
  }) : super(key: key);

  final PrefUser prefUser;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration:BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [appTheme.accentColor,Color(0xffa5d6a7)],
          // stops: [0.5,1]
        )
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: Container(
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            CircleAvatar(radius: 50, backgroundImage: MemoryImage(Uint8List.fromList(prefUser.imagenUsuario.codeUnits))),
            SizedBox(height: 5,),
            Text(prefUser.nombreUsuario,style: TextStyle(color:Colors.white), textAlign: TextAlign.center,maxLines: 1,),
            Text(prefUser.identificadorUsuario,style: TextStyle(color:Colors.white)),
          ],
        ),
      ));
  }
}

class _MenuSeleccion{
  String titulo;
  IconData icono;
  String redireccion;

  _MenuSeleccion({
    @required this.titulo,
    @required this.icono,
    @required this.redireccion,
  });
}

class NavegacionMenuModel with ChangeNotifier{
  int _paginaActual=1;

  int get paginaActual=>this._paginaActual;

  set paginaActual(int value){
    _paginaActual=value;
    notifyListeners();
  }
}