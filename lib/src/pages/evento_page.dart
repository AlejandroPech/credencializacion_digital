import 'package:credencializacion_digital/src/models/Eventos.dart';
import 'package:credencializacion_digital/src/pages/tab_evento_page.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:credencializacion_digital/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventosPage extends StatefulWidget {
  static final routeName='eventos';
  EventosPage({Key key}) : super(key: key);

  @override
  _EventosPageState createState() => _EventosPageState();
}

class _EventosPageState extends State<EventosPage> {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>new _NavegacionModel(),
      child: Scaffold(
        appBar: AppBar(  
          title: Text('Eventos'),
          actions: [
            _PopupMenu()
          ],
        ),
        drawer: MenuWidget(),
        body: _Paginas(),
        bottomNavigationBar: _Navegacion(),
      ),
    );
  }
}

class _PopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        itemBuilder: (context) => [
          PopupMenuItem(
            child: Text("Hoy"),
            value: 1,
          ),
          PopupMenuItem(
            child: Text("Esta semanda"),
            value: 2,
          ),
          PopupMenuItem(
            child: Text("Esta mes"),
            value: 2,
          ),
          PopupMenuItem(
            child: Text("Esta año"),
            value: 2,
          ),
        ]
    );
  }
}

class _Paginas extends StatelessWidget {
  
  final eventos=[
    Eventos(eventoId: 1, urlImage: 'https://www.yucatanencorto.com/noticias/wp-content/uploads/2019/11/IMG_20191108_105257.jpg', titulo: 'Titulo Ejemplo 1', cuerpo: 'Este es un ejemplo para observar las interfaces', fechaEvento: DateTime(2021), meGusta: true, departamento: 'TIC', recomendado:true),
    Eventos(eventoId: 2, urlImage: 'https://www.yucatanencorto.com/noticias/wp-content/uploads/2019/11/IMG_20191108_105257.jpg', titulo: 'Titulo Ejemplo 2', cuerpo: 'Este es un ejemplo para observar las interfaces', fechaEvento: DateTime(2021), meGusta: false, departamento: 'TIC', recomendado:true),
    Eventos(eventoId: 3, urlImage: 'https://www.yucatanencorto.com/noticias/wp-content/uploads/2019/11/IMG_20191108_105257.jpg', titulo: 'Titulo Ejemplo 3', cuerpo: 'Este es un ejemplo para observar las interfaces', fechaEvento: DateTime(2021), meGusta: false, departamento: 'TIC', recomendado:true),
    Eventos(eventoId: 4, urlImage: '', titulo: 'Titulo Ejemplo 4', cuerpo: 'Este es un ejemplo para observar las interfaces', fechaEvento: DateTime(2021), meGusta: false, departamento: 'TIC', recomendado:true),
    Eventos(eventoId: 5, urlImage: 'https://www.yucatanencorto.com/noticias/wp-content/uploads/2019/11/IMG_20191108_105257.jpg', titulo: 'Titulo Ejemplo 5', cuerpo: 'Este es un ejemplo para observar las interfaces', fechaEvento: DateTime(2021), meGusta: true, departamento: 'TIC', recomendado:true),
  ];
  final favoritos=[
    Eventos(eventoId: 1, urlImage: 'https://www.yucatanencorto.com/noticias/wp-content/uploads/2019/11/IMG_20191108_105257.jpg', titulo: 'Titulo Ejemplo 1', cuerpo: 'Este es un ejemplo para observar las interfaces', fechaEvento: DateTime(2021), meGusta: true, departamento: 'TIC', recomendado:true),
    Eventos(eventoId: 5, urlImage: 'https://www.yucatanencorto.com/noticias/wp-content/uploads/2019/11/IMG_20191108_105257.jpg', titulo: 'Titulo Ejemplo 5', cuerpo: 'Este es un ejemplo para observar las interfaces', fechaEvento: DateTime(2021), meGusta: true, departamento: 'TIC', recomendado:true),
  ];
  @override
  Widget build(BuildContext context) {
    final navegacionModel=Provider.of<_NavegacionModel>(context);
    return PageView(
      controller:navegacionModel.pageController,
      // physics: BouncingScrollPhysics(),
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        TabPaginaEventos(eventos: eventos),
        TabPaginaEventos(eventos: favoritos),
      ],
    );
  }
}

class _Navegacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navegacionModel=Provider.of<_NavegacionModel>(context);
    final appTheme= Provider.of<ThemeChanger>(context).currentTheme;

    return BottomNavigationBar(
      currentIndex: navegacionModel.paginaActual,
      fixedColor: appTheme.accentColor,
      onTap: (index)=>navegacionModel.paginaActual=index,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.event,),label: 'Eventos',),
        BottomNavigationBarItem(icon: Icon(Icons.favorite,),label: 'Favoritos',),
      ],
    );
  }
}

class _NavegacionModel with ChangeNotifier{
  int _paginaActual=0;
  PageController _pageController = new PageController();

  int get paginaActual=>this._paginaActual;
  set paginaActual(int value){
    this._paginaActual=value;
    _pageController.animateToPage(value, duration: Duration(milliseconds: 250), curve: Curves.easeOut);
    notifyListeners();
  }

  PageController get pageController=>this._pageController;
}

