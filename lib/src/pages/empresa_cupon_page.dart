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

  final String baseurl = "http://192.168.54.102:9097/api";

  void _dataFromApi() async {
    final Dio dio = new Dio();
    try {
      var response =
          await dio.get("$baseurl/CuponesGenericos/empresa/${widget.idEm}");
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
    final prefUser=new PrefUser();
    List<CuponesGenericos> _listCuponGenerico = _listCuponesGenericos;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _ImagenAndButtonBack(
              size: size,
              urlImage: widget.image,
            ),
            // _Usuario(size: size),
            Expanded(child: _ListaCupones(cuponesGenericos: _listCuponGenerico)),
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
    final baseurl = "http://192.168.54.102:9097/api";
    return Stack(
      children: [
        Container(
          height: size.height / 4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(base64Decode("${this.urlImage}")))),
        ),
        SafeArea(
          child: BackButton(),
        ),
      ],
    );
  }
}

class _ListaCupones extends StatelessWidget {
  final List<CuponesGenericos> cuponesGenericos;
  final PrefUser prefUser;
  const _ListaCupones({@required this.cuponesGenericos,@required this.prefUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: cuponesGenericos.length,
        itemBuilder: (BuildContext context,int index){
          return _Cuerpo(cupon: cuponesGenericos[index]);
        }
      ),
    );
  }
}

class _Cuerpo extends StatelessWidget {
  final String idCupon;
  final CuponesGenericos cupon;
  final PrefUser prefUser;
  final String baseurl = "http://192.168.54.102:9097/api";
  

  const _Cuerpo({this.idCupon,@required this.cupon,@required this.prefUser});

  void _usarCupon() async {
    final Dio dio = new Dio();
    try {
      var respuesta = await dio.get("$baseurl/CuponesGenericos/${this.idCupon}");
      print(respuesta.statusCode);
      print(respuesta.data);

      Map<String, dynamic> listacupon ={
        'cuponImagenId':this.idCupon,
        'matricula':prefUser.identificadorUsuario,
        'cuponGeneridoId':null,
        // 'departamento':usuario.departamento,
      };

      if (respuesta.statusCode == 200) {
        var response = await dio.put(
            "$baseurl/CuponesGenericos/apply?id=${listacupon['cuponGeneridoId']}",
            data: jsonEncode(listacupon),
            // headers: {"Content-Type": "application/json", "Accept" : "application/json"},
        );
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
    final baseurl = "http://192.168.54.102:9097/api";
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textoPropiedad(titulo: 'Empresa', cuerpo: 'Burger King',),
          textoPropiedad(
            titulo: 'Fecha de vencimiento del cupón',
            cuerpo: ("${cupon.fechaExpiracion.toString()}"),
          ),
          textoPropiedad(
            titulo: 'Fecha de vencimiento del cupón',
            cuerpo: ("${cupon.porcentajeDescuento.toString()}"),
          ),
          textoPropiedad(
            titulo: 'Fecha de vencimiento del cupón',
            cuerpo: ("${cupon.descripcion.toString()}"),
          ),
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
          ),
          Divider(height: 10,thickness: 2,),
        ],
      ),
    );
  }

  Widget textoPropiedad(
          {@required String titulo,
          @required String cuerpo,
          }) =>
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
          SizedBox(height: 25)
        ],
      );
}