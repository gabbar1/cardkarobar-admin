import 'package:cardkarobar/screens/dashboard/my_work_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/constant.dart';
import 'model/contact_model.dart';
import 'model/lead_model.dart';
import 'model/product_category.dart';

//enum SearchByValue { a,b }

class DashBoardController  extends GetxController{

  TextEditingController searchTextController = TextEditingController();
  TextEditingController searchLimitController = TextEditingController();
  TextEditingController assignController = TextEditingController();

  Future<void> updateData({String name,mobile}){}


  var leadList = <LeadModel>[].obs;
  List<LeadModel> get getLeadList => leadList.value;


  setLeadList(LeadModel leadModel){
    leadList.value.add(leadModel);
    leadList.value.sort((a,b)=> b.time.compareTo(a.time));
    leadList.refresh();
  }


  DocumentSnapshot lastDocument;
  Future<void> searchByCategory(phone,{isString =false}) async{
    leadList.value.clear();
    //ref.collection('user').orderBy('name').startAt(name).endAt(name+'\uf8ff')
    if(isString){
      FirebaseFirestore.instance.collection("leads").where('customer_phone', isEqualTo:phone).get().then((value) {
        value.docs.forEach((element) {
          LeadModel leadModel = LeadModel.fromJson(element.data());
          leadModel.key = element.id;
          setLeadList(leadModel);
        });
      });
    }else{
      FirebaseFirestore.instance.collection("leads").where('customer_phone', isEqualTo:phone).get().then((value) {
        value.docs.forEach((element) {
          LeadModel leadModel = LeadModel.fromJson(element.data());
          leadModel.key = element.id;
          setLeadList(leadModel);
        });
      });
    }

  }


  Future<void> myLeads() async{
    leadList.value.clear();

    print("===================New Load======================");
    FirebaseFirestore.instance.collection("leads").where("status",isEqualTo: "submitted").limit(5).get().then((value) {
      lastDocument = value.docs[value.docs.length -1];
      value.docs.forEach((element) {
        LeadModel leadModel = LeadModel.fromJson(element.data());
        leadModel.key = element.id;
        setLeadList(leadModel);
      });



    });

  }
  Future<void> myRefreshLeads() async{
    print("===================onRefresh======================");
    FirebaseFirestore.instance.collection("leads").where("status",isEqualTo: "submitted").limit(5).startAfterDocument(lastDocument).get().then((value) {
      print(value.docs.length);
      if(!value.docs.isEmpty){
        lastDocument = value.docs[value.docs.length -1];
      }

      value.docs.forEach((element) {
        LeadModel leadModel = LeadModel.fromJson(element.data());
        leadModel.key = element.id;
        setLeadList(leadModel);
      });
    });

  }

  DocumentSnapshot categoryLastDocument;
  Future<void> myCategoryLeads(String category) async{
    leadList.value.clear();
    leadList.refresh();
    
    FirebaseFirestore.instance.collection("leads").where("type",isEqualTo: category).where("status",isEqualTo: "submitted").limit(5).get().then((value) {
      if(!value.docs.isEmpty){
        categoryLastDocument = value.docs[value.docs.length -1];
        value.docs.forEach((element) {
          LeadModel leadModel = LeadModel.fromJson(element.data());
          leadModel.key = element.id;
          setLeadList(leadModel);
        });
      }else{
        commonSnackBar("Result", "No Lead found");
      }

    });

  }
  Future<void> myCategoryHistoryLeads(String category) async{
    leadList.value.clear();
    leadList.refresh();

    FirebaseFirestore.instance.collection("leads").where("type",isEqualTo: category).where("status",isEqualTo: "submitted").limit(5).get().then((value) {
      if(!value.docs.isEmpty){
        categoryLastDocument = value.docs[value.docs.length -1];
        value.docs.forEach((element) {
          LeadModel leadModel = LeadModel.fromJson(element.data());
          leadModel.key = element.id;
          setLeadList(leadModel);
        });
      }else{
        commonSnackBar("Result", "No Lead found");
      }

    });

  }
  Future<void> myCategoryRefreshLeads(String category) async{
    //historyLeadList.value.clear();
   // historyLeadList.refresh();
   
    FirebaseFirestore.instance.collection("leads").where("type",isEqualTo: category).where("status",isEqualTo: "submitted").limit(5).startAfterDocument(categoryLastDocument).get().then((value) {
      if (!value.docs.isEmpty) {
        categoryLastDocument = value.docs[value.docs.length - 1];
        value.docs.forEach((element) {
          LeadModel leadModel = LeadModel.fromJson(element.data());
          leadModel.key = element.id;
          setLeadList(leadModel);
        });
      } else {
        commonSnackBar("Result", "No Lead found");
      }
    });

  }

