import 'dart:convert';
import 'dart:typed_data';
import 'package:meta/meta.dart';

Alumno alumnoResponse(String str,String foto)=>Alumno.fromJson(json.decode(str), foto);

class Alumno{
  String matricula;
  String nombre;
  String titulo;
  String correoInstitucional;
  Uint8List foto;
  Alumno({
    @required this.matricula,
    @required this.nombre,
    @required this.titulo,
    @required this.correoInstitucional,
    @required this.foto,
  });

  factory Alumno.fromJson(Map<String,dynamic> json,String foto)=>Alumno(
    matricula: json['mail'].toString().substring(0,8)??'',
    nombre: json['displayName']??'',
    titulo: json['jobTitle']??'',
    correoInstitucional: json['mail']??'',
    foto: Uint8List.fromList(foto.codeUnits)??[],
  );
}