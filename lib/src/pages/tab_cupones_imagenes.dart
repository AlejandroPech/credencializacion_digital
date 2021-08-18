import 'dart:convert';

import 'package:credencializacion_digital/src/models/CuponesImagen.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:credencializacion_digital/src/widgets/ventana_dialogo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

class TabCuponesImagen extends StatefulWidget {
  static final String routeName = 'empresaCupones';
  final String idEm;
  final String image;

  TabCuponesImagen({Key key,@required this.idEm,@required this.image})
      : super(key: key);

  @override
  _TabCuponesImagenState createState() => _TabCuponesImagenState();
}

class _TabCuponesImagenState extends State<TabCuponesImagen> {
  List<CuponesImagen> _listCuponesImagen = [];
  String idCupon;
  final String baseurl = "http://192.168.54.102:9097/api";

  void _dataFromApi() async {
    final Dio dio = new Dio();
    try {
      var response = await dio.get("$baseurl/CuponesImagen/empresa/${widget.idEm}");

      var responseData = response.data as List;
      if(mounted){
        setState(() {
          _listCuponesImagen = responseData.map((e) => CuponesImagen.fromJson(e)).toList();
        });
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _dataFromApi();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CuponesImagenPagina(
                size: size,
                listCuponesImagen: _listCuponesImagen,
                imagen: widget.image,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CuponesImagenPagina extends StatelessWidget {
  final String imagen;
  const CuponesImagenPagina({
    Key key,
    @required this.size,
    @required List<CuponesImagen> listCuponesImagen,
    @required this.imagen,
  })  : _listCuponesImagen = listCuponesImagen,
        super(key: key);

  final Size size;
  final List<CuponesImagen> _listCuponesImagen;

  @override
  Widget build(BuildContext context) {
    final PrefUser prefUser=PrefUser();
    return SafeArea(
      child: ListView(
        children: [
          _Cupnoes(size: size, listaCupones: _listCuponesImagen,prefUser:prefUser),
        ],
      ),
    );
  }
}

class _Cupnoes extends StatelessWidget {
  final Size size;
  final List<CuponesImagen> listaCupones;
  final PrefUser prefUser;

  const _Cupnoes({this.size, this.listaCupones,@required this.prefUser});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...listaCupones.map((cupones) => _Cupon(
            urlImage: "${cupones.imagen}",
            size: size,
            descripcion: ("${cupones.descripcion}"),
            idCupon: ("${cupones.cuponesImagenId}"),
            listaCupones: listaCupones,
            prefUser: prefUser,
          )),
    ]);
  }
}

class _Cupon extends StatelessWidget {
  final Size size;
  final String urlImage;
  final String descripcion;
  final String idCupon;
  final PrefUser prefUser;
  final List<CuponesImagen> listaCupones;
  const _Cupon(
      {@required this.urlImage,
      @required this.size,
      @required this.descripcion,
      @required this.prefUser,
      this.idCupon,
      this.listaCupones});

  @override
  Widget build(BuildContext context) {
    final String baseurl = "http://192.168.54.102:9097/api";
    void _usarCupon() async {
      final Dio dio = new Dio();
      try {
        var respuesta = await dio.get("$baseurl/CuponesImagen/${this.idCupon}");
        print(respuesta.statusCode);
        print(respuesta.data);

        Map<String, dynamic> listacupon ={
        'cuponImagenId':this.idCupon,
        'matricula':prefUser.identificadorUsuario,
        'cuponGeneridoId':null,
        'departamento':prefUser.departamento,
      };

        if (respuesta.statusCode == 200) {
          var response = await dio.put(
              "$baseurl/CuponesImagen/apply/?id=${this.idCupon}",
              data: jsonEncode(listacupon));
          if (response.statusCode == 200) {
            showDialog(context: context, builder: (context){
              return VentanaDialogo(
                titulo: "Cupon Utilizado", 
                cuerpo: "El cupon se ha utilizado correctamente",
                imagen: Image.memory(base64Decode("${this.urlImage}")),
              );
            });
            print("cupon usado");
          } else {
            showDialog(context: context, builder: (context){
            return VentanaDialogo(
              titulo: "Error", 
              cuerpo: "Lo sentimos pero ha ocurrido un error, intentelo nuevamente mas tarde",
            );
          });
          }
        } else {
          showDialog(context: context, builder: (context){
            return VentanaDialogo(
              titulo: "Error", 
              cuerpo: "Lo sentimos pero ha ocurrido un error, intentelo nuevamente mas tarde",
            );
          });
        }
      } on DioError catch (e) {
        print(e);
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      height: size.height / 4,
      child: Card(
        child: Row(
          children: [
            Container(
              width: size.height / 4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(base64Decode("${this.urlImage}"))
                  )
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  'Descripción:  ${this.descripcion}',
                                  style: TextStyle(fontSize: 20),
                                ))),
                      ],
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        _usarCupon();
                      },
                      child: Text('Aplicar Cupón'),
                      style: ElevatedButton.styleFrom(
                          primary: appTheme.accentColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
