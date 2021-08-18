import 'dart:convert';

import 'package:credencializacion_digital/src/models/EventoModel.dart';
import 'package:credencializacion_digital/src/services/eventos_service.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:credencializacion_digital/src/widgets/imagen_pantalla_completa.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';

class ListaEventos extends StatefulWidget {
  const ListaEventos({
    @required this.eventos,
  });

  final List<Evento> eventos;

  @override
  _ListaEventosState createState() => _ListaEventosState();
}

class _ListaEventosState extends State<ListaEventos> {
  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es');
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.eventos.length,
      itemBuilder: (BuildContext context,int index){
        return _Evento(evento: widget.eventos[index],index: index,);
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
          // _TarjetaTitulo(evento: evento,),
          _TarjetaCabecera(evento:evento),
          _TarjetaCuerpo(evento: evento),
          _TarjetaBotones(evento: evento),
          SizedBox(height: 5),
          Divider(height: 4,thickness: 3,),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

class _TarjetaCabecera extends StatelessWidget {
  final Evento evento;
  const _TarjetaCabecera({@required this.evento});
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:(evento.urlImagen.isNotEmpty)
        ?BoxConstraints(minHeight:100, maxHeight: 160)
        :BoxConstraints(minHeight:0),
      margin: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(evento.urlImagen.isNotEmpty) 
            _Imagen(evento: evento),
            Expanded(child: TituloyFecha(evento: evento))
        ],
      ),
    );
  }
}

class TituloyFecha extends StatelessWidget {
  const TituloyFecha({@required this.evento,});

  final Evento evento;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:[
          Container(
                  margin:EdgeInsets.only(left:10),
                  child: Text(evento.titulo+'',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),maxLines: 5,)
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text((DateFormat.yMMMMd('es').format(evento.fechaInicio)),textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
            ],
          ),
        ]
      );
  }
}

class _Imagen extends StatelessWidget {
  const _Imagen({@required this.evento,});

  final Evento evento;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height:155,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        child: ImagenPantallaCompleta(child: Image.memory(base64Decode(evento.urlImagen),gaplessPlayback: true,fit: BoxFit.cover,),)
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
          buildPanel(title: Text(evento.autor.nombre,style: TextStyle(color: Colors.black),),
          body: Html(data: evento.contenido,),),
        ],
      ),
    );
  }
  Widget buildPanel({@required Text title,@required Html body}){
    return ExpansionTile(
      title: title,
      children: [
        if(evento.esSugerido)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children:[
              Text('Sugerido',style: TextStyle(color: Colors.red),),
            ]
          ),

        body,
      ],
    );
  }
}

class _TarjetaBotones extends StatelessWidget {
  final Evento evento;
  const _TarjetaBotones({@required this.evento});

  @override
  Widget build(BuildContext context) {
    final eventoService = Provider.of<EventosService>(context);
    final prefUser = PrefUser();
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: (){
              eventoService.checkLikeEvent(prefUser.identificadorUsuario, evento.eventoId);
            },
            child:(evento.favoritos.any((element) => element.identificador==prefUser.identificadorUsuario))?Icon(Icons.favorite,color: Colors.red):Icon(Icons.favorite)
          ),
        ],
      ),
    );
  }
}