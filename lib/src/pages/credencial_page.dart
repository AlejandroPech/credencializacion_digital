
import 'package:credencializacion_digital/src/models/Usuario.dart';
import 'package:credencializacion_digital/src/pages/inicio_sesion_page.dart';
import 'package:credencializacion_digital/src/share_prefs/prefs_user.dart';
import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:credencializacion_digital/src/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_microsoft_authentication/flutter_microsoft_authentication.dart';
import 'package:meta/meta.dart';
import 'package:provider/provider.dart';

class CredencialPage extends StatefulWidget {
  static final String routeName='credencial';
  final String title;

  CredencialPage({Key key,@required this.title}) : super(key: key);

  @override
  _CredencialPageState createState() => _CredencialPageState();
}

class _CredencialPageState extends State<CredencialPage> {
  final prefUser = PrefUser();
  final usuario= new Usuario(
    matricula: 19090529,
    nombre: 'Jesus Alejandro',
    apellidoP: 'Pech',
    apellidoM: 'Paredes',
    correoInstitucional: '19090529@alumno.utmetropolitana.edu.mx',
    grado: 6, 
    grupo: 'A',
    carrera: 'Desarrollo de Software Multiplataforma',
    division: 'TIC',
    status: 'Alumno',
    fotografia: 'https://image.freepik.com/vector-gratis/hombre-muestra-gesto-gran-idea_10045-637.jpg'
  );
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
  Future<void> _signOut() async {
    try {
      await this.fma.signOut;
      prefUser.tokenMicrosoft='';
      prefUser.inicioSesion=false;
      Navigator.pushReplacementNamed(context, InicioSesionPage.routeName);
    } on PlatformException catch(e) {
      print(e.message);
    }
  }
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    final appTheme= Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MenuWidget(),
      body: ListView( 
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: _InfoGeneral(size: size,user: usuario),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _InfoAcademica(user: usuario,),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
            onPressed: _signOut,
             child: Text("Cerrar sesión"),
             style: ElevatedButton.styleFrom(
               primary:appTheme.currentTheme.accentColor
             ),
          ),
          )
          
        ],
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
        Text('Datos Generales',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: CircleAvatar(radius: size.width/5, backgroundImage: NetworkImage(user.fotografia)),
            )
          ],
        ),
        textoDato(titulo: 'Nombre', cuerpo: '${user.nombre} ${user.apellidoP} ${user.apellidoM}')
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
        Text('Datos Academicos',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
        SizedBox(height: 10),
        textoDato(titulo: 'Mátricula', cuerpo: user.matricula.toString()),
        textoDato(titulo: 'Correo Institucional', cuerpo: user.correoInstitucional),
        textoDato(titulo: 'Grado y Grupo', cuerpo: '${user.grado.toString()} ${user.grupo}'),
        textoDato(titulo: 'División', cuerpo: user.division),
        textoDato(titulo: 'Carrera', cuerpo: user.carrera),
        textoDato(titulo: 'status', cuerpo: user.status),
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