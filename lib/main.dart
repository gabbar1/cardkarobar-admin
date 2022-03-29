import 'dart:convert';

import 'package:cardkarobar/screens/login/login_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'helper/constant.dart';
import 'screens/home_navigator/home_navigator.dart';
import 'services/authservice.dart';
import 'services/firebase_config.dart';


 Future<void>  main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(options: DefaultFirebaseConfig.webPlatFormConfig);

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(

      primaryColor: mainColor,
      appBarTheme: AppBarTheme(backgroundColor: mainColor),
      textTheme: GoogleFonts.latoTextTheme(),
    ),
   // home: HomeNavigator(),
    home: MyHomePage(),
  ));
}


class MyHomePage extends StatefulWidget {


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var version ="4";
   @override
  void initState() {
     FirebaseFirestore.instance
         .collection("version")
         .get()
         .then((QuerySnapshot querySnapshot) {
       querySnapshot.docs.forEach((element) {
         if (version != element["version"].toString()) {
           print("--------latestVersion----------");
           Get.offAll(AuthService().handleAuth());
           /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AuthService().handleAuth()));*/
           // return AuthService().handleAuth();
         }
       });
     });
    super.initState();

         }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: appBackGroundColor,
        child: Image.asset("assets/icon.png"),
      ),
    );
  }
}
