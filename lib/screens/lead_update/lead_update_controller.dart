
import 'dart:convert';

import 'package:cardkarobar/screens/lead_update/model/lead_groupBy_model.dart';
import 'package:cardkarobar/screens/lead_update/model/lead_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

import '../user_details/personalDetailModel.dart';


class LeadUpdateController extends GetxController{

  var leadUpdateList = <LeadModel>[].obs;
  List<LeadModel> get getLeadUpdateList => leadUpdateList.value;
  set setLeadUpdateList(LeadModel val){
    leadUpdateList.value.add(val);
    leadUpdateList.refresh();
  }

  var leadGroupByList = <LeadGroupByModel>[].obs;
  List<LeadGroupByModel> get getLeadGroupByList => leadGroupByList.value;
  set setLeadGroupByList(LeadGroupByModel val){
    leadGroupByList.value.add(val);
    leadGroupByList.refresh();
  }
 var leadCount = 0.obs;
  int  get getLeadCount => leadCount.value;
  set setLeadCount(int val){
    leadCount.value =val;
    leadCount.refresh();
  }

  DocumentSnapshot lastDocument;
  leadUpdate(String type){
    leadUpdateList.value.clear();
    leadUpdateList.refresh();
    leadGroupByList.value.clear();
    leadGroupByList.refresh();

    if(type=="Today"){
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month,currentDate.day);
      FirebaseFirestore.instance.collection("leads").where("time",isGreaterThanOrEqualTo: Timestamp.fromDate(beforeDate)).get().then((value) {
        lastDocument = value.docs[value.docs.length -1];
        setLeadCount = value.docs.length;
        value.docs.forEach((element) {

          LeadModel _leadModel = LeadModel.fromJson(element.data());
          _leadModel.key = element.id;
          FirebaseFirestore.instance.collection("user_details").doc(_leadModel.assignedTo).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            _leadModel.assignedTo = userDetailModel.advisorName;
          });
          setLeadUpdateList = _leadModel;
        });
      }).then((value) {
        var groupByDate = getLeadUpdateList.groupListsBy((element) => element.referralId,);
        groupByDate.forEach((key, groupList) {
          print(key);
          FirebaseFirestore.instance.collection("user_details").doc(key.toString()).get().then((value) {

            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            LeadGroupByModel leadGroupByModel = LeadGroupByModel(name: userDetailModel.advisorName,count: groupList.length,leadList: groupList);
            setLeadGroupByList =leadGroupByModel ;
          });

        });
      });
    }
    else if (type =='YesterDay'){
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month,currentDate.day-1);
      FirebaseFirestore.instance.collection("leads").where("time",isGreaterThanOrEqualTo: Timestamp.fromDate(beforeDate)).get().then((value) {
        lastDocument = value.docs[value.docs.length -1];
        setLeadCount = value.docs.length;
        value.docs.forEach((element) {
          LeadModel _leadModel = LeadModel.fromJson(element.data());
          _leadModel.key = element.id;
          FirebaseFirestore.instance.collection("user_details").doc(_leadModel.assignedTo).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            _leadModel.assignedTo = userDetailModel.advisorName;
          });
          setLeadUpdateList = _leadModel;
        });
      }).then((value) {
        var groupByDate = getLeadUpdateList.groupListsBy((element) => element.referralId,);
        groupByDate.forEach((key, groupList) {
          print(key);
          FirebaseFirestore.instance.collection("user_details").doc(key.toString()).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            LeadGroupByModel leadGroupByModel = LeadGroupByModel(name: userDetailModel.advisorName,count: groupList.length,leadList: groupList);
            setLeadGroupByList =leadGroupByModel ;
          });
        });
      });
    }
    else if(type =='This Week') {
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month,currentDate.day-6);
      FirebaseFirestore.instance.collection("leads").where("time",isGreaterThanOrEqualTo: Timestamp.fromDate(beforeDate)).get().then((value) {
        lastDocument = value.docs[value.docs.length -1];
        setLeadCount = value.docs.length;
        value.docs.forEach((element) {
          LeadModel _leadModel = LeadModel.fromJson(element.data());
          _leadModel.key = element.id;
          FirebaseFirestore.instance.collection("user_details").doc(_leadModel.assignedTo).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            _leadModel.assignedTo = userDetailModel.advisorName;
          });
          setLeadUpdateList = _leadModel;
        });
      }).then((value) {
        var groupByDate = getLeadUpdateList.groupListsBy((element) => element.referralId,);
        groupByDate.forEach((key, groupList) {
          print(key);
          FirebaseFirestore.instance.collection("user_details").doc(key.toString()).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            LeadGroupByModel leadGroupByModel = LeadGroupByModel(name: userDetailModel.advisorName,count: groupList.length,leadList: groupList);
            setLeadGroupByList =leadGroupByModel ;
          });
        });
      });
    }
    else if(type == 'Last Week'){
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month,currentDate.day-13);
      FirebaseFirestore.instance.collection("leads").where("time",isGreaterThanOrEqualTo: Timestamp.fromDate(beforeDate)).get().then((value) {
        lastDocument = value.docs[value.docs.length -1];
        setLeadCount = value.docs.length;
        value.docs.forEach((element) {
          LeadModel _leadModel = LeadModel.fromJson(element.data());
          _leadModel.key = element.id;
          FirebaseFirestore.instance.collection("user_details").doc(_leadModel.assignedTo).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            _leadModel.assignedTo = userDetailModel.advisorName;
          });
          setLeadUpdateList = _leadModel;
        });
      }).then((value) {
        var groupByDate = getLeadUpdateList.groupListsBy((element) => element.referralId,);
        groupByDate.forEach((key, groupList) {
          print(key);
          FirebaseFirestore.instance.collection("user_details").doc(key.toString()).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            LeadGroupByModel leadGroupByModel = LeadGroupByModel(name: userDetailModel.advisorName,count: groupList.length,leadList: groupList);
            setLeadGroupByList =leadGroupByModel ;
          });
        });
      });
    }
    else if(type =='This Month'){
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month);
      FirebaseFirestore.instance.collection("leads").where("time",isGreaterThanOrEqualTo: Timestamp.fromDate(beforeDate)).get().then((value) {
        lastDocument = value.docs[value.docs.length -1];
        setLeadCount = value.docs.length;
        value.docs.forEach((element) {
          LeadModel _leadModel = LeadModel.fromJson(element.data());
          _leadModel.key = element.id;
          FirebaseFirestore.instance.collection("user_details").doc(_leadModel.assignedTo).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            _leadModel.assignedTo = userDetailModel.advisorName;
          });
          setLeadUpdateList = _leadModel;
        });
      }).then((value) {
        var groupByDate = getLeadUpdateList.groupListsBy((element) => element.referralId,);
        groupByDate.forEach((key, groupList) {
          print(key);
          FirebaseFirestore.instance.collection("user_details").doc(key.toString()).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            LeadGroupByModel leadGroupByModel = LeadGroupByModel(name: userDetailModel.advisorName,count: groupList.length,leadList: groupList);
            setLeadGroupByList =leadGroupByModel ;
          });
        });
      });
    }
    else if(type =='Last Month'){
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month-29);
      FirebaseFirestore.instance.collection("leads").where("time",isGreaterThanOrEqualTo: Timestamp.fromDate(beforeDate)).get().then((value) {
        lastDocument = value.docs[value.docs.length -1];
        setLeadCount = value.docs.length;
        value.docs.forEach((element) {
          LeadModel _leadModel = LeadModel.fromJson(element.data());
          _leadModel.key = element.id;
          FirebaseFirestore.instance.collection("user_details").doc(_leadModel.assignedTo).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            _leadModel.assignedTo = userDetailModel.advisorName;
          });
          setLeadUpdateList = _leadModel;
        });
      }).then((value) {
        var groupByDate = getLeadUpdateList.groupListsBy((element) => element.referralId,);
        groupByDate.forEach((key, groupList) {
          print(key);
          FirebaseFirestore.instance.collection("user_details").doc(key.toString()).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            LeadGroupByModel leadGroupByModel = LeadGroupByModel(name: userDetailModel.advisorName,count: groupList.length,leadList: groupList);
            setLeadGroupByList =leadGroupByModel ;
          });
        });
      });
    }
    else{
      var currentDate = DateTime.now();
      var beforeDate = DateTime(currentDate.year,currentDate.month,currentDate.day);
      FirebaseFirestore.instance.collection("leads").where("status",isEqualTo: type).get().then((value) {
        lastDocument = value.docs[value.docs.length -1];
        setLeadCount = value.docs.length;
        value.docs.forEach((element) {
          LeadModel _leadModel = LeadModel.fromJson(element.data());
          _leadModel.key = element.id;
          FirebaseFirestore.instance.collection("user_details").doc(_leadModel.assignedTo).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            _leadModel.assignedTo = userDetailModel.advisorName;
          });
          setLeadUpdateList = _leadModel;
        });
      }).then((value) {
        var groupByDate = getLeadUpdateList.groupListsBy((element) => element.referralId,);
        groupByDate.forEach((key, groupList) {
          print(key);
          FirebaseFirestore.instance.collection("user_details").doc(key.toString()).get().then((value) {
            UserDetailModel userDetailModel = UserDetailModel.fromJson(value.data());
            LeadGroupByModel leadGroupByModel = LeadGroupByModel(name: userDetailModel.advisorName,count: groupList.length,leadList: groupList);
            setLeadGroupByList =leadGroupByModel ;
          });

        });
      });
    }

  }
}