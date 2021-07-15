import 'package:credencializacion_digital/src/pages/empresas_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_microsoft_authentication/flutter_microsoft_authentication.dart';

class MicrosoftService with ChangeNotifier{
  FlutterMicrosoftAuthentication fma;
  MicrosoftService(){
    fma = FlutterMicrosoftAuthentication(
      kClientID: "86614fe5-8390-4852-b473-7aac5bf50548",
      kAuthority: "https://login.microsoftonline.com/organizations",
      kScopes: ["User.Read", "User.ReadBasic.All"],
      androidConfigAssetPath: "assets/auth_config.json"
    );
  }
  Future<void> acquireTokenInteractively() async {
    String authToken;
    try {
      authToken = await this.fma.acquireTokenInteractively;
    } on PlatformException catch(e) {
      authToken = 'Failed to get token.';
      print(e.message);
    }
  }

  Future<void> signOut() async {
    String authToken;
    try {
      authToken = await this.fma.signOut;
    } on PlatformException catch(e) {
      authToken = 'Failed to sign out.';
      print(e.message);
    }
  }

  Future<String> loadAccount(BuildContext context) async {
    String username = await this.fma.loadAccount;
    if(username.isNotEmpty){
      Navigator.pushReplacementNamed(context, EmpresaPage.routeName);
    }
    notifyListeners();
  }
}