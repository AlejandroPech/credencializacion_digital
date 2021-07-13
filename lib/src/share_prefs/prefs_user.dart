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

  //Get y Set del darkMOde
  int get theme{
    return _prefs.getInt('theme')?? 3;
  }
  set theme(int value){
    _prefs.setInt('theme', value);
  }
}