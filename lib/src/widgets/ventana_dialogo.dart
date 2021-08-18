import 'package:credencializacion_digital/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class VentanaDialogo extends StatelessWidget {
  final Image imagen;
  final String titulo;
  final String cuerpo;
  const VentanaDialogo({this.imagen,@required this.titulo,@required this.cuerpo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      content: Text(cuerpo),
      actions: [
        if(imagen!=null)
          imagen,
        TextButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          child: Text('Cerrar',style: TextStyle(color: appTheme.accentColor),),
        ),
      ],
    );
  }
}