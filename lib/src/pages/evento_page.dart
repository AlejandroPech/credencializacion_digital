import 'package:credencializacion_digital/src/pages/tab_eventos_page.dart';
import 'package:credencializacion_digital/src/pages/tab_favoritos_page.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:credencializacion_digital/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class EventosPage extends StatelessWidget{
  static final routeName='eventos';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>new _NavegacionModel(),
      child: Scaffold(
        drawer: MenuWidget(),
        appBar: AppBar(
          title:Text('Eventos y Favoritos',),
          // backgroundColor: appTheme.scaffoldBackgroundColor,
        ),
        body: _Paginas(),
        bottomNavigationBar: _Navegacion(),
      ),
    );
  }
}

class _Paginas extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    final navegacionModel=Provider.of<_NavegacionModel>(context);
    
    return PageView(
      controller:navegacionModel.pageController,
      // physics: BouncingScrollPhysics(),
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        TabPaginaEventos(),
        TabPaginaFavoritos(),
      ],
    );
  }
}

class _Navegacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navegacionModel=Provider.of<_NavegacionModel>(context);
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
    if(this._paginaActual!=value){
      this._paginaActual=value;
      _pageController.animateToPage(value, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
      notifyListeners();
    }
  }

  PageController get pageController=>this._pageController;
}

