import 'dart:convert';

import 'package:credencializacion_digital/src/models/EventoModel.dart';
import 'package:credencializacion_digital/src/services/eventos_service.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:photo_view/photo_view.dart';

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

class _TarjetaImagen extends StatelessWidget {
  final Evento evento;
  const _TarjetaImagen({@required this.evento});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:155,
      margin: EdgeInsets.only(top: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Imagen(evento: evento),
          TituloyFecha(evento: evento),
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
    return Expanded(
      child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children:[
            Expanded(
              child: Container(
                margin:EdgeInsets.only(left:10),
                child: Text(evento.titulo,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text((DateFormat.yMMMMd('es').format(evento.fechaInicio)),textAlign: TextAlign.center,),
              ],
            ),
          ]
        ),
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
      height:150,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        child: (evento.urlImagen.isNotEmpty)
          ? ImageFullScreenWrapperWidget(child: Image.memory(base64Decode(evento.urlImagen),gaplessPlayback: true,fit: BoxFit.cover,),) 
          : Image(image: AssetImage('assets/img/no-image.png'),)
        
      ),
    );
  }
}

class ImageFullScreenWrapperWidget extends StatelessWidget {
  final Image child;
  final bool dark;

  ImageFullScreenWrapperWidget({@required this.child,this.dark = true,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: true,
            barrierColor: dark ? Colors.black : Colors.white,
            pageBuilder: (BuildContext context, _, __) {
              return FullScreenPage(
                child: child,
                dark: dark,
              );
            },
          ),
        );
      },
      child: child,
    );
  }
}
class FullScreenPage extends StatelessWidget {
  FullScreenPage({@required this.child,@required this.dark,});
  final Image child;
  final bool dark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Center(
            child: Stack(
              children: [
                PhotoView(imageProvider: child.image,minScale:0.25,maxScale: 1.5,)
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: MaterialButton(
                padding: const EdgeInsets.all(15),
                elevation: 0,
                child: Icon(
                  Icons.arrow_back,
                  color: dark ? Colors.white : Colors.black,
                  size: 25,
                ),
                color: dark ? Colors.black12 : Colors.white70,
                highlightElevation: 0,
                minWidth: double.minPositive,
                height: double.minPositive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
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