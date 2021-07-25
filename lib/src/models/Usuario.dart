import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class Usuario{
  // int matricula;
  // String nombre;
  // String apellidoP;
  // String apellidoM;
  // String correoInstitucional;
  // int grado;
  // String grupo;
  // String carrera;
  // String division;
  // String status;
  // String fotografia;
  // Usuario({
  //   @required this.matricula,
  //   @required this.nombre,
  //   @required this.apellidoP,
  //   @required this.apellidoM,
  //   @required this.correoInstitucional,
  //   @required this.grado,
  //   @required this.grupo,
  //   @required this.carrera,
  //   @required this.division,
  //   @required this.status,
  //   @required this.fotografia,
  // });
  String nombre;
  String titulo;
  String correoInstitucional;
  Uint8List foto;
  Usuario({
    @required this.nombre,
    @required this.titulo,
    @required this.correoInstitucional,
    @required this.foto,
  });
}