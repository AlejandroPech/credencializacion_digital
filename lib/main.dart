import 'package:credencializacion_digital/src/services/eventos_service.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:flutter/material.dart';

import 'package:credencializacion_digital/src/app.dart';
import 'package:flutter/services.dart';
 
import 'package:provider/provider.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );
  
  final prefs = new PrefUser();
  await prefs.initPrefs();
  runApp(
     MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>new EventosService()),
      ],
      child: MyApp()
    )
  );
} 