import 'dart:html' as html;
import 'package:cardkarobar/screens/dashboard/personalDetailModel.dart';
import 'package:cardkarobar/screens/upload_status/model/upload_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../dashboard/model/lead_model.dart';
import '../dashboard/my_work_controller.dart ';
import 'model/download_model.dart';

class UploadStatusController extends GetxController{

  var jsonMap = [].obs;
  List<dynamic> get getJsonMap => jsonMap.value;

  setJsonMap(var data){
    jsonMap.value.add(data);
    jsonMap.refresh();
  }
  Future<List<dynamic>> excelToJson() async {

    try{
      FilePickerResult result =await FilePicker.platform.pickFiles(type:FileType.custom,allowedExtensions: ['xls','xlsx','csv']);

      print("===== webFile.File file = await webPicker.FilePicker.getF===========");
      print(result.files.single.name);
      //var bytes = File(result.files.single.name).;
      print("== webFile.File file = await webPicker.FilePicker.getF============");
      var excel = Excel.decodeBytes(result.files.single.bytes);
      int i = 0;
      int count =0;


      var keys = [];

      for (var table in excel.tables.keys) {

        for (var row in excel.tables[table].rows) {



          if (i == 0) {
            row.forEach((element) {
              keys.add(element.value);
            });
            //keys = row;
            print(keys);

            i++;
          }
          else {
            count = count+1;
            var temp = {};
            var temp1 ={} ;
            int j = 0;
            String tk = '';
            for (var key in keys) {
              tk = '${key.toString()}';
              temp[tk] = (row[j].runtimeType == String) ?  '\"${row[j].value.toString()}\"' : row[j] == null ? "NA ":row[j].value=="false"? false:row[j].value;


              // print(temp1);

              j++;
            }

            temp1['\"${count.toString()}\"'] =temp;
            setJsonMap(temp);

          }

        }

      }
      return getJsonMap;
    }catch(exception){
      closeLoader();
      Get.snackbar("Error", exception.toString());
      throw exception;
    }

  }

  var uploadList = <UploadModel>[].obs;
  List<UploadModel> get getUploadList =>uploadList.value;
  set setUploadList(UploadModel val){
    uploadList.value.add(val);
    uploadList.refresh();
  }

  var uploadedList = <UploadModel>[].obs;
  List<UploadModel> get getUploadedList =>uploadedList.value;
  set setUploadedList(UploadModel val){
    uploadedList.value.add(val);
    uploadedList.refresh();
  }

  Future<void> uploadData()async{
    uploadList.value.clear();
    uploadList.refresh();
    try{
      jsonMap.value.clear();
      var jsonData =await excelToJson();
      jsonData.forEach((element) {
        print("json-------------------------------------------------------");
        UploadModel _uploadModel = UploadModel(
          applicationNumber: element["Application Number"],
          customerName: element["Customer Name"],
          customerPhone: int.parse(element["Customer Phone"]),
          product: element["Product Name"],
          type: element["Lead Type"],
          //time: Timestamp.fromDate(DateTime.parse(element["Lead Date"])),
          status: element["Status"],
          referralPrice:int.parse(element["Referral Price"]),
          isLeadClosed: element["Lead Closed"],
          key: element["key"]
        );
        setUploadList = _uploadModel;
        print(_uploadModel.toJson());
      });
      int cnd =0;


    }catch(exception){
      closeLoader();
      Get.snackbar("Error", exception.toString());
      throw exception;
    }


  }

  var productLists = <String>['---Filter---'].obs;
  List<String> get getProductList => productLists.value;
  set setProductList(String val){
    productLists.value.add(val);
    productLists.refresh();
  }
  Future<void> productList() async{
    try{
      FirebaseFirestore.instance.collection("direct-selling-referral").where("isEnabled",isNotEqualTo: false).get().then((value) {
        value.docs.forEach((element) {
          print("============== element============");
          print( element["name"]);
          setProductList = element["name"];
        });
      });
    }catch(e){
      throw e;
    }
  }

