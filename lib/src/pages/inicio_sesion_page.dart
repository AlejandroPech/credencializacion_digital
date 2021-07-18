import 'package:credencializacion_digital/src/pages/empresas_page.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_microsoft_authentication/flutter_microsoft_authentication.dart';
import 'package:provider/provider.dart';

class InicioSesionPage extends StatefulWidget {
  static final String routeName='inicioSesion';
  InicioSesionPage({Key key}) : super(key: key);

  @override
  _InicioSesionPageState createState() => _InicioSesionPageState();
}

class _InicioSesionPageState extends State<InicioSesionPage> {
  // String _graphURI = "https://graph.microsoft.com/v1.0/me/";
  String _authToken = '';
  final prefUser = PrefUser();

  FlutterMicrosoftAuthentication fma;

  @override
  void initState() {
    super.initState();
    if(prefUser.inicioSesion){
      Future.microtask(() {
        Navigator.pushReplacementNamed(context, EmpresaPage.routeName);
      });
    }
    fma = FlutterMicrosoftAuthentication(
      kClientID: "86614fe5-8390-4852-b473-7aac5bf50548",
      kAuthority: "https://login.microsoftonline.com/organizations",
      kScopes: ["User.Read", "User.ReadBasic.All"],
      androidConfigAssetPath: "assets/auth_config.json"
    );
  }

  Future<void> _acquireTokenInteractively() async {
    try {
      _authToken = await this.fma.acquireTokenInteractively;
      prefUser.inicioSesion=true;
      prefUser.tokenMicrosoft=_authToken;
      Navigator.pushReplacementNamed(context, EmpresaPage.routeName);
    } on PlatformException catch(e) {
      print(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme= Provider.of<ThemeChanger>(context);
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,  
          children: [
            Container(
              child: Image.asset('assets/img/logo-utm.png'),
            ),
            ElevatedButton( 
              onPressed: _acquireTokenInteractively,
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