  var leadDetail = LeadModel().obs;
  LeadModel get getLeadDetail => leadDetail.value;
  set setLeadDetail(LeadModel val){
    leadDetail.value =val;
    leadDetail.refresh();
  }




  Future<void> submitReferral(LeadModel leadModel) async{


    FirebaseFirestore.instance.collection("leads").doc(leadModel.key).update(leadModel.toJson()).then((value) {
     leadList.value.removeWhere((element) => element.key == leadModel.key);
     leadList.refresh();
      // Share.share(url, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }).then((value) {

    });

  }

  var isExpand =false.obs;
  bool get getIsExpand => isExpand.value;
  set setIsExpand(bool val){
    isExpand.value = val;
  //  isExpand.refresh();
  }

  var assignLimit = 10.obs;
  int get getAssignLimit => assignLimit.value;
  set setAssignLimit(int val){
    assignLimit.value =val;
    assignLimit.refresh();
  }


  var assignUserName = "".obs;
  String get getAssignUserName => assignUserName.value;
  set setAssignUserName(String val){
    assignUserName.value =val;
    assignUserName.refresh();
  }

  var assignUserPhone = "".obs;
  String get getAssignUserPhone => assignUserPhone.value;
  set setAssignUserPhone(String val){
    assignUserPhone.value =val;
    assignUserPhone.refresh();
  }

  var assignType = "".obs;
  String get getAssignType => assignType.value;
  set setAssignType(String val){
    assignType.value =val;
    assignType.refresh();
  }


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


  var assignLeadList = <LeadModel>[].obs;
  List<LeadModel> get getAssignLeadList => assignLeadList.value;


 set setAssignLeadList(LeadModel leadModel){
    assignLeadList.value.add(leadModel);
    assignLeadList.refresh();
  }
  Future<void> getAssignLead({int limit, String type, String empPhone}) async{
   try{
     assignLeadList.value.clear();
     assignLeadList.refresh();
     showLoader();
     FirebaseFirestore.instance.collection("leads").where("type",isEqualTo: type).where("status",isEqualTo: "submitted").limit(limit).get().then((value) {
       value.docs.forEach((element) {
         LeadModel leadModel = LeadModel.fromJson(element.data());
         leadModel.key = element.id;
         leadModel.status = "UnderProcess";
         leadModel.assignedTo = empPhone;
         setAssignLeadList = leadModel;
       });
     }).then((value) {
       print("=====closeLoader==========");
       closeLoader();
     });
   }catch(e){
     closeLoader();
     throw e;
   }

  }

  Future<void> assignLead() async{
    try{
      showLoader();
      for(int i =0 ;i<getAssignLeadList.length;i++){
        getAssignLeadList[i].assignedTo = getAssignUserPhone;
        getAssignLeadList[i].status = "UnderProcess";
        FirebaseFirestore.instance.collection("leads").doc(getAssignLeadList[i].key).update(getAssignLeadList[i].toJson()).then((value) {
          if(i== getAssignLeadList.length-1){
            closeLoader();
            commonSnackBar("Alert", "Data Assigned");
            }
        });
      }
    }catch(e){
      closeLoader();
      throw e;
    }

  }

}