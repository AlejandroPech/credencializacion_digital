
import 'dart:convert';

import 'package:credencializacion_digital/src/models/UsuarioModel.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:flutter/services.dart';
import 'package:flutter_microsoft_authentication/flutter_microsoft_authentication.dart';
import 'package:http/http.dart' as http;

class MicrosoftService{
  String value="value";
  String imagenUsuario = "https://graph.microsoft.com/v1.0/me/photo/\$value";
  String perfilUsuario = 'http://192.168.54.102:9096/api';
  String _authToken = '';
  final prefUser = PrefUser();

  Future<void> acquireTokenInteractively(FlutterMicrosoftAuthentication fma) async {
    try {
      _authToken = await fma.acquireTokenInteractively;
      prefUser.inicioSesion=true;
      prefUser.tokenMicrosoft=_authToken;
      prefUser.inicioToken=DateTime.now();
      await guardarImagen(fma);
      await guardarDatos(fma);
    } on PlatformException catch(e) {
      print(e.message);
    }
    return prefUser.tokenMicrosoft;
  }

  Future<void> acquireTokenSilently(FlutterMicrosoftAuthentication fma) async {
    try {
      prefUser.tokenMicrosoft = await fma.acquireTokenSilently;
      prefUser.inicioToken=DateTime.now();
      await guardarImagen(fma);
    } on PlatformException catch(e) {
      prefUser.tokenMicrosoft = '';
      print(e.message);
    }
    return prefUser.tokenMicrosoft;
  }

  Future<void> signOut(FlutterMicrosoftAuthentication fma) async {
    try {
      await fma.signOut;
      prefUser.inicioSesion=false;
      prefUser.tokenMicrosoft='';
      prefUser.nombreUsuario='';
      prefUser.imagenUsuario='';
    } on PlatformException catch(e) {
      print(e.message);
    }
  }

  Future<String> loadAccount(FlutterMicrosoftAuthentication fma) async {
    String username = await fma.loadAccount;
    return username;
  }

  Future<Usuario> fetchMicrosoftProfile(FlutterMicrosoftAuthentication fma) async {
    final usuariocorreo=await fma.loadAccount;
    final token=await loadToken(fma);
    if(int.tryParse(usuariocorreo.substring(0,8))!=null  && usuariocorreo.substring(8,9)=='@'){
      var response = await http.post(Uri.parse(perfilUsuario+'/Users/student'), 
        body: jsonEncode({'code': token}),
        headers: {"Content-Type": "application/json-patch+json", "Accept" : "*/*"},
      );
      final usuario=alumnoResponse(response.body,prefUser.imagenUsuario);
      return usuario;
    }else{
      final url=perfilUsuario+'/Users/empleado/'+usuariocorreo;
      var response = await http.get(Uri.parse(url));
      final usuario=empleadoResponse(response.body, prefUser.imagenUsuario);
      return usuario;
    }
  }
  guardarImagen(FlutterMicrosoftAuthentication fma)async{
    final token=await loadToken(fma);
    var response = await http.get(Uri.parse(imagenUsuario), headers: {
      "Authorization": "Bearer " + token
    });

    final bytes = response.body;
    prefUser.imagenUsuario=bytes??'';
  }

  guardarDatos(FlutterMicrosoftAuthentication fma) async{
    final token=await loadToken(fma);
    final usuariocorreo=await fma.loadAccount;
    if(int.tryParse(usuariocorreo.substring(0,8))!=null  && usuariocorreo.substring(8,9)=='@'){
      var response = await http.post(Uri.parse(perfilUsuario+'/Users/student'), 
        body: jsonEncode({'code': token}),
        headers: {"Content-Type": "application/json-patch+json", "Accept" : "*/*"},
      );
      final json=jsonDecode(response.body);
      prefUser.nombreUsuario=json['displayName'];
      // var cosa=json['officeLocation'];
      prefUser.identificadorUsuario=json['mail'].toString().substring(0,8);
      prefUser.departamento=json['officeLocation']??'';
    }else{
      final url=perfilUsuario+'/Users/empleado/'+usuariocorreo;
      var response = await http.get(Uri.parse(url));
      final json=jsonDecode(response.body);
      prefUser.nombreUsuario=(json['PrimerNombre']+" "??'')+(json['SegundoNombre']+" "??'')+(json['PrimerApellido']+" "??'')+(json['SegundoApellido']+" "??'');
      prefUser.identificadorUsuario=json['ClaveEmpleado'];
      prefUser.departamento= json['Departamento']??'';
    }
  }

  Future<String> loadToken(FlutterMicrosoftAuthentication fma)async{
    final DateTime fechaActual= DateTime.now();
    final DateTime inicioToken=prefUser.inicioToken;
    final int diferencia=fechaActual.difference(inicioToken).inSeconds;

    if(diferencia>500){
      await acquireTokenSilently(fma);
    }
    return prefUser.tokenMicrosoft;
  }
}