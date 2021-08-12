import 'package:credencializacion_digital/src/models/UsuarioModel.dart';
import 'package:credencializacion_digital/src/pages/inicio_sesion_page.dart';
import 'package:credencializacion_digital/src/services/microsoft_service.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:credencializacion_digital/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_microsoft_authentication/flutter_microsoft_authentication.dart';
import 'package:meta/meta.dart';

class CredencialPage extends StatefulWidget {
  static final String routeName='credencial';
  final String title;

  CredencialPage({Key key,@required this.title}) : super(key: key);

  @override
  _CredencialPageState createState() => _CredencialPageState();
}

class _CredencialPageState extends State<CredencialPage> {

  MicrosoftService microsoftService= new MicrosoftService();
  FlutterMicrosoftAuthentication fma;

  @override
  void initState() {
    super.initState();
    fma = FlutterMicrosoftAuthentication(
      kClientID: "86614fe5-8390-4852-b473-7aac5bf50548",
      kAuthority: "https://login.microsoftonline.com/organizations",
      kScopes: ["User.Read", "User.ReadBasic.All"],
      androidConfigAssetPath: "assets/auth_config.json"
    );
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    final prefUser = PrefUser();
    return Scaffold(
      drawer: MenuWidget(),
      
      body: Container(
        decoration: BoxDecoration( 
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.01,0.6],
            colors: [appTheme.accentColor,appTheme.scaffoldBackgroundColor]
          )
        ),
        child: FutureBuilder(
          future: microsoftService.fetchMicrosoftProfile(fma),
          builder: (BuildContext context,AsyncSnapshot<Usuario> snapshot){
            if(snapshot.hasData){
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    _AppBar(),
                    _InfoGeneral(size: size,user: snapshot.data),
                    SizedBox(height: 10),
                    _InfoAcademica(user: snapshot.data,),
                    _BotonCerrarSesion(microsoftService: microsoftService, fma: fma, prefUser: prefUser, appTheme: appTheme)
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: (){
                Scaffold.of(context).openDrawer();
              },
              child: Icon(Icons.menu),
            ),
            SizedBox(width: 20,),
            Expanded(child: Text('Credenical Digital',style: TextStyle(fontSize: 24,),maxLines: 1,))
          ],
        ),
      )
    );
  }
}

class _InfoGeneral extends StatelessWidget {
  const _InfoGeneral({
    @required this.size,
    @required this.user,
  });

  final Size size;
  final Usuario user;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(child: Image.asset('assets/img/logo-utm.png',width: size.width/2,height:size.height/5,)),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Container(
                child: CircleAvatar(radius: size.width/5, backgroundImage: MemoryImage(user.foto)),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                    width: 1.0,
                  ),
                ),),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoAcademica extends StatelessWidget {
  const _InfoAcademica({
    @required this.user,
  });
  final Usuario user;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Información',style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
        SizedBox(height: 10),
        textoDato(titulo: 'Nombre', cuerpo: user.nombre),
        textoDato(titulo: (user.titulo.toUpperCase()=='ALUMNO')?'Matricula':'Codigo de empleado', cuerpo: user.identificador),
        textoDato(titulo: 'Correo Institucional', cuerpo: user.correoInstitucional),
        textoDato(titulo: 'Status', cuerpo: user.titulo),
        if(user.departamento!='') textoDato(titulo: 'Departamento', cuerpo: user.departamento),
        textoDato(titulo: 'Dirección de la Universidad', cuerpo: 'Calle 111 número 315, Santa Rosa, 97279 Mérida, Yuc.'),
      ],
    );
  }
  Widget textoDato(
    {
      @required String titulo,
      @required String cuerpo
    }
  )=>Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(titulo,style: TextStyle(fontSize: 16),),
      SizedBox(height: 2),
      Text(cuerpo,style: TextStyle(fontSize: 20),),
      SizedBox(height: 15)
    ] ,
  );
}

class _BotonCerrarSesion extends StatelessWidget {
  const _BotonCerrarSesion({
    Key key,
    @required this.microsoftService,
    @required this.fma,
    @required this.prefUser,
    @required this.appTheme,
  }) : super(key: key);

  final MicrosoftService microsoftService;
  final FlutterMicrosoftAuthentication fma;
  final PrefUser prefUser;
  final ThemeData appTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed:()async{
          await microsoftService.signOut(fma);
          if(prefUser.inicioSesion==false){
            Navigator.pushReplacementNamed(context, InicioSesionPage.routeName);
          }
        },
        child: Text("Cerrar sesión"),
        style: ElevatedButton.styleFrom(
          primary:appTheme.accentColor
        ),
      ),
    );
  }
}