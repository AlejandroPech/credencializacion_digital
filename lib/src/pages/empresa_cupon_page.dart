import 'dart:convert';
import 'dart:typed_data';

import 'package:credencializacion_digital/src/pages/empresas_page.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';
import 'package:credencializacion_digital/src/models/CuponesGenericos.dart';
import 'package:dio/dio.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';

class EmpresaCuponPage extends StatefulWidget {
  static final String routeName = 'empresaCupon';
  final String title;
  final String idEm;
  final String image;
  EmpresaCuponPage({Key key, @required this.title, this.idEm, this.image})
      : super(key: key);

  @override
  _EmpresaCuponPageState createState() => _EmpresaCuponPageState();
}

class _EmpresaCuponPageState extends State<EmpresaCuponPage> {
  List<CuponesGenericos> _listCuponesGenericos = [];

  final String baseurl = "https://c324a5a94838.ngrok.io";

  void _dataFromApi() async {
    final Dio dio = new Dio();
    try {
      var response =
          await dio.get("$baseurl/api/CuponesGenericos/empresa/${widget.idEm}");
      print(response.statusCode);
      print(response.data);

      var responseData = response.data as List;

      setState(() {
        _listCuponesGenericos =
            responseData.map((e) => CuponesGenericos.fromJson(e)).toList();
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
    List<CuponesGenericos> _listCuponGenerico = _listCuponesGenericos;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            _ImagenAndButtonBack(
              size: size,
              urlImage: widget.image,
            ),
            _Usuario(size: size),
            _Cuerpo(
              cuponGenerico: _listCuponGenerico,
              idCupon: widget.idEm,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagenAndButtonBack extends StatelessWidget {
  final String urlImage;
  const _ImagenAndButtonBack({@required this.size, this.urlImage});

  final Size size;

  @override
  Widget build(BuildContext context) {
    final baseurl = "https://c324a5a94838.ngrok.io";
    return Stack(
      children: [
        Container(
          height: size.height / 4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "$baseurl/api/empresas/image?nombreArchivo=${this.urlImage}"))),
        ),
        SafeArea(
          child: BackButton(),
        ),
      ],
    );
  }
}

class _Cuerpo extends StatelessWidget {
  final List<CuponesGenericos> cuponGenerico;
  final String idCupon;
  const _Cuerpo({this.cuponGenerico, this.idCupon});
  final String baseurl = "https://c324a5a94838.ngrok.io";

  void _usarCupon() async {
    final Dio dio = new Dio();
    try {
      var respuesta =
          await dio.get("$baseurl/api/CuponesGenericos/${this.idCupon}");
      print(respuesta.statusCode);
      print(respuesta.data);

      Map<String, dynamic> listacupon =
          new Map<String, dynamic>.from(respuesta.data);

      if (respuesta.statusCode == 200) {
        var response = await dio.put(
            "$baseurl/api/CuponesGenericos/apply?id=${listacupon['cuponGeneridoId']}",
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

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeChanger>(context);
    final Dio dio = new Dio();
    final baseurl = "https://c324a5a94838.ngrok.io";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textoPropiedad(titulo: 'Empresa', cuerpo: 'Burger King', id: '0'),
          ...cuponGenerico.map((cupon) => textoPropiedad(
              titulo: 'Fecha de vencimiento del cupón',
              cuerpo: ("${cupon.fechaExpiracion.toString()}"),
              id: ("${cupon.cuponesGenericoId}"))),
          ...cuponGenerico.map((cupon) => textoPropiedad(
              titulo: 'Porcentaje de descuento',
              cuerpo: ("${cupon.porcentajeDescuento}"),
              id: ("${cupon.cuponesGenericoId}"))),
          Center(
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
          )
        ],
      ),
    );
  }

  Widget textoPropiedad(
          {@required String titulo,
          @required String cuerpo,
          @required String id}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 2),
          Text(
            cuerpo,
            style: TextStyle(fontSize: 24),
          ),
          Text(
            id,
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 25)
        ],
      );
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
                    fontSize: 28,
                  ),
                  maxLines: 2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Universidad Tecnologica Metropolitana',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
