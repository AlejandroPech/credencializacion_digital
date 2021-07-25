import 'dart:typed_data';

import 'package:credencializacion_digital/src/pages/evento_page.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/material.dart';

import 'package:credencializacion_digital/src/pages/credencial_page.dart';
import 'package:credencializacion_digital/src/pages/empresas_page.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';

class MenuWidget extends StatelessWidget {
  final prefUser = PrefUser();
  final urlImage="https://image.freepik.com/vector-gratis/hombre-muestra-gesto-gran-idea_10045-637.jpg";
  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    return Drawer(
      child: Container(
        child: ListView(  
          children: [
            buildHeader(
              name: prefUser.nombreUsuario,
              onClicked:()=>Navigator.pushReplacementNamed(context, CredencialPage.routeName),
            ),
            ListTile(
              leading: Icon(Icons.business,color: appTheme.currentTheme.accentColor,),
              title: Text('Empresas'),
              onTap: ()=>Navigator.pushReplacementNamed(context, EmpresaPage.routeName),
            ),
            ListTile(
              leading: Icon(Icons.event,color: appTheme.currentTheme.accentColor,),
              title: Text('Eventos'),
              onTap: ()=>Navigator.pushReplacementNamed(context, EventosPage.routeName),
            ),
            ListTile(
              leading: Icon( Icons.lightbulb_outline,color: appTheme.currentTheme.accentColor,),
              title: Text('Dark Mode'),
              trailing: Switch.adaptive(
                activeColor: appTheme.currentTheme.accentColor,
                value: (prefUser.theme==2)?true:false ,
                onChanged: ( value ) {
                  if(value){
                    prefUser.theme=2;
                  }
                  else{
                    prefUser.theme=3;
                  }
                  appTheme.darkTheme = value;
                } 
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildHeader({
    @required String name,
    @required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: MemoryImage(Uint8List.fromList(prefUser.imagenUsuario.codeUnits))),
              SizedBox(width: 20),
              Expanded(
                child:Text(
                      name,
                      style: TextStyle(fontSize: 16),
                  ), 
              ),
              
            ],
          ),
        ),
      );
}