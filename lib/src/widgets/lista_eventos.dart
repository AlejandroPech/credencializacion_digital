import 'dart:convert';

import 'package:credencializacion_digital/src/models/EventoModel.dart';
import 'package:credencializacion_digital/src/services/eventos_service.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';

class ListaEventos extends StatelessWidget {
  const ListaEventos({
    @required this.eventos,
  });

  final List<Evento> eventos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: eventos.length,
      itemBuilder: (BuildContext context,int index){
        return _Evento(evento: eventos[index],index: index,);
      },
    );
  }
}

class _Evento extends StatelessWidget {
  final Evento evento;
  final int index;

  const _Evento({@required this.evento,@required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TarjetaTitulo(evento: evento,),
          _TarjetaImagen(evento:evento),
          _TarjetaCuerpo(evento: evento),
          _TarjetaBotones(evento: evento),
          SizedBox(height: 5),
          Divider(height: 2,thickness: 2,),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

class _TarjetaTitulo extends StatelessWidget {
  final Evento evento;

  const _TarjetaTitulo({@required this.evento});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(evento.titulo,style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
    );
  }
}

class _TarjetaImagen extends StatelessWidget {
  final Evento evento;
  const _TarjetaImagen({@required this.evento});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
        child: (evento.urlImagen.isNotEmpty)? Image.memory(base64Decode(evento.urlImagen))
          :Image(image: AssetImage('assets/img/no-image.png'),)
        
      ),
    );
  }
}

class _TarjetaCuerpo extends StatelessWidget {
  final Evento evento;

  const _TarjetaCuerpo({@required this.evento});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(evento.autor.nombre,style: TextStyle(fontSize: 22),),
          Html(data: evento.contenido),
          // Text(evento.contenido,style: TextStyle(fontSize: 20),),
        ],
      ),
    );
  }
}

class _TarjetaBotones extends StatelessWidget {
  final Evento evento;

  const _TarjetaBotones({@required this.evento});

  @override
  Widget build(BuildContext context) {
    final appTheme= Provider.of<ThemeChanger>(context).currentTheme;
    final eventoService = Provider.of<EventosService>(context);
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              eventoService.getEvents();
              print('hey');
            },
            child:(evento.favoritos.any((element) => element.matricula=='123456789'))?Icon(Icons.favorite,color: appTheme.accentColor,):Icon(Icons.favorite)
          ),
          Text(evento.fechaInicio.toString())
        ],
      ),
    );
  }
}