import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../screens/home_navigator/home_navigator.dart';
import '../screens/login/login_view.dart';




class AuthService extends ChangeNotifier {
  //AuthService();
  handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context,spanshot){
        if(spanshot.hasData){
          print("=============has Data=========");
          return HomeNavigator();
        } else {
          print("=============has No Data=========");
          return LoginView();
        }

      }
      );
  }

  signOut() {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }





}