import 'package:credencializacion_digital/src/pages/credencial_page.dart';
import 'package:credencializacion_digital/src/pages/empresas_page.dart';
import 'package:credencializacion_digital/src/pages/eventos_page.dart';
import 'package:credencializacion_digital/src/pages/inicio_sesion_page.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      title: 'Credencial Digital',
      initialRoute: InicioSesionPage.routeName,
      routes: {
        InicioSesionPage.routeName:(context)=>InicioSesionPage(),
        EmpresaPage.routeName:(context)=>EmpresaPage(title: "Cupones"),
        CredencialPage.routeName:(context)=>CredencialPage(title: "Credencial Digital"),
        EventosPage.routeName:(context)=>EventosPage(),
      },
    );
  }
}