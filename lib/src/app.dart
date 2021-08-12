import 'package:credencializacion_digital/src/pages/credencial_page.dart';
import 'package:credencializacion_digital/src/pages/empresa_cupon_page.dart';
import 'package:credencializacion_digital/src/pages/empresa_cupones_page.dart';
import 'package:credencializacion_digital/src/pages/empresas_page.dart';
import 'package:credencializacion_digital/src/pages/evento_page.dart';
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
        EmpresaPage.routeName:(context)=>EmpresaPage(title: "Empresas"),
        CredencialPage.routeName:(context)=>CredencialPage(title: "Credencial Digital"),
        EmpresaCuponPage.routeName:(context)=>EmpresaCuponPage(title: "Cupon"),
        EmpresaCuponesPage.routeName:(context)=>EmpresaCuponesPage(title: "Cupones",),
        EventosPage.routeName:(context)=>EventosPage(),
      },
    );
  }
}