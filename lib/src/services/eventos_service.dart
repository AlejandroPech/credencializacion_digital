import 'package:credencializacion_digital/src/models/EventoModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final _urlEventos='http://192.168.54.100:9095/api/Event/';

class EventosService with ChangeNotifier{
  List<Evento> eventos=[];
  List<String> categorias=['Todos','Hoy','Esta Semana','Este Quatri', 'Este año'];
  String _categoriaSeleccionada='Todos';
  Map<String,List<Evento>> categoriasEvento={};
  bool _estaCargando=true;

  EventosService(){
    this.getEvents();
    categorias.forEach((element) {
      this.categoriasEvento[element]=[];
    });
    this.getEventoCategoria(_categoriaSeleccionada);
  }

  getEvents()async{
    
    final newResponse=await http.get(Uri.parse(_urlEventos+'GetPublished'));
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
    final newResponse=await http.get(Uri.parse(_urlEventos+url));
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
}