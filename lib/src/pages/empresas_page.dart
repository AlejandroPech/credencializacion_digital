import 'package:credencializacion_digital/src/pages/empresa_cupon_page.dart';
import 'package:credencializacion_digital/src/pages/empresa_cupones_page.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:credencializacion_digital/src/widgets/menu_widget.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meta/meta.dart';

class EmpresaPage extends StatefulWidget {
  static final String routeName='empresa';
  final String title;

  EmpresaPage({Key key,@required this.title}) : super(key: key);

  @override
  _EmpresaPageState createState() => _EmpresaPageState();
}

class _EmpresaPageState extends State<EmpresaPage> {
  @override
  Widget build(BuildContext context) {
    bool isLarge;

    if(MediaQuery.of(context).size.width>=500){
      isLarge=true;
    }else{
      isLarge=false;
    }

    final appTheme= Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MenuWidget(),
      body: GridView.count(
        crossAxisCount: (isLarge)?3:2,
        children: [
          Carditem(
              image: "https://media-cdn.tripadvisor.com/media/photo-s/08/af/e2/d3/distrito-capital-federal.jpg",
              color: appTheme.currentTheme.accentColor,
              urlNavegar: EmpresaCuponPage.routeName,
          ),
          Carditem(
            image: "https://www.america-retail.com/static//2020/08/Noticia-5-1-de-3-339.png",
            color: appTheme.currentTheme.accentColor,
            urlNavegar: EmpresaCuponesPage.routeName,
          ),
          Carditem(
              image: "https://media-cdn.tripadvisor.com/media/photo-s/08/af/e2/d3/distrito-capital-federal.jpg",
              color: appTheme.currentTheme.accentColor,
              urlNavegar: EmpresaCuponPage.routeName,
          ),
          Carditem(
            image: "https://www.peru-retail.com/wp-content/uploads/Little-Caesars-1.jpg",
            color: appTheme.currentTheme.accentColor,
            urlNavegar: EmpresaCuponPage.routeName,
          ),
          Carditem(
              image: "https://media-cdn.tripadvisor.com/media/photo-s/08/af/e2/d3/distrito-capital-federal.jpg",
              color: appTheme.currentTheme.accentColor,
              urlNavegar: EmpresaCuponPage.routeName,
          ),
          Carditem(
            image: "https://www.america-retail.com/static//2020/08/Noticia-5-1-de-3-339.png",
            color: appTheme.currentTheme.accentColor,
            urlNavegar: EmpresaCuponesPage.routeName,
          ),
          Carditem(
              image: "https://media-cdn.tripadvisor.com/media/photo-s/08/af/e2/d3/distrito-capital-federal.jpg",
              color: appTheme.currentTheme.accentColor,
              urlNavegar: EmpresaCuponPage.routeName,
          ),
          Carditem(
            image: "https://www.peru-retail.com/wp-content/uploads/Little-Caesars-1.jpg",
            color: appTheme.currentTheme.accentColor,
            urlNavegar: EmpresaCuponPage.routeName,
          ),
          Carditem(
              image: "https://media-cdn.tripadvisor.com/media/photo-s/08/af/e2/d3/distrito-capital-federal.jpg",
              color: appTheme.currentTheme.accentColor,
              urlNavegar: EmpresaCuponesPage.routeName,
          ),
          Carditem(
            image: "https://www.america-retail.com/static//2020/08/Noticia-5-1-de-3-339.png",
            color: appTheme.currentTheme.accentColor,
            urlNavegar: EmpresaCuponPage.routeName,
          ),
          Carditem(
              image: "https://media-cdn.tripadvisor.com/media/photo-s/08/af/e2/d3/distrito-capital-federal.jpg",
              color: appTheme.currentTheme.accentColor,
              urlNavegar: EmpresaCuponPage.routeName,
          ),
          Carditem(
            image: "https://www.peru-retail.com/wp-content/uploads/Little-Caesars-1.jpg",
            color: appTheme.currentTheme.accentColor,
            urlNavegar: EmpresaCuponPage.routeName,
          ),
        ],
      ),
    );
  }
}

class Carditem extends StatelessWidget {
  final String image;
  final Color color;
  final String urlNavegar;
  const Carditem({@required this.image, @required this.color,@required this.urlNavegar});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Image.network(this.image,fit: BoxFit.cover,),
              ),
              
              TextButton(
                onPressed:()=>Navigator.pushNamed(context, urlNavegar),
                child: Text('Ver Cupones',style: TextStyle(color: this.color,fontSize: 18),),
              )
            ],
          ),
      ),
    );
  }
}