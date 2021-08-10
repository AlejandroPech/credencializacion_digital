import 'package:credencializacion_digital/src/models/EventoModel.dart';
import 'package:meta/meta.dart';

class Favorito{
  String identificador;
  List<Evento> eventos=[];

  Favorito({@required this.identificador});
  factory Favorito.fromJson(Map<String,dynamic> json)=>Favorito(
    identificador: json['matricula']??'',
  );
}