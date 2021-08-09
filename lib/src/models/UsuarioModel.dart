import 'dart:convert';
import 'dart:typed_data';
import 'package:meta/meta.dart';

Usuario alumnoResponse(String str,String foto)=>Usuario.fromJsonAlumno(json.decode(str), foto);
Usuario empleadoResponse(String str, String foto)=>Usuario.fromJsonEmpleado(json.decode(str), foto);
class Usuario{
  String identificador;
  String nombre;
  String titulo;
  String correoInstitucional;
  String departamento;
  Uint8List foto;
  Usuario({
    @required this.identificador,
    @required this.nombre,
    @required this.titulo,
    @required this.correoInstitucional,
    @required this.departamento,
    @required this.foto,
  });

  factory Usuario.fromJsonAlumno(Map<String,dynamic> json,String foto)=>Usuario(
    identificador: json['mail'].toString().substring(0,8)??'',
    nombre: json['displayName']??'',
    titulo: json['jobTitle']??'',
    correoInstitucional: json['mail']??'',
    departamento:(json['officeLocation']!=null)?json['officeLocation']:'',
    foto: Uint8List.fromList(foto.codeUnits)??[],
  );
  factory Usuario.fromJsonEmpleado(Map<String,dynamic> json,String foto)=>Usuario(
    identificador: json['ClaveEmpleado'],
    nombre: (json['PrimerNombre']+" "??'')+(json['SegundoNombre']+" "??'')+(json['PrimerApellido']+" "??'')+(json['SegundoApellido']+" "??''),
    titulo: json['TipoEmpleado'],
    correoInstitucional: json['CorreoInstitucional'],
    departamento: json['Departamento'],
    foto: Uint8List.fromList(foto.codeUnits)??[],
  );
}