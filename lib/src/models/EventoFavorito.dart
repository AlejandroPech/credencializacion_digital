import 'package:credencializacion_digital/src/models/Evento.dart';
import 'package:credencializacion_digital/src/models/Favorito.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

class EventoFavorito{
  int eventoId;
  int favoritoId;
  Evento evento;
  Favorito favorito;
  EventoFavorito({
    @required this.eventoId,
    @required this.favoritoId,
    @required this.evento,
    @required this.favorito,
  });

  factory EventoFavorito.fromJson(Map<String,dynamic> json)=>EventoFavorito(
    eventoId: json['eventId']??0,
    favoritoId: json['favoriteId']??0,
    evento: json['event']??new Evento(eventoId: 0, titulo: '', contenido: '', fechaInicio: DateTime.now(), fechaFinal: DateTime.now(), autor: Autor(idAutor: 0,nombre: ''), urlImagen: '', esActivo: false, esSugerido: false, esPublicado: false, eventosFavoritos: []),
    favorito: Favorito.fromJson(json['favorite']),
  );
}