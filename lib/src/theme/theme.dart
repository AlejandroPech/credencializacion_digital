import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeChanger with ChangeNotifier{
  bool _darkTheme=false;
  bool _customTheme=false;
  ThemeData _custom=ThemeData.light().copyWith(
      accentColor: Color(0xff00AB78),
      primaryColor: Color(0xff00AB78),
      primaryColorLight: Colors.black,
      bottomAppBarColor: Color(0xff00AB78),
      textTheme: TextTheme(
        bodyText1: TextStyle( color: Colors.black ),
        bodyText2: TextStyle( color: Colors.black ),
      ),
    );
  SystemUiOverlayStyle _styleBlack = SystemUiOverlayStyle(
    systemNavigationBarDividerColor: Colors.black,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  );
  final _styleLight = SystemUiOverlayStyle(
    systemNavigationBarDividerColor: Colors.white,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  //Con null safety debe llevar "late" antes de ThemeData _currentTheme
  ThemeData _currentTheme;

  bool get darkTheme => this._darkTheme;
  bool get customTheme =>this._customTheme;
  ThemeData get currentTheme => this._currentTheme;

  ThemeChanger(int theme){
    switch(theme){
      case 1:
        _darkTheme=false;
        _customTheme=false;
        _currentTheme=ThemeData.light();
        SystemChrome.setSystemUIOverlayStyle(_styleLight);
      break;
      case 2:
        _darkTheme=false;
        _customTheme=false;
        _currentTheme=ThemeData.dark().copyWith(
          accentColor: Colors.pink,
          primaryColor:  Colors.pink,
        );
        SystemChrome.setSystemUIOverlayStyle(_styleBlack);
      break;
      case 3:
        _darkTheme=false;
        _customTheme=true;
        _currentTheme=_custom;
        SystemChrome.setSystemUIOverlayStyle(_styleLight);
      break;
      default:
        _darkTheme=false;
        _customTheme=false;
        _currentTheme=ThemeData.light();
      break;
    }
  }

  set darkTheme(bool value){
    _customTheme=false;
    _darkTheme=value;

    if( value){
      _currentTheme=ThemeData.dark().copyWith(
        accentColor:  Colors.pink,
        primaryColor:  Colors.pink,
      );
      SystemChrome.setSystemUIOverlayStyle(_styleBlack);
    }
    else{
      _currentTheme=_custom;
      SystemChrome.setSystemUIOverlayStyle(_styleLight);
    }
    notifyListeners();
  }

  set customTheme(bool value){
    _darkTheme=false;
    _customTheme=value;
    if(value){
      _currentTheme=_custom;
      SystemChrome.setSystemUIOverlayStyle(_styleLight);
    }else{
      _currentTheme=_custom;
      SystemChrome.setSystemUIOverlayStyle(_styleLight);
    }
    
    notifyListeners();
  }

}