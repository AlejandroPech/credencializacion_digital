import 'package:credencializacion_digital/src/pages/empresas_page.dart';
import 'package:credencializacion_digital/src/services/microsoft_service.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_microsoft_authentication/flutter_microsoft_authentication.dart';
import 'package:provider/provider.dart';

class InicioSesionPage extends StatefulWidget {
  static final String routeName='inicioSesion';
  InicioSesionPage({Key key}) : super(key: key);

  @override
  _InicioSesionPageState createState() => _InicioSesionPageState();
}

class _InicioSesionPageState extends State<InicioSesionPage> {

  final prefUser = PrefUser();
  MicrosoftService microsoftService= new MicrosoftService();

  FlutterMicrosoftAuthentication fma;

  @override
  void initState() {
    super.initState();
    
    fma = FlutterMicrosoftAuthentication(
      kClientID: "86614fe5-8390-4852-b473-7aac5bf50548",
      kAuthority: "https://login.microsoftonline.com/organizations",
      kScopes: ["User.Read", "User.ReadBasic.All"],
      androidConfigAssetPath: "assets/auth_config.json"
    );
    print('-------------- microsoftService inicializado -----------');
  }

  Future<bool> cuentaIniciada() async {
    return prefUser.inicioSesion;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme= Provider.of<ThemeChanger>(context);
    if(prefUser.inicioSesion){
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, EmpresaPage.routeName);
      });
    }
    return FutureBuilder(
      future: cuentaIniciada(),
      builder: (BuildContext context,AsyncSnapshot snapshot){
        if(snapshot.hasData){
          if(prefUser.inicioSesion){
            Future.microtask(() {
              Navigator.pushReplacementNamed(context, EmpresaPage.routeName);
            });
          }else{
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,  
                children: [
                  Container(
                    child: Image.asset('assets/img/logo-utm.png'),
                  ),
                  ElevatedButton( 
                    onPressed: ()async {
                      await microsoftService.acquireTokenInteractively(fma);
                      if(prefUser.inicioSesion){
                        Navigator.pushReplacementNamed(context, EmpresaPage.routeName);
                      }
                    },
                    child: Text('Iniciar Sesión'),
                    style: ElevatedButton.styleFrom(
                      primary: appTheme.currentTheme.accentColor
                    ),
                  ),
              
                ],
              )
            );
          }
        }
        return Scaffold(body:Text(''));
      },
    );
  }
}