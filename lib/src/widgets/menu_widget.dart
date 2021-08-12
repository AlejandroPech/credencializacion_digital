import 'dart:typed_data';

import 'package:credencializacion_digital/src/pages/evento_page.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:credencializacion_digital/src/pages/credencial_page.dart';
import 'package:credencializacion_digital/src/pages/empresas_page.dart';
import 'package:meta/meta.dart';

class MenuWidget extends StatelessWidget {
  final prefUser = PrefUser();
  final urlImage="https://image.freepik.com/vector-gratis/hombre-muestra-gesto-gran-idea_10045-637.jpg";
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 10),
        // color: appTheme.accentColor.withAlpha(75),
        
        child: ListView(  
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              // decoration:BoxDecoration(
              //   color: appTheme.accentColor.withAlpha(150)
              // ),
              // curve: Curves.fastOutSlowIn,
              child: Container(
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(radius: 50, backgroundImage: MemoryImage(Uint8List.fromList(prefUser.imagenUsuario.codeUnits))),
                    Expanded(child: Text(prefUser.nombreUsuario,textAlign: TextAlign.center,maxLines: 2,)),
                    Text(prefUser.identificadorUsuario),
                  ],
                ),
              )),
            ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Credencial',),
              selectedTileColor: appTheme.accentColor.withAlpha(25),
              // selected: true,
              onTap: ()=>Navigator.pushReplacementNamed(context, CredencialPage.routeName),
            ),
            ListTile(
              leading: Icon(Icons.business,color: Colors.black54,),
              title: Text('Cupones',),
              onTap: ()=>Navigator.pushReplacementNamed(context, EmpresaPage.routeName),
            ),
            ListTile(
              leading: Icon(Icons.event,color: Colors.black54,),
              title: Text('Eventos'),
              onTap: ()=>Navigator.pushReplacementNamed(context, EventosPage.routeName),
            ),
          ],
        ),
      ),
    );
  }
}