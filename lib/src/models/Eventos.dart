import 'package:meta/meta.dart';
class Eventos{
  int eventoId;
  String urlImage;
  String titulo;
  String cuerpo;
  DateTime fechaEvento;
  bool meGusta;
  String departamento;
  bool recomendado;
  
  Eventos({
    @required this.eventoId,
    @required this.urlImage,
    @required this.titulo,
    @required this.cuerpo,
    @required this.fechaEvento,
    @required this.meGusta,
    @required this.departamento,
    @required this.recomendado
  });
}