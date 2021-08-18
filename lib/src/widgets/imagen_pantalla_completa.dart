import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:meta/meta.dart';
class ImagenPantallaCompleta extends StatelessWidget {
  final Image child;
  final bool dark;

  ImagenPantallaCompleta({@required this.child,this.dark = true,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            opaque: true,
            barrierColor: dark ? Colors.black : Colors.white,
            pageBuilder: (BuildContext context, _, __) {
              return PantallaCompleta(
                child: child,
                dark: dark,
              );
            },
          ),
        );
      },
      child: child,
    );
  }
}
class PantallaCompleta extends StatelessWidget {
  PantallaCompleta({@required this.child,@required this.dark,});
  final Image child;
  final bool dark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Center(
            child: Stack(
              children: [
                PhotoView(imageProvider: child.image,minScale:0.25,maxScale: 1.5,)
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: MaterialButton(
                padding: const EdgeInsets.all(15),
                elevation: 0,
                child: Icon(
                  Icons.arrow_back,
                  color: dark ? Colors.white : Colors.black,
                  size: 25,
                ),
                color: dark ? Colors.black12 : Colors.white70,
                highlightElevation: 0,
                minWidth: double.minPositive,
                height: double.minPositive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}