import 'package:cardkarobar/screens/user_details/personalDetailModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../helper/constant.dart';
import '../dashboard/model/contact_model.dart';
import '../dashboard/model/lead_model.dart';


class UserController extends GetxController{

  var historyLeadList = <LeadModel>[].obs;
  List<LeadModel> get getHistoryLeadList => historyLeadList.value;


  setHistoryLeadList(LeadModel leadModel){
    historyLeadList.value.add(leadModel);
    historyLeadList.value.sort((a,b)=> b.time.compareTo(a.time));
    historyLeadList.refresh();
  }

  var leadDetail = LeadModel().obs;
  LeadModel get getLeadDetail => leadDetail.value;
  set setLeadDetail(LeadModel val){
    leadDetail.value =val;
    leadDetail.refresh();
  }
  DocumentSnapshot lastHistoryDocument;
  Future<void> myhistory() async{
    historyLeadList.value.clear();
    print("===================New Load======================");
    FirebaseFirestore.instance.collection("leads").where("status",isNotEqualTo: "submitted").limit(5).get().then((value) {
      lastHistoryDocument = value.docs[value.docs.length -1];
      value.docs.forEach((element) {
        LeadModel leadModel = LeadModel.fromJson(element.data());
        leadModel.key = element.id;
        setHistoryLeadList(leadModel);
      });
    });

  }

  Future<void> myRefreshHistoryLeads() async{
    historyLeadList.value.clear();
    print("===================onRefresh======================");
    FirebaseFirestore.instance.collection("leads").where("status",isNotEqualTo: "submitted").orderBy("status").limit(5).startAfterDocument(lastHistoryDocument).get().then((value) {
      print(value.docs.length);
      lastHistoryDocument = value.docs[value.docs.length -1];
      value.docs.forEach((element) {
        LeadModel leadModel = LeadModel.fromJson(element.data());
        leadModel.key = element.id;
        setHistoryLeadList(leadModel);
      });
    });

  }
  DocumentSnapshot categoryLastDocument;
  Future<void> myNewUserRefreshList() async{
    print(Timestamp.fromDate(DateTime.now().subtract(Duration(days: 2))));
    FirebaseFirestore.instance.collection("user_details").where("registerDate",isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 2))) ).orderBy("registerDate").startAfterDocument(categoryLastDocument).limit(10).get().then((value) {
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
    FirebaseFirestore.instance.collection("user_details").where("registerDate",isGreaterThan: Timestamp.fromDate(beforeDate) ).orderBy("registerDate").limit(10).get().then((value) {
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

  var userList = <UserDetailModel>[].obs;
  List<UserDetailModel> get getUsersList => userList.value;
  setUser(UserDetailModel userDetailModel){
    userList.value.add(userDetailModel);
    userList.refresh();
  }
  DocumentSnapshot userLastDocument;

  Future<void> getUserList()async{
    userList.value.clear();
    userList.refresh();
    try {

      FirebaseFirestore.instance
          .collection("user_details").limit(10).orderBy("registerDate",descending: true).get()
          .then((QuerySnapshot querySnapshot) {
        userLastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        querySnapshot.docs.forEach((element) {
          UserDetailModel _user = UserDetailModel.fromJson(element.data());
          _user.key = element.id;
          setUser(_user);
          print(_user);
        });
      });
    } catch (exception) {
      throw exception;
    }
  }
  Future<void> getRefreshUserList()async{

    try {

      FirebaseFirestore.instance
          .collection("user_details").limit(10).orderBy("registerDate",descending: true).startAfterDocument(userLastDocument).get()
          .then((QuerySnapshot querySnapshot) {
        if(querySnapshot.docs.isNotEmpty){
          userLastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
        }

        querySnapshot.docs.forEach((element) {
          UserDetailModel _user = UserDetailModel.fromJson(element.data());
          _user.key = element.id;
          setUser(_user);

        });
      });
    } catch (exception) {
      throw exception;
    }
  }


  Future<void> updateUserList()async{
    userList.value.clear();
    try {

      FirebaseFirestore.instance
          .collection("user_details").get()
          .then((QuerySnapshot querySnapshot) {

        querySnapshot.docs.forEach((element) {
          UserDetailModel _user = UserDetailModel.fromJson(element.data());
          _user.key = element.id;
          _user.isEnabled = _user.isEnabled==null ? false: _user.isEnabled;
          _user.registerDate = Timestamp.now();

          FirebaseFirestore.instance
              .collection("user_details").doc(_user.key).update(_user.toJson());

        });
      });
    } catch (exception) {
      throw exception;
    }
  }

  var userDetails= UserDetailModel().obs;
  UserDetailModel get getUserDetails =>userDetails.value;
  set setUserDetails(UserDetailModel val){
    userDetails.value =val;
    userDetails.refresh();
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

  bankDetails(String key,int index){
    FirebaseFirestore.instance
        .collection("user_details").doc(key).collection("bank_details").doc("bank_details").get().then((value){
          print("==============userList[index]====================");
          print(value.data());
          if(value.exists){
            BankDetailModel bankDetailModel = BankDetailModel.fromJson(value.data());
            userList.value[index].bankDetails = bankDetailModel;
            userList.refresh();
          }else{
            BankDetailModel bankDetailModel = BankDetailModel();
            userList.value[index].bankDetails = bankDetailModel;
            userList.refresh();
          }


    });
  }
}