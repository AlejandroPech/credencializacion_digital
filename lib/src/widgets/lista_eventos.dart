import 'dart:convert';

import 'package:credencializacion_digital/src/models/EventoModel.dart';
import 'package:credencializacion_digital/src/services/eventos_service.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
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
          _TarjetaImagen(evento:evento),
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
      margin: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height:150,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              child: (evento.urlImagen.isNotEmpty)? Image.memory(base64Decode(evento.urlImagen),gaplessPlayback: true,fit: BoxFit.cover,)
                :Image(image: AssetImage('assets/img/no-image.png'),)
              
            ),
          ),
          Expanded(
            child: Column(
              children:[
                Text(evento.titulo+" cosa",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),maxLines: 4,),
                Text((DateFormat.yMMMMd('es').format(evento.fechaInicio)).toString(),textAlign: TextAlign.center,)
              ]
            ),
          ),
          
        ],
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
          Html(data: evento.contenido,
          style: {'color':Style(color: Colors.red)},
          ),
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
          Text(evento.fechaInicio.toString())
        ],
      ),
    );
  }
}