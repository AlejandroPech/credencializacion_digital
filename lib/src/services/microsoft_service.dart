
import 'dart:convert';

import 'package:credencializacion_digital/src/models/UsuarioModel.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:flutter/services.dart';
import 'package:flutter_microsoft_authentication/flutter_microsoft_authentication.dart';
import 'package:http/http.dart' as http;

class MicrosoftService{
  String value="value";
  String imagenUsuario = "https://graph.microsoft.com/v1.0/me/photo/\$value";
  String perfilUsuario = "https://graph.microsoft.com/v1.0/me/";
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
      var response = await http.get(Uri.parse(perfilUsuario), headers: {
        "Authorization": "Bearer " + token
      });
      final usuario=alumnoResponse(response.body,prefUser.imagenUsuario);
      return usuario;
    }else{
      final url='https://api.utmetropolitana.edu.mx/api/Empleados/Get?correoinstitucional='+usuariocorreo;
      var response = await http.get(Uri.parse(url));
      final jsonResponse=jsonDecode(response.body.replaceAll('[','').replaceAll(']',''));
      final usuario=empleadoResponse(jsonResponse, prefUser.imagenUsuario);
      return usuario;
    }
  }
  guardarImagen(FlutterMicrosoftAuthentication fma)async{
    final token=await loadToken(fma);
    var response = await http.get(Uri.parse(imagenUsuario), headers: {
      "Authorization": "Bearer " + token
    });

    final bytes = response.body;
    prefUser.imagenUsuario=bytes;
  }

  guardarDatos(FlutterMicrosoftAuthentication fma) async{
    final token=await loadToken(fma);
    final usuariocorreo=await fma.loadAccount;
    if(int.tryParse(usuariocorreo.substring(0,8))!=null  && usuariocorreo.substring(8,9)=='@'){
      var response = await http.get(Uri.parse(perfilUsuario), headers: {
        "Authorization": "Bearer " + token
      });
      final json=jsonDecode(response.body);
      prefUser.nombreUsuario=json['displayName'];
      prefUser.identificadorUsuario=json['mail'].toString().substring(0,8);
    }else{
      final url='https://api.utmetropolitana.edu.mx/api/Empleados/Get?correoinstitucional='+usuariocorreo;
      var response = await http.get(Uri.parse(url));
      final jsonResponse=jsonDecode(response.body.replaceAll('[','').replaceAll(']',''));
      final json=jsonDecode(jsonResponse);
      prefUser.nombreUsuario=(json['PrimerNombre']+" "??'')+(json['SegundoNombre']+" "??'')+(json['PrimerApellido']+" "??'')+(json['SegundoApellido']+" "??'');
      prefUser.identificadorUsuario=json['ClaveEmpleado'];
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