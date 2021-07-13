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
            Container(
              height: size.height / 4,
              decoration: BoxDecoration( 
                image:DecorationImage( 
                  fit: BoxFit.cover,
                  image: NetworkImage('https://media-cdn.tripadvisor.com/media/photo-s/08/af/e2/d3/distrito-capital-federal.jpg')
                )
              ),
            ),
            _Usuario(size: size),
            Container(
              padding: EdgeInsets.symmetric(horizontal:10 ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                ],
              ),
            ),
          ],
        ),
      ),
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

class _Cupones extends StatelessWidget {
  final Size size;
  final String urlImage;
  const _Cupones({@required this.urlImage,@required this.size});


  @override
  Widget build(BuildContext context) {
    final appTheme= Provider.of<ThemeChanger>(context);
    return Container(
      child: Row(  
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: size.height / 4,
            width: size.height / 4,
            decoration: BoxDecoration( 
              image:DecorationImage( 
                fit: BoxFit.cover,
                image: NetworkImage('https://latam.kaspersky.com/content/es-mx/images/repository/isc/2020/9910/a-guide-to-qr-codes-and-how-to-scan-qr-codes-2.png')
              )
            ),
          ),
          Container(
            child:ElevatedButton(
              onPressed: (){},
              child: Text('Aplicar Cupón'),
              style: ElevatedButton.styleFrom(
                  primary: appTheme.currentTheme.accentColor
              ),
            ),
          )
        ],
      ),
    );
  }
}