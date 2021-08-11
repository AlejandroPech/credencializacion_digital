import 'dart:convert';
import 'dart:typed_data';

import 'package:credencializacion_digital/src/models/CuponesImagen.dart';
import 'package:credencializacion_digital/src/pages/empresa_cupon_page.dart';
import 'package:credencializacion_digital/src/pages/empresas_page.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';

class EmpresaCuponesPage extends StatefulWidget {
  static final String routeName = 'empresaCupones';
  final String title;
  final String idEm;
  final String image;

  EmpresaCuponesPage({Key key, @required this.title, this.idEm, this.image})
      : super(key: key);

  @override
  _EmpresaCuponesPageState createState() => _EmpresaCuponesPageState();
}

class _EmpresaCuponesPageState extends State<EmpresaCuponesPage> {
  List<CuponesImagen> _listCuponesImagen = [];
  String idCupon;
  final String baseurl = "http://192.168.54.102:9097/api";

  void _dataFromApi() async {
    final Dio dio = new Dio();
    try {
      var response =
          await dio.get("$baseurl/CuponesImagen/empresa/${widget.idEm}");
      print(response.statusCode);
      print(response.data);

      var responseData = response.data as List;

      setState(() {
        _listCuponesImagen = responseData.map((e) => CuponesImagen.fromJson(e)).toList();
      });
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
      body: PageView(
        children: [
          CuponesImagenPagina(
            size: size,
            listCuponesImagen: _listCuponesImagen,
            imagen: widget.image,
          ),
          EmpresaCuponPage(
            title: "empresa",
            idEm: widget.idEm,
            image: widget.image,
          )
        ],
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
    return SafeArea(
      child: ListView(
        children: [
          _ImagenAndButtonBack(
            size: size,
            imagen: this.imagen,
          ),
          // _Usuario(size: size),
          _Cupnoes(size: size, listaCupones: _listCuponesImagen),
        ],
      ),
    );
  }
}

class _ImagenAndButtonBack extends StatelessWidget {
  final Size size;
  final String imagen;

  const _ImagenAndButtonBack({@required this.size, @required this.imagen});

  @override
  Widget build(BuildContext context) {
    final prefUser = PrefUser();

    final String baseurl = "http://192.168.54.102:9097/api";
    return Stack(
      children: [
        Container(
          height: size.height / 4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(base64Decode("${this.imagen}")))),
        ),
        SafeArea(
          child: BackButton(),
        ),
      ],
    );
  }
}

class _Usuario extends StatelessWidget {
  const _Usuario({
    @required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final prefUser = PrefUser();
    return Container(
      height: size.height / 6,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
              radius: size.height / 20,
              backgroundImage: MemoryImage(
                  Uint8List.fromList(prefUser.imagenUsuario.codeUnits))),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width * 0.7,
                child: Text(
                  prefUser.nombreUsuario,
                  style: TextStyle(
                    fontSize: 26,
                  ),
                  maxLines: 2,
                ),
              ),
              SizedBox(height: 4),
              Container(
                width: size.width * 0.7,
                child: Text(
                  'Univeridad Tecnologica Metropolitana',
                  style: TextStyle(fontSize: 16),
                  maxLines: 2
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Cupnoes extends StatelessWidget {
  final Size size;
  final List<CuponesImagen> listaCupones;
  const _Cupnoes({this.size, this.listaCupones});

  @override
  Widget build(BuildContext context) {
    final Dio dio = new Dio();
    final String baseurl = "http://192.168.54.102:9097/api";
    return Column(children: [
      ...listaCupones.map((cupones) => _Cupon(
            urlImage: "${cupones.imagen}",
            size: size,
            descripcion: ("${cupones.descripcion}"),
            idCupon: ("${cupones.cuponesImagenId}"),
            listaCupones: listaCupones,
          )),
    ]);
  }
}

class _Cupon extends StatelessWidget {
  final Size size;
  final String urlImage;
  final String descripcion;
  final String idCupon;
  final List<CuponesImagen> listaCupones;
  const _Cupon(
      {@required this.urlImage,
      @required this.size,
      @required this.descripcion,
      this.idCupon,
      this.listaCupones});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    final String baseurl = "http://192.168.54.102:9097/api";
    void _usarCupon() async {
      final Dio dio = new Dio();
      try {
        var respuesta = await dio.get("$baseurl/CuponesImagen/${this.idCupon}");
        print(respuesta.statusCode);
        print(respuesta.data);

        Map<String, dynamic> listacupon =
            new Map<String, dynamic>.from(respuesta.data);

        if (respuesta.statusCode == 200) {
          var response = await dio.put(
              "$baseurl/CuponesImagen/apply/?id=${this.idCupon}",
              data: jsonEncode(listacupon));
          if (response.statusCode == 200) {
            print("cupon usado");
          } else {
            print("cupon no usado");
          }
        } else {
          print("Error en status code");
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
                      image: MemoryImage(base64Decode("${this.urlImage}")))),
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

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmpresaPage(
                                    title: "Empresa",
                                  )),
                        );
                      },
                      child: Text('Aplicar Cupón'),
                      style: ElevatedButton.styleFrom(
                          primary: appTheme.currentTheme.accentColor),
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
