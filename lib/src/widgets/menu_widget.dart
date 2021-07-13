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
              email: '19090529',
              name: 'Jesus Alejandro Pech Paredes',
              onClicked:()=>Navigator.pushReplacementNamed(context, CredencialPage.routeName),
              urlImage: urlImage
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
    @required String urlImage,
    @required String name,
    @required String email,
    @required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.substring(0,20),
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}