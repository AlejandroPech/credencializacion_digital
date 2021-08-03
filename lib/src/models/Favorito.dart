import 'package:meta/meta.dart';
import 'dart:convert';

class Favorito{
  int favoritoId;
  String matricula;

  Favorito({@required this.matricula,@required this.favoritoId});
  factory Favorito.fromJson(Map<String,dynamic> json)=>Favorito(
    favoritoId: json['id']??0,
    matricula: json['matricula']??'',
  );
}