import 'package:cardkarobar/helper/constant.dart';
import 'package:cardkarobar/screens/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class LoginView extends StatefulWidget {

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  LoginController _loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text("Email"),
            const SizedBox(height: 10),
            Container(
              width: 400,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextFormField(
                controller:_loginController.emailController ,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.mail,
                    color: inactiveColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                        width: 1, color: Colors.black),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Text("Password"),
            const SizedBox(height: 10),
            Container(
              width: 400,
              decoration: const BoxDecoration(

                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextFormField(
                controller:_loginController.passwordController ,
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock,
                    color: inactiveColor,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(
                        width: 1, color: Colors.black),
                  ),
                  border: OutlineInputBorder(),
                ),

              ),
            ),
            const SizedBox(height: 20,),
            InkWell(
              onTap: (){
                _loginController.loginUser();
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(left: 30,right: 30,top: 10,bottom: 10),
                    decoration: const BoxDecoration(
                      color: inactiveColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: const Text("Login",style: TextStyle(color: Colors.white),)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