  var downloadExcel = <DownloadModel>[].obs;
  List<DownloadModel> get getDownloadList => downloadExcel.value;
  set setDownLoadList(DownloadModel val){
    downloadExcel.value.add(val);
    downloadExcel.refresh();
  }
  Future<void> downloadList(String product) async{
    downloadExcel.value.clear();
    downloadExcel.refresh();
    try{
      FirebaseFirestore.instance.collection("leads").where("product",isEqualTo: product).where("status",isEqualTo: "Login").where("isLeadClosed",isNotEqualTo: true).get().then((value) {
        value.docs.forEach((element) {
          print("============== element============");
          DownloadModel downloadModel = DownloadModel.fromJson(element.data());
          downloadModel.key = element.id;
          setDownLoadList = downloadModel;
        });
      }).then((value) {

        var excel = Excel.createExcel();
        Sheet sheetObject = excel[product];
        sheetObject.insertColumn(0);

        var applicationNumber = sheetObject.cell(CellIndex.indexByString('A${1}'));

        applicationNumber.value = "Application Number";
        var customerName = sheetObject.cell(CellIndex.indexByString('B${1}'));
        customerName.value = "Customer Name";
        var customerPhone = sheetObject.cell(CellIndex.indexByString('C${1}'));
        customerPhone.value ="Customer Phone";
        var productName = sheetObject.cell(CellIndex.indexByString('D${1}'));
        productName.value = "Product Name";
        var type = sheetObject.cell(CellIndex.indexByString('E${1}'));
        type.value = "Lead Type";
        var time = sheetObject.cell(CellIndex.indexByString('F${1}'));
        time.value = "Lead Date";
        var status = sheetObject.cell(CellIndex.indexByString('G${1}'));
        status.value = "Status";
        var referralPrice = sheetObject.cell(CellIndex.indexByString('H${1}'));
        referralPrice.value = "Referral Price";
        var isLeadClosed = sheetObject.cell(CellIndex.indexByString('I${1}'));
        isLeadClosed.value = "Lead Closed";
        var key = sheetObject.cell(CellIndex.indexByString('J${1}'));
        key.value = "key";
        for (int i = 0; i < getDownloadList.length; i++) {
          var applicationNumber = sheetObject.cell(CellIndex.indexByString('A${i+2}'));
          applicationNumber.value = getDownloadList[i].applicationNumber.toString();
          var customerName = sheetObject.cell(CellIndex.indexByString('B${i+2}'));
          customerName.value = getDownloadList[i].customerName.toString();
          var customerPhone = sheetObject.cell(CellIndex.indexByString('C${i+2}'));
          customerPhone.value = getDownloadList[i].customerPhone.toString();
          var product = sheetObject.cell(CellIndex.indexByString('D${i+2}'));
          product.value = getDownloadList[i].product.toString();
          var type = sheetObject.cell(CellIndex.indexByString('E${i+2}'));
          type.value = getDownloadList[i].type.toString();
          var time = sheetObject.cell(CellIndex.indexByString('F${i+2}'));
          time.value = DateFormat().format(getDownloadList[i].time.toDate()).toString();
          var status = sheetObject.cell(CellIndex.indexByString('G${i+2}'));
          status.value = getDownloadList[i].status.toString();
          var referralPrice = sheetObject.cell(CellIndex.indexByString('H${i+2}'));
          referralPrice.value = getDownloadList[i].referralPrice.toString();
          var isLeadClosed = sheetObject.cell(CellIndex.indexByString('I${i+2}'));
          isLeadClosed.value = getDownloadList[i].isLeadClosed.toString();
          var key = sheetObject.cell(CellIndex.indexByString('J${i+2}'));
          key.value = getDownloadList[i].key.toString();
        }


        final bytes = excel.encode();
        final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor =
        html.document.createElement('a') as html.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = '${product}.xlsx';
        html.document.body.children.add(anchor);

        // download
        anchor.click();

        // cleanup
        html.document.body.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      });
    }catch(e){
      throw e;
    }
  }
  
  updateLeadStatus() async{
    bool newUpdate =true;

    for(int i=0;i<getUploadList.length;i++) {
      try{
        showLoader();
        print("====================run transaction===============;");
        FirebaseFirestore _firestore = FirebaseFirestore.instance;
        await _firestore.runTransaction((transaction) async{
          DocumentReference getLead  = _firestore.collection("leads").doc(getUploadList[i].key);
         // DocumentReference getLead2  = _firestore.collection("leads").doc(getUploadList[i].key);
          DocumentSnapshot getLeadDoc = await transaction.get(getLead);
          LeadModel _leadModel = LeadModel.fromJson(getLeadDoc.data());
          _leadModel.key = getLead.id;
          if(getUploadList[i].status.trim() == "Approved"){
            print("=============check Entries==============");
            print(i);
            print(getUploadList[i].key);
            DocumentReference userDetails  = await _firestore.collection("user_details").doc(_leadModel.referralId.toString());
            DocumentSnapshot userDetailsSnap = await transaction.get(userDetails);
            print(userDetailsSnap["total_wallet"]);
            UserDetailModel _userDetailModel = UserDetailModel.fromJson(userDetailsSnap.data());
            DocumentReference referralDetails  = _firestore.collection("user_details").doc(_userDetailModel.referedBy);
            DocumentSnapshot referralDetailsSnap = await transaction.get(referralDetails);
          //  print(referralDetailsSnap.data());
            UserDetailModel _refferalDetailModel = UserDetailModel.fromJson(referralDetailsSnap.data());
            await transaction.update(userDetails,{
              "total_wallet":(double.parse(_userDetailModel.total_wallet) + _leadModel.referralPrice).toString(),
              "current_wallet":(double.parse(_userDetailModel.current_wallet) + _leadModel.referralPrice).toString(),
            });

            await transaction.update(referralDetails,{
              "total_wallet":(double.parse(_refferalDetailModel.total_wallet) + ((10/100)*_leadModel.referralPrice)).toString(),
              "current_wallet":(double.parse(_refferalDetailModel.current_wallet) + ((10/100)*_leadModel.referralPrice)).toString(),
            });

          }
          getUploadList[i].isLeadClosed =true;
           await transaction.update(getLead,getUploadList[i].toJson());
         /* uploadList.value.removeAt(i);
          uploadList.refresh();
          uploadedList.value.add(getUploadList[i]);
          uploadedList.refresh();*/

            closeLoader();

        }).then((value) {
          setUploadedList = getUploadList[i];
         /* setUploadedList = getUploadList[i];
          uploadList.value.remove(getUploadList[i]);
          uploadList.refresh();*/
        });

      }
      catch(e){
        closeLoader();
        Get.snackbar("Error", e.toString());
      }
    }
  }

  unassignNumber(){
    FirebaseFirestore.instance.collection("leads").where("status",isNotEqualTo: "Login").get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
        if(element["type"]=="Credit Card"){
          FirebaseFirestore.instance.collection("leads").doc(element.id).update({
            "assignedTo":"9726868497",
            "status":"UnderProcess"
          });
        }
      });
    });
  }
  

}