import 'dart:convert';

import 'package:credencializacion_digital/src/models/EventoModel.dart';
import 'package:credencializacion_digital/src/models/FavoritoModel.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// final _urlApi='http://192.168.54.100:9095/api/';
final _urlApi='http://192.168.54.102:9096/api/';

class EventosService with ChangeNotifier{
  List<String> categorias=['Todos','Hoy','Esta Semana','Este Cuatrimestre', 'Este año'];
  String _categoriaSeleccionada='Todos';
  Map<String,List<Evento>> categoriasEvento={};
  bool _estaCargando=true;
  PrefUser prefUser = new PrefUser();
  EventosService(){
    categorias.forEach((element) {
      this.categoriasEvento[element]=[];
    });
    this.getEventoCategoria(_categoriaSeleccionada);
  }

  String get categoriaSeleccionada=>_categoriaSeleccionada;

  set categoriaSeleccionada(String value){
    this._categoriaSeleccionada=value;
    this.getEventoCategoria(value);
    notifyListeners();
  }

  getEventoCategoria(String categoria)async{
    if(this.categoriasEvento[categoria].length<=0){
      this._estaCargando=true;
    }
    String url=getCategory(categoria);
    final newResponse=await http.get(Uri.parse(_urlApi+'Event/'+url));
    final response=eventosResponse(newResponse.body);
    this._estaCargando=false;
    this.categoriasEvento[categoria]=[];
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
      case 'Este Cuatrimestre':
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
    final jsonBody=json.encode(body);
    var response= await http.post(Uri.parse(_urlApi+'Favorites'),
      body:jsonBody,
      headers: {"Content-Type": "application/json", "Accept" : "application/json"},
    );
    if(response.statusCode>=200 && response.statusCode<300){
      categorias.forEach((element) {
        if(categoriasEvento[element].any((element) => element.eventoId==eventoID)){
          categoriasEvento[element].firstWhere((element) => element.eventoId==eventoID).favoritos.add(new Favorito(identificador: identificador));
        }
      });
      notifyListeners();
    }
    
  }
  eliminarLike(String identificador,int eventoID)async {
    Map<String,dynamic>body ={"clave": identificador,"eventId": eventoID,};
    var response=await http.delete(Uri.parse(_urlApi+'Favorites'),
      body: jsonEncode(body),
      headers: {"Content-Type": "application/json", "Accept" : "application/json"},
    );
    if(response.statusCode>=200 || response.statusCode<300){
      categorias.forEach((element) {
        if(categoriasEvento[element].any((element) => element.eventoId==eventoID)){
          categoriasEvento[element].firstWhere((element) => element.eventoId==eventoID).favoritos.removeWhere((element) => element.identificador==identificador);
        }
      });
      notifyListeners();
    }
  }

  List<Evento> get obtenerFavoritos=>categoriasEvento['Todos'].where((element) => element.favoritos.any((element) => element.identificador==prefUser.identificadorUsuario)).toList();
}