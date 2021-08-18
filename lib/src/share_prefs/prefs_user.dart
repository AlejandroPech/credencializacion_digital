import 'package:shared_preferences/shared_preferences.dart';

class PrefUser{
  static final PrefUser _instancia = new PrefUser._internal();

  factory PrefUser(){
    return _instancia;
  }

  PrefUser._internal();

  //Con null safety debe llevar "late" antes de SharedPreferences _prefs
  SharedPreferences _prefs;

  initPrefs()async {
    this._prefs=await SharedPreferences.getInstance();
  }

  String get tokenMicrosoft{
    return _prefs.getString('tokenMicrosoft')??'';
  }

  set tokenMicrosoft(String value){
    _prefs.setString('tokenMicrosoft', value);
  }

  bool get inicioSesion{
    return _prefs.getBool('inicioSesion')?? false;
  }

  set inicioSesion(bool value){
    _prefs.setBool('inicioSesion', value);
  }

  DateTime get inicioToken{
    String fecha=_prefs.getString('inicioToken')??DateTime.now().toString();
    return DateTime.parse(fecha);
  }

  set inicioToken(DateTime value){
    _prefs.setString('inicioToken', value.toString());
  }

  String get imagenUsuario{
    return _prefs.getString('imagenUsuario')??'';
  }

  set imagenUsuario(String value){
    _prefs.setString('imagenUsuario', value);
  }

  String get nombreUsuario{
    return _prefs.getString('nombreUsuario')??'';
  }
  
  set nombreUsuario(String value){
    _prefs.setString('nombreUsuario', value);
  }

  String get identificadorUsuario{
    return _prefs.getString('identificadorUsuario')??'';
  }

  set identificadorUsuario(String value){
    _prefs.setString('identificadorUsuario', value);
  }

  String get departamento{
    return _prefs.getString('departamento')??'';
  }

  set departamento(String value){
    _prefs.setString('departamento', value);
  }
}