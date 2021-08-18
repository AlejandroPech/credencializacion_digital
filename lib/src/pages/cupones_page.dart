import 'dart:convert';

import 'package:credencializacion_digital/src/pages/tab_cupones_genericos.dart';
import 'package:credencializacion_digital/src/pages/tab_cupones_imagenes.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/material.dart';

class CuponesPage extends StatefulWidget {
  static final String routeName = 'cupones';
  final String image;
  final String idEm;
  final String nombreImagen;
  CuponesPage({@required this.image,@required this.idEm,@required this.nombreImagen});

  @override
  _CuponesPageState createState() => _CuponesPageState();
}

class _CuponesPageState extends State<CuponesPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children:[
            _ImagenAndButtonBack(
              size: size,
              urlImage: widget.image,
            ),
            Expanded(child: Tabs(image: widget.image, idEm: widget.idEm,nombreEmpresa: widget.nombreImagen,))
          ]
        ),
      ),
    );
  }
}

class _ImagenAndButtonBack extends StatelessWidget {
  final String urlImage;
  final Size size;
  final String nombreEmpresa;
  const _ImagenAndButtonBack({@required this.size, this.urlImage, this.nombreEmpresa});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: size.height / 4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image:(this.urlImage.isNotEmpty)
                  ? MemoryImage(base64Decode("${this.urlImage}"))
                  :AssetImage('assets/img/no-image.png'),
              )),
        ),
        SafeArea(
          child: BackButton(),
        ),
      ],
    );
  }
}

class Tabs extends StatelessWidget {
  final String image;
  final String idEm;
  final String nombreEmpresa;
  const Tabs({@required this.image,@required this.idEm, this.nombreEmpresa});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            indicatorColor:appTheme.accentColor,
            tabs: [
              Tab(
                child: Text('Cupones',style: TextStyle(color: appTheme.accentColor),),
              ),
              Tab(
                child: Text('Descuentos',style: TextStyle(color: appTheme.accentColor,),),
              ),
            ]
          ),
          Expanded(
            child: TabBarView(
              children:[
                TabCuponesImagen(image: this.image,idEm: this.idEm,),
                TabCuponesGenericos(image: this.image,idEm: this.idEm,nombreEmpresa: nombreEmpresa,),
              ]
            ),
          ),
        ],
      ),
    );
  }
}