import 'dart:convert';

import 'package:credencializacion_digital/src/models/EventoModel.dart';
import 'package:credencializacion_digital/src/models/FavoritoModel.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// final _urlApi='http://192.168.54.100:9095/api/';
final _urlApi='http://192.168.54.100:9096/api/';

class EventosService with ChangeNotifier{
  List<Evento> eventos=[];
  List<String> categorias=['Todos','Hoy','Esta Semana','Este Quatri', 'Este año'];
  String _categoriaSeleccionada='Todos';
  Map<String,List<Evento>> categoriasEvento={};
  bool _estaCargando=true;
  PrefUser prefUser = new PrefUser();
  EventosService(){
    this.getEvents();
    categorias.forEach((element) {
      this.categoriasEvento[element]=[];
    });
    this.getEventoCategoria(_categoriaSeleccionada);
  }

  getEvents()async{
    
    final newResponse=await http.get(Uri.parse(_urlApi+'Event/GetPublished'));
    final response=eventosResponse(newResponse.body);
    // eventos=[];
    this.eventos.addAll(response.eventos);
    notifyListeners();
  }

  String get categoriaSeleccionada=>_categoriaSeleccionada;

  set categoriaSeleccionada(String value){
    this._categoriaSeleccionada=value;
    this.getEventoCategoria(value);
    notifyListeners();
  }

  getEventoCategoria(String categoria)async{
    if(this.categoriasEvento[categoria].length>0){
      this._estaCargando=false;
      return this.categoriasEvento[categoria];
    }
    String url=getCategory(categoria);
    this._estaCargando=true;
    final newResponse=await http.get(Uri.parse(_urlApi+'Event/'+url));
    final response=eventosResponse(newResponse.body);
    this._estaCargando=false;
    this.categoriasEvento[categoria].addAll(response.eventos);
    notifyListeners();
  }
  String getCategory(String value){
    switch(value){
      case 'Todos':
        return 'GetPublished';
        break;
      case 'Hoy':
        return 'GetToday';
        break;
      case 'Esta Semana':
        return 'GetWeek';
        break;
      case 'Este Quatri':
        return 'GetQuarter';
        break;
      case 'Este año':
        return 'GetYear';
        break;
      default:
        return 'GetPublished';
        break;
    }
  }

  bool get estaCargando => this._estaCargando;

  List<Evento> get getEventosSeleccionados=>this.categoriasEvento[this._categoriaSeleccionada]??[];

  checkLikeEvent(String identificador,int eventoID){
    Evento evento=categoriasEvento['Todos'].firstWhere((element) => element.eventoId==eventoID);
    if(evento.favoritos.any((element) => element.identificador==identificador)){
      eliminarLike(identificador, eventoID);
    }else{
      agregarLike(identificador, eventoID);
    }
  }

  agregarLike(String identificador,int eventoID)async {
    Map<String,dynamic>body ={"clave": identificador,"eventId": eventoID,};
    var response= await http.post(Uri.parse(_urlApi+'Favorites'),
      body:json.encode(body),
    );
    categorias.forEach((element) {
      if(categoriasEvento[element].length>0){
        categoriasEvento[element].firstWhere((element) => element.eventoId==eventoID).favoritos.add(new Favorito(identificador: identificador));
      }
    });
    notifyListeners();
  }
  eliminarLike(String identificador,int eventoID)async {
    Map<String,dynamic>body ={"clave": identificador,"eventId": eventoID,};
    var response=await http.delete(Uri.parse(_urlApi+'Favorites'),
      body: jsonEncode(body),
    );
    categorias.forEach((element) {
      if(categoriasEvento[element].length>0){
        categoriasEvento[element].firstWhere((element) => element.eventoId==eventoID).favoritos.removeWhere((element) => element.identificador==identificador);
      }
    });
    notifyListeners();
  }

  List<Evento> get obtenerFavoritos=>categoriasEvento['Todos'].where((element) => element.favoritos.any((element) => element.identificador==prefUser.identificadorUsuario)).toList();
}