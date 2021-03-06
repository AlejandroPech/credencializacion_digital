import 'dart:convert';

import 'package:credencializacion_digital/src/pages/cupones_page.dart';
import 'package:credencializacion_digital/src/pages/tab_cupones_genericos.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:credencializacion_digital/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:credencializacion_digital/src/models/Empresas.dart';
import 'package:dio/dio.dart';

class EmpresaPage extends StatefulWidget {
  static final String routeName = 'empresa';
  final String title;

  EmpresaPage({Key key, @required this.title}) : super(key: key);

  @override
  _EmpresaPageState createState() => _EmpresaPageState();
}

class _EmpresaPageState extends State<EmpresaPage> {
  List<Empresas> empresas = [];
  String idEmpresa;
  //el localhost en disposividos reales se significa otra cosa.
  //localhost ios 127.0.0.1
  //localhost Android 10.0.2.2

  final String baseurl = "http://192.168.54.102:9097/api";

  void _dataFromApi() async {
    final Dio dio = new Dio();
    try {
      var response = await dio.get("$baseurl/Empresas");
      print(response.statusCode);
      print(response.data);
      List responseData = jsonDecode(response.data);
      if(mounted){
        setState(() {
          empresas = responseData.map((e) => Empresas.fromJson(e)).toList();
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
    bool isLarge;

    if (MediaQuery.of(context).size.width >= 500) {
      isLarge = true;
    } else {
      isLarge = false;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MenuWidget(),
      body: GridView.count(
        crossAxisCount: (isLarge) ? 3 : 2,
        children: [
          ...empresas.map((empresa) => Carditem(
                image: ("${empresa.url}"),
                color: appTheme.accentColor,
                urlNavegar: TabCuponesGenericos.routeName,
                idempresa: ("${empresa.empresaId}"),
                nombreEmpresa: empresa.nombreEmpresa,
              )),
        ],
      ),
    );
  }
}

class Carditem extends StatelessWidget {
  final String image;
  final Color color;
  final String urlNavegar;
  final String idempresa;
  final String nombreEmpresa;
  const Carditem(
      {@required this.image,
      @required this.color,
      @required this.urlNavegar,
      @required this.idempresa, this.nombreEmpresa});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child:(this.image.isNotEmpty)
              ? Image.memory(
                base64Decode("${this.image}"),
                fit: BoxFit.cover,
              )
              :Image.asset('assets/img/no-image.png')
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute<Null>(builder: (BuildContext context) {
                  return new CuponesPage(
                      idEm: idempresa, image: image,nombreImagen: nombreEmpresa,);
                }));
              },
              child: Text(
                'Ver Cupones',
                style: TextStyle(color: this.color, fontSize: 18),
              ),
            )
          ],
        ),
      ),
    );
  }
}
