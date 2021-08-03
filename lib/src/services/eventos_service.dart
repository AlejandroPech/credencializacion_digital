import 'dart:convert';

import 'package:credencializacion_digital/src/models/Evento.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class EventosService with ChangeNotifier{
  List<Evento> eventos=[];
  Map<String,dynamic> eventoResponse={};
  EventosService(){
    
    getEvents();
  }

  getEvents()async{
    eventoResponse={
      "data":[
        {
          'id':1,
          'title':'Ejemplo',
          'content':'Ejemplo del contenido de un evento o noticia de la UTM',
          'startDate':DateTime.now().toIso8601String(),
          'endDate':DateTime.now().toIso8601String(),
          'author':{
            'id':20,
            'name':'Carlos Canto'
          },
          'image':'https://www.yucatanencorto.com/noticias/wp-content/uploads/2019/11/IMG_20191108_105257.jpg',
          'isActive':true,
          'isSuggest':true,
          'isPublished':true,
          'eventFavorite':[
            {
              'eventId':1,
              'favoriteId':1,
              'event':null,
              'favorite':{
                'id':1,
                'matricula':'12345678',
              }
            },
          ]
        },
        {
          'id':1,
          'title':'Ejemplo',
          'content':'Ejemplo del contenido de un evento o noticia de la UTM',
          'startDate':DateTime.now().toIso8601String(),
          'endDate':DateTime.now().toIso8601String(),
          'author':{
            'id':20,
            'name':'Carlos Canto'
          },
          'image':'https://www.yucatanencorto.com/noticias/wp-content/uploads/2019/11/IMG_20191108_105257.jpg',
          'isActive':true,
          'isSuggest':true,
          'isPublished':true,
          'eventFavorite':[
            {
              'eventId':1,
              'favoriteId':1,
              'event':null,
              'favorite':{
                'id':1,
                'matricula':'12345678',
              }
            },
            {
              'eventId':1,
              'favoriteId':1,
              'event':null,
              'favorite':{
                'id':1,
                'matricula':'123456789',
              }
            },
          ]
        },
        {
          'id':1,
          'title':'Ejemplo',
          'content':'Ejemplo del contenido de un evento o noticia de la UTM',
          'startDate':DateTime.now().toIso8601String(),
          'endDate':DateTime.now().toIso8601String(),
          'author':{
            'id':20,
            'name':'Carlos Canto'
          },
          'image':'https://www.yucatanencorto.com/noticias/wp-content/uploads/2019/11/IMG_20191108_105257.jpg',
          'isActive':true,
          'isSuggest':true,
          'isPublished':true,
          'eventFavorite':[
            {
              'eventId':1,
              'favoriteId':1,
              'event':null,
              'favorite':{
                'id':1,
                'matricula':'12345678',
              },
            },
            {
              'eventId':1,
              'favoriteId':2,
              'event':null,
              'favorite':{
                'id':2,
                'matricula':'123456789',
              },
            },
          ]
        },
      ]
    };
    final response=eventosResponse((JsonEncoder().convert(eventoResponse)));
    eventos=[];
    this.eventos.addAll(response.eventos);
    notifyListeners();
  }

}