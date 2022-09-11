import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../dashboard/model/contact_model.dart';

class VSPController extends GetxController{


  var userList = <UserContactModel>[].obs;
  List<UserContactModel> get getUsersList => userList.value;
  setUser(UserContactModel userContactModel){
    userList.value.add(userContactModel);
    userList.refresh();
  }

  Future<void> getUserList()async{
    userList.value.clear();
    try {


      FirebaseFirestore.instance
          .collection("user_details").get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((element) {
          UserContactModel _user = UserContactModel(name:element["advisor_name"] ,mobile: element["advisor_phone_number"],isEnabled: element["isEnabled"]);
          if(_user.isEnabled){
            setUser(_user);
          }
        });
      });
    } catch (exception) {
      throw exception;
    }
  }
}