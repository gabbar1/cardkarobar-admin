import 'package:cardkarobar/screens/payment/payment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'dart:html' as html;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentController extends GetxController{

  var newPaymentList = <PaymentModel>[].obs;
  List<PaymentModel> get getNewPaymentList => newPaymentList.value;
  set setNewPaymentList(PaymentModel val){
    newPaymentList.value.add(val);
    newPaymentList.refresh();
  }
  newPaymentRequest(){
    newPaymentList.value.clear();
    newPaymentList.refresh();
    FirebaseFirestore.instance.collection("payment_history").orderBy("PYMT_DATE",descending: true).where("status",isEqualTo: "UnderProcess").get().then((value) {
      value.docs.forEach((element) {
        if(element.exists){
          PaymentModel paymentModel = PaymentModel.fromJson(element.data());
          paymentModel.key = element.id;
          setNewPaymentList = paymentModel;
        }
      });
    });
  }
  
  downloadPaymentList(){
    {

      var excel = Excel.createExcel();
      Sheet sheetObject = excel["payment"];
      sheetObject.insertColumn(0);
      var amount = sheetObject.cell(CellIndex.indexByString('A${1}'));
      amount.value = "AMOUNT";
      var accountNo = sheetObject.cell(CellIndex.indexByString('B${1}'));
      accountNo.value = "BENE_ACC_NO";
      var ifsc = sheetObject.cell(CellIndex.indexByString('C${1}'));
      ifsc.value ="BENE_IFSC";
      var accountName = sheetObject.cell(CellIndex.indexByString('D${1}'));
      accountName.value = "BNF_NAME";
      var debitNumber = sheetObject.cell(CellIndex.indexByString('E${1}'));
      debitNumber.value = "DEBIT_ACC_NO";
      var time = sheetObject.cell(CellIndex.indexByString('F${1}'));
      time.value = "PYMT_DATE";
      var paymentMode = sheetObject.cell(CellIndex.indexByString('G${1}'));
      paymentMode.value = "PYMT_MODE";
      var paymentType = sheetObject.cell(CellIndex.indexByString('H${1}'));
      paymentType.value = "PYMT_PROD_TYPE_CODE";
      var remark = sheetObject.cell(CellIndex.indexByString('I${1}'));
      remark.value = "REMARK";
      var status = sheetObject.cell(CellIndex.indexByString('J${1}'));
      status.value = "status";
      var user_id = sheetObject.cell(CellIndex.indexByString('J${1}'));
      user_id.value = "user_id";
      var key = sheetObject.cell(CellIndex.indexByString('J${1}'));
      key.value = "key";
      for (int i = 0; i < getNewPaymentList.length; i++) {
        var amount = sheetObject.cell(CellIndex.indexByString('A${i+2}'));
        amount.value = getNewPaymentList[i].aMOUNT.toString();
        var accountNo = sheetObject.cell(CellIndex.indexByString('B${i+2}'));
        accountNo.value = getNewPaymentList[i].bENEACCNO.toString();
        var ifsc = sheetObject.cell(CellIndex.indexByString('C${i+2}'));
        ifsc.value = getNewPaymentList[i].bENEIFSC.toString();
        var bName = sheetObject.cell(CellIndex.indexByString('D${i+2}'));
        bName.value = getNewPaymentList[i].bNFNAME.toString();
        var debitNumber = sheetObject.cell(CellIndex.indexByString('E${i+2}'));
        debitNumber.value = getNewPaymentList[i].dEBITACCNO.toString();
        var time = sheetObject.cell(CellIndex.indexByString('F${i+2}'));
        time.value = DateFormat().format(getNewPaymentList[i].pYMTDATE.toDate()).toString();
        var status = sheetObject.cell(CellIndex.indexByString('G${i+2}'));
        status.value = getNewPaymentList[i].status.toString();
        var paymentMode = sheetObject.cell(CellIndex.indexByString('H${i+2}'));
        paymentMode.value = getNewPaymentList[i].pYMTMODE.toString();
        var paymentType = sheetObject.cell(CellIndex.indexByString('I${i+2}'));
        paymentType.value = getNewPaymentList[i].pYMTPRODTYPECODE.toString();
        var remark = sheetObject.cell(CellIndex.indexByString('J${i+2}'));
        remark.value = getNewPaymentList[i].rEMARK.toString();
        var user_id = sheetObject.cell(CellIndex.indexByString('J${i+2}'));
        user_id.value = getNewPaymentList[i].userId.toString();
        var key = sheetObject.cell(CellIndex.indexByString('J${i+2}'));
        user_id.value = getNewPaymentList[i].key.toString();
      }


      final bytes = excel.encode();
      final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor =
      html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = 'payment_${DateTime.now()}.xlsx';
      html.document.body.children.add(anchor);

      // download
      anchor.click();

      // cleanup
      html.document.body.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    }
  }

  acceptOrRejectPayment(PaymentModel paymentModel){
    FirebaseFirestore.instance.collection("payment_history").doc(paymentModel.key).update(paymentModel.toJson()).then((value) {
      newPaymentList.value.remove(paymentModel);
      newPaymentList.refresh();
    });
  }


  var oldPaymentList = <PaymentModel>[].obs;
  List<PaymentModel> get getOldPaymentList => oldPaymentList.value;
  set setOldPaymentList(PaymentModel val){
    oldPaymentList.value.add(val);
    oldPaymentList.refresh();
  }
  oldPaymentRequest(){
    oldPaymentList.value.clear();
    oldPaymentList.refresh();
    FirebaseFirestore.instance.collection("payment_history").where("status",isNotEqualTo: "UnderProcess").get().then((value) {
      value.docs.forEach((element) {
        if(element.exists){
          print("================element.data()====================");
          PaymentModel paymentModel = PaymentModel.fromJson(element.data());
          print(paymentModel.toJson());
          paymentModel.key = element.id;
          setOldPaymentList = paymentModel;
        }
      });
    });
  }
}