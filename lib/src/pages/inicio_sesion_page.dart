import 'package:credencializacion_digital/src/pages/empresas_page.dart';
import 'package:credencializacion_digital/src/services/microsoft_service.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
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
  String _graphURI = "https://graph.microsoft.com/v1.0/me/";

  String _authToken = '';
  String _username = '';
  String _msProfile = '';

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
  }

  Future<void> _acquireTokenInteractively() async {
    String authToken;
    try {
      _authToken = await this.fma.acquireTokenInteractively;
      Navigator.pushReplacementNamed(context, EmpresaPage.routeName);
    } on PlatformException catch(e) {
      authToken = 'Failed to get token.';
      print(e.message);
    }
  }

  Future<void> _signOut() async {
    String authToken;
    try {
      authToken = await this.fma.signOut;
    } on PlatformException catch(e) {
      authToken = 'Failed to sign out.';
      print(e.message);
    }
    setState(() {
      _authToken = authToken;
    });
  }

  Future<String> _loadAccount() async {
    String username = await fma.loadAccount;
    _username = "username";
    setState(() {
      
      
    });
  }
  _fetchMicrosoftProfile() async {
    var response = await http.get(Uri.parse(_graphURI), headers: {
      "Authorization": "Bearer " + this._authToken
    });

    setState(() {
      _msProfile = json.decode(response.body).toString();
    });
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
            // ElevatedButton( 
            //   onPressed: _signOut,
            //   child: Text('Cerrar Sesión'),
            //   style: ElevatedButton.styleFrom(
            //     primary: appTheme.currentTheme.accentColor
            //   ),
            // ),
            // ElevatedButton( 
            //   onPressed: _fetchMicrosoftProfile,
            //   child: Text('Cargar Sesión'),
            //   style: ElevatedButton.styleFrom(
            //     primary: appTheme.currentTheme.accentColor
            //   ),
            // ),
          ],
        )
      );
  }
}