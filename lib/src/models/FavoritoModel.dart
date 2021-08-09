import 'package:credencializacion_digital/src/models/EventoModel.dart';
import 'package:meta/meta.dart';

class Favorito{
  int favoritoId;
  String matricula;
  List<Evento> eventos=[];

  Favorito({@required this.matricula,@required this.favoritoId});
  factory Favorito.fromJson(Map<String,dynamic> json)=>Favorito(
    favoritoId: json['id']??0,
    matricula: json['matricula']??'',
  );
}