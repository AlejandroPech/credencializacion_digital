import 'package:credencializacion_digital/src/models/EventoFavorito.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

EventosResponse eventosResponse(String str)=>EventosResponse.fromJson(json.decode(str));

class EventosResponse{
  List<Evento> eventos;
  EventosResponse({
    @required this.eventos,
  });

  factory EventosResponse.fromJson(Map<String,dynamic> json)=>EventosResponse(
    eventos: List<Evento>.from(json['data'].map((x) => Evento.fromJson(x))),
  );
}

class Evento{
  int eventoId;
  String titulo;
  String contenido;
  DateTime fechaInicio;
  DateTime fechaFinal;
  Autor autor;
  String urlImagen;
  bool esActivo;
  bool esSugerido;
  bool esPublicado;
  List<EventoFavorito> eventosFavoritos;
  Evento({
    @required this.eventoId,
    @required this.titulo,
    @required this.contenido,
    @required this.fechaInicio,
    @required this.fechaFinal,
    @required this.autor,
    @required this.urlImagen,
    @required this.esActivo,
    @required this.esSugerido,
    @required this.esPublicado,
    @required this.eventosFavoritos,
  });

  factory Evento.fromJson(Map<String,dynamic> json)=>Evento(
    eventoId: json['id']??0,
    titulo: json['title']??'',
    contenido: json['content']??'',
    fechaInicio:DateTime.parse(json['startDate'])??DateTime.now(),
    fechaFinal: DateTime.parse(json['endDate'])??DateTime.now(),
    autor:Autor.fromJson(json['author'])??Autor(idAutor: 0, nombre: ''),
    urlImagen: json['image']??'',
    esActivo: json['isActive']??false,
    esSugerido: json['isSuggest']??false,
    esPublicado: json['isPublished']??false,
    eventosFavoritos: List<EventoFavorito>.from(json['eventFavorite'].map((x) => EventoFavorito.fromJson(x)))
  );
}

class Autor{
  int idAutor;
  String nombre;
  Autor({
    @required this.idAutor,
    @required this.nombre,
  });

  factory Autor.fromJson(Map<String,dynamic> json)=>Autor(
    idAutor: json['id']??0,
    nombre: json['name']??'',
  );
}