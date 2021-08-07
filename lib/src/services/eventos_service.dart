import 'package:credencializacion_digital/src/models/Evento.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

final _urlEventos='http://192.168.54.100:9095/api/Event/GetPublished';

class EventosService with ChangeNotifier{
  List<Evento> eventos=[];
  Map<String,dynamic> eventoResponse={};
  EventosService(){
    
    getEvents();
  }

  getEvents()async{
    
    final newResponse=await http.get(Uri.parse(_urlEventos));
    final response=eventosResponse(newResponse.body);
    // eventos=[];
    this.eventos.addAll(response.eventos);
    notifyListeners();
  }

}