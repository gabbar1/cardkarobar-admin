
import 'package:cardkarobar/screens/dashboard/dasboard_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  loginUser() async{

    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text).then((value) {
        if(!value.user.uid.isEmpty){
         // Get.offAll(DashBoardView());
        }else{
          Get.snackbar("Error", "Someting went wrong");
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }
}