import 'dart:typed_data';
import 'package:meta/meta.dart';

class Usuario{
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