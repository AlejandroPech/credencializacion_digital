import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';
class EmpresaCuponesPage extends StatefulWidget {
  static final String routeName='empresaCupones';
  final String title;
  EmpresaCuponesPage({Key key,@required this.title}) : super(key: key);

  @override
  _EmpresaCuponesPageState createState() => _EmpresaCuponesPageState();
}

class _EmpresaCuponesPageState extends State<EmpresaCuponesPage> {
  @override
  Widget build(BuildContext context) {
    final size= MediaQuery.of(context).size;
    return Scaffold(
      
      body: SafeArea(
        child: ListView(
          children: [
            _ImagenAndButtonBack(size: size),
            _Usuario(size: size),
            _Cupnoes(size: size),
          ],
        ),
      ),
    );
  }
}

class _ImagenAndButtonBack extends StatelessWidget {
  final Size size;
  const _ImagenAndButtonBack({
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children:[
        Container(
          height: size.height / 4,
          decoration: BoxDecoration( 
            image:DecorationImage( 
              fit: BoxFit.cover,
              image: NetworkImage('https://media-cdn.tripadvisor.com/media/photo-s/08/af/e2/d3/distrito-capital-federal.jpg')
            )
          ),
        ),
        SafeArea(
          child: BackButton(),
        ),
      ],
    );
  }
}

class _Usuario extends StatelessWidget {
  const _Usuario({@required this.size,});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height/6,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          CircleAvatar(radius: size.height/20, backgroundImage: NetworkImage('https://image.freepik.com/vector-gratis/hombre-muestra-gesto-gran-idea_10045-637.jpg')),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width*0.7,
                child: Text(
                  'Jesus Alejandro Pech paredes',
                  style: TextStyle(fontSize: 28,),maxLines: 2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '19090529',
                style: TextStyle(fontSize: 18),
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
  const _Cupnoes({this.size});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children:[
        _Cupon(
          urlImage: "https://www.mistercomparador.com/noticias/wp-content/uploads/2014/11/qr.png", 
          size: size,
          descripcion: 'Este cupon tiene un 20% de descuento',
        ),  
        _Cupon(
          urlImage: "https://www.mistercomparador.com/noticias/wp-content/uploads/2014/11/qr.png", 
          size: size,
          descripcion: 'Este cupon tiene un 20% de descuento',
        ),  
        _Cupon(
          urlImage: "https://www.mistercomparador.com/noticias/wp-content/uploads/2014/11/qr.png", 
          size: size,
          descripcion:'Este cupon tiene un 20% de descuento',
        ),
      ]
    );
  }
}

class _Cupon extends StatelessWidget {
  final Size size;
  final String urlImage;
  final String descripcion;
  const _Cupon({@required this.urlImage,@required this.size,@required this.descripcion});

  @override
  Widget build(BuildContext context) {
    final appTheme= Provider.of<ThemeChanger>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5,vertical:15),
      height: size.height / 4,
      child: Card(
        child: Row(
          children: [
            Container(
              width: size.height / 4,
              decoration: BoxDecoration( 
                image:DecorationImage( 
                  fit: BoxFit.cover,
                  image: NetworkImage('https://latam.kaspersky.com/content/es-mx/images/repository/isc/2020/9910/a-guide-to-qr-codes-and-how-to-scan-qr-codes-2.png')
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
                              child: Text('Descripción:  $descripcion',style: TextStyle(fontSize: 20),)
                            )
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: ElevatedButton(
                        onPressed: (){},
                        child: Text('Aplicar Cupón'),
                        style: ElevatedButton.styleFrom(
                            primary: appTheme.currentTheme.accentColor
                        ),
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