import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../helper/constant.dart';
import '../dashboard/model/lead_model.dart';

class HistoryController extends GetxController{

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
   // historyLeadList.value.clear();
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
  Future<void> myCategoryRefreshLeads(String category) async{
    //historyLeadList.value.clear();
    // historyLeadList.refresh();
print('============category refresh================');
print(category);
    FirebaseFirestore.instance.collection("leads").where("type",isEqualTo: category).where("status",isNotEqualTo: "submitted").orderBy("status").limit(5).startAfterDocument(categoryLastDocument).get().then((value) {
      if (!value.docs.isEmpty) {
        categoryLastDocument = value.docs[value.docs.length - 1];
        value.docs.forEach((element) {
          LeadModel leadModel = LeadModel.fromJson(element.data());
          leadModel.key = element.id;
          setHistoryLeadList(leadModel);
        });
      } else {
        commonSnackBar("Result", "No Lead found");
      }
    });

  }

  Future<void> myCategoryLeads(String category) async{
    historyLeadList.value.clear();
    historyLeadList.refresh();

    FirebaseFirestore.instance.collection("leads").where("type",isEqualTo: category).where("status",isNotEqualTo: "submitted").orderBy("status").limit(5).get().then((value) {
      if(!value.docs.isEmpty){
        categoryLastDocument = value.docs[value.docs.length -1];
        value.docs.forEach((element) {
          LeadModel leadModel = LeadModel.fromJson(element.data());
          leadModel.key = element.id;
          setHistoryLeadList(leadModel);
        });
      }else{
        commonSnackBar("Result", "No Lead found");
      }

    });

  }

}