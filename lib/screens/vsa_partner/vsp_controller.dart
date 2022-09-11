import 'package:cardkarobar/screens/dashboard/my_work_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../helper/constant.dart';
import '../user_details/personalDetailModel.dart';
import 'vsp_price_model.dart';

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

  var newPartner = UserDetailModel().obs;
  UserDetailModel get getNewPartner => newPartner.value;
  setNewPartner(UserDetailModel val){
    newPartner.value =val;
    newPartner.refresh();
  }
  var isClicked = false.obs;
  bool get getIsClicked => isClicked.value;
  setIsClicked(bool val){
    isClicked.value =val;
    isClicked.refresh();
  }

  Future<void> getSearchByNewUserPhone(String phone)async{

    try {
      FirebaseFirestore.instance.collection("user_details").doc(phone).get().then((value) {
        UserDetailModel _user = UserDetailModel.fromJson(value.data());
        _user.key = value.id;
        setNewPartner(_user);
      });
    } catch (exception) {
      Get.snackbar("Error", exception.toString());
      throw exception;
    }
  }
  Future<void> addPartnerProductPrice(VSPPriceModel vSPPriceModel) async{
    showLoader();
    FirebaseFirestore.instance.collection("partner").doc(vSPPriceModel.partnerPhone).collection("products").add({
      "type":vSPPriceModel.type,
      "isEnabled":vSPPriceModel.isEnabled,
      "price":vSPPriceModel.price,
      "name":vSPPriceModel.name,
    }).then((value) {
      closeLoader();
      partnerProductPriceList();
    }).onError((error, stackTrace) {
      closeLoader();
      print(error.toString());
    });

  }

  var partnerPriceList = <VSPPriceModel>[].obs;
  List<VSPPriceModel> get getPartnerPriceList => partnerPriceList.value;
  set setPartnerPriceList(VSPPriceModel val){
    partnerPriceList.add(val);
    partnerPriceList.refresh();
  }
  Future<void> partnerProductPriceList() async{
    partnerPriceList.value.clear();
    print("===================result======================");
    FirebaseFirestore.instance.collection("partner").doc(getNewPartner.advisorPhoneNumber).collection("products").get().then((value) {
      if(!value.isBlank){
        value.docs.forEach((element) {
          print(element.data());
          setPartnerPriceList = VSPPriceModel.fromJson(element.data());
        });

      }
    });

  }
  Future<void> markAsPartner() async{
    print("===================onRefresh======================");
    FirebaseFirestore.instance.collection("user_details").doc(getNewPartner.advisorPhoneNumber).update({
      "isOwner":true,
      "isEnabled":true,
      "isAdmin":true,
      "compnayId":getNewPartner.advisorPhoneNumber
    }).then((value) {
      newPartner.value.isOwner =true;
      newPartner.value.isAdmin =true;
      newPartner.value.isEnabled =true;
      newPartner.refresh();
      isClicked.value = false;
      isClicked.refresh();
    });

  }

}