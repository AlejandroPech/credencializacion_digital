import 'dart:convert';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:credencializacion_digital/src/widgets/ventana_dialogo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:credencializacion_digital/src/models/CuponesGenericos.dart';
import 'package:dio/dio.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';

class TabCuponesGenericos extends StatefulWidget {
  static final String routeName = 'empresaCupon';
  final String nombreEmpresa;
  final String idEm;
  final String image;
  TabCuponesGenericos({Key key,@required this.idEm,@required this.image, this.nombreEmpresa})
      : super(key: key);

  @override
  _TabCuponesGenericosState createState() => _TabCuponesGenericosState();
}

class _TabCuponesGenericosState extends State<TabCuponesGenericos> {
  List<CuponesGenericos> _listCuponesGenericos = [];

  final String baseurl = "http://192.168.54.102:9097/api";

  void _dataFromApi() async {
    final Dio dio = new Dio();
    try {
      var response = await dio.get("$baseurl/CuponesGenericos/empresa/${widget.idEm}");
      var responseData = response.data as List;
      if(mounted){
        setState(() {
        _listCuponesGenericos =
            responseData.map((e) => CuponesGenericos.fromJson(e)).toList();
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
    final prefUser=new PrefUser();
    List<CuponesGenericos> _listCuponGenerico = _listCuponesGenericos;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _ListaCupones(cuponesGenericos: _listCuponGenerico, prefUser: prefUser,nombreEmpresa: widget.nombreEmpresa,)),
          ],
        ),
      ),
    );
  }
}

class _ListaCupones extends StatelessWidget {
  final List<CuponesGenericos> cuponesGenericos;
  final PrefUser prefUser;
  final String nombreEmpresa;
  const _ListaCupones({@required this.cuponesGenericos,@required this.prefUser,@required this.nombreEmpresa});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: cuponesGenericos.length,
        itemBuilder: (BuildContext context,int index){
          return _Cuerpo(cupon: cuponesGenericos[index],prefUser: prefUser,nombreEmpresa: nombreEmpresa,);
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
  final String nombreEmpresa;  

  const _Cuerpo({this.idCupon,@required this.cupon,@required this.prefUser, this.nombreEmpresa});

  

  @override
  Widget build(BuildContext context) {
    void _usarCupon() async {
    final Dio dio = new Dio();
    try {
      var respuesta = await dio.get("$baseurl/CuponesGenericos/${this.cupon.cuponesGenericoId}");
      print(respuesta.statusCode);
      print(respuesta.data);

      Map<String, dynamic> listacupon ={
        'cuponImagenId':null,
        'matricula':prefUser.identificadorUsuario,
        'cuponGeneridoId':this.cupon.cuponesGenericoId,
        'departamento':prefUser.departamento,
      };

      if (respuesta.statusCode == 200) {
        var response = await dio.put(
            "$baseurl/CuponesGenericos/apply?id=${this.cupon.cuponesGenericoId}",
            data: jsonEncode(listacupon),
            // headers: {"Content-Type": "application/json", "Accept" : "application/json"},
        );
        if (response.statusCode == 200) {
          showDialog(context: context, builder: (context){
            return VentanaDialogo(
              titulo: "Cupon Utilizado", 
              cuerpo: "El cupon se ha utilizado correctamente",
            );
          });
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
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textoPropiedad(titulo: 'Empresa', cuerpo: nombreEmpresa,),
          textoPropiedad(
            titulo: 'Fecha de vencimiento del cupón',
            cuerpo: ("${cupon.fechaExpiracion.toString()}"),
          ),
          textoPropiedad(
            titulo: 'Porcentaje de descuento',
            cuerpo: ("${cupon.porcentajeDescuento.toString()}"),
          ),
          textoPropiedad(
            titulo: 'Descripción',
            cuerpo: ("${cupon.descripcion.toString()}"),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _usarCupon();
              },
              child: Text('Aplicar Cupón'),
              style: ElevatedButton.styleFrom(
                  primary: appTheme.accentColor),
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