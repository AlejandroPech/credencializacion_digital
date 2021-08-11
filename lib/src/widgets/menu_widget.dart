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
        // margin: EdgeInsets.symmetric(horizontal: 10),
        // color: appTheme.currentTheme.accentColor.withAlpha(75),
        child: ListView(  
          children: [
            DrawerHeader(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //   begin: Alignment.topRight,
          //   end: Alignment.bottomLeft,
          //   // stops: [0.5,1],
          //   colors: [appTheme.currentTheme.accentColor,appTheme.currentTheme.scaffoldBackgroundColor,appTheme.currentTheme.accentColor]
          // )
              // ),
              margin: EdgeInsets.only(bottom: 20),
              padding: EdgeInsets.all(10),
              child: Container(
                // color:appTheme.currentTheme.accentColor,
                // margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    CircleAvatar(radius: 60, backgroundImage: MemoryImage(Uint8List.fromList(prefUser.imagenUsuario.codeUnits))),
                    Expanded(child: Text(prefUser.nombreUsuario,textAlign: TextAlign.center,maxLines: 2,)),
                  ],
                ),
              )),
            // buildHeader(
            //   name: prefUser.nombreUsuario,
            //   onClicked:()=>Navigator.pushReplacementNamed(context, CredencialPage.routeName),
            // ),
            ListTile(
              leading: Icon(Icons.business,color: appTheme.currentTheme.accentColor,),
              title: Text('Credencial',style: TextStyle(color: appTheme.currentTheme.accentColor),),
              selectedTileColor: appTheme.currentTheme.accentColor.withAlpha(25),
              // selected: true,
              onTap: ()=>Navigator.pushReplacementNamed(context, CredencialPage.routeName),
            ),
            ListTile(
              leading: Icon(Icons.business,color: Colors.black54,),
              title: Text('Cupones',style: TextStyle(color: appTheme.currentTheme.textTheme.bodyText2.color.withAlpha(150)),),
              onTap: ()=>Navigator.pushReplacementNamed(context, EmpresaPage.routeName),
            ),
            ListTile(
              leading: Icon(Icons.event,color: Colors.black54,),
              title: Text('Eventos'),
              onTap: ()=>Navigator.pushReplacementNamed(context, EventosPage.routeName),
            ),
            ListTile(
              leading: Icon( Icons.lightbulb_outline,color: Colors.black54,),
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