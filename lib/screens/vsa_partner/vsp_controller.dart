import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../helper/constant.dart';
import '../user_details/personalDetailModel.dart';

class VSPController extends GetxController{

  var userList = <UserDetailModel>[].obs;
  List<UserDetailModel> get getUsersList => userList.value;
  setUser(UserDetailModel userDetailModel){
    userList.value.add(userDetailModel);
    userList.refresh();
  }

  DocumentSnapshot categoryLastDocument;
  Future<void> myNewUserRefreshList() async{
    print(Timestamp.fromDate(DateTime.now().subtract(Duration(days: 2))));
    FirebaseFirestore.instance.collection("user_details").where("isOwner",isEqualTo: true).startAfterDocument(categoryLastDocument).limit(10).get().then((value) {
      if(!value.docs.isEmpty){
        categoryLastDocument = value.docs[value.docs.length -1];
        value.docs.forEach((element) {
          UserDetailModel _user = UserDetailModel.fromJson(element.data());
          _user.key = element.id;
          setUser(_user);
        });
      }else{
        commonSnackBar("Result", "No Lead found");
      }
    });

  }

  Future<void> myNewUsers() async{
    userList.value.clear();
    userList.refresh();
    //172800

    print(Timestamp.fromDate(DateTime.now().subtract(Duration(days: 2))));
    var currentDate = DateTime.now();
    var beforeDate = DateTime(currentDate.year,currentDate.month,currentDate.day-2);
    print(currentDate);
    print(beforeDate);
    print(Timestamp.fromDate(beforeDate));
    FirebaseFirestore.instance.collection("user_details").where("isOwner",isEqualTo: true).limit(10).get().then((value) {
      if(!value.docs.isEmpty){
        categoryLastDocument = value.docs[value.docs.length -1];
        value.docs.forEach((element) {
          UserDetailModel _user = UserDetailModel.fromJson(element.data());
          _user.key = element.id;
          setUser(_user);
        });
      }else{
        commonSnackBar("Result", "No Lead found");
      }
    });

  }
  Future<void> getSearchByUserPhone(String phone)async{
    userList.value.clear();
    userList.refresh();
    print("========fffffffffffff==========");
    try {
      FirebaseFirestore.instance
          .collection("user_details").doc(phone).get().then((value) {
        print("========phone==============");
        print(value.data());
        UserDetailModel _user = UserDetailModel.fromJson(value.data());
        _user.key = value.id;
        setUser(_user);
      });
    } catch (exception) {
      Get.snackbar("Error", exception.toString());
      throw exception;
    }
  }
  Future<void> getSearchByUserName(String name)async{
    userList.value.clear();
    userList.refresh();
    try {

      print("==============checking String==================");
      FirebaseFirestore.instance
          .collection("user_details").orderBy("advisor_name").where("advisor_name",isGreaterThanOrEqualTo: name).where("advisor_name",isLessThanOrEqualTo: name + '\uf8ff').get().then((value){
        value.docs.forEach((element) {
          print(value.docs.length);
          print(element.data());
          UserDetailModel _user = UserDetailModel.fromJson(element.data());
          _user.key = element.id;
          setUser(_user);
        });

      });

    } catch (exception) {
      Get.snackbar("Error", exception.toString());
      throw exception;
    }
  }
}