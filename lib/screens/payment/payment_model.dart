import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentModel {
  String aMOUNT;
  String bENEACCNO;
  String bENEIFSC;
  String bNFNAME;
  String dEBITACCNO;
  Timestamp pYMTDATE;
  String pYMTMODE;
  String pYMTPRODTYPECODE;
  String rEMARK;
  String status;
  String userId;
  String key;

  PaymentModel(
      {this.aMOUNT,
        this.bENEACCNO,
        this.bENEIFSC,
        this.bNFNAME,
        this.dEBITACCNO,
        this.pYMTDATE,
        this.pYMTMODE,
        this.pYMTPRODTYPECODE,
        this.rEMARK,
        this.status,
        this.userId,
        this.key});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    aMOUNT = json['AMOUNT'];
    bENEACCNO = json['BENE_ACC_NO'];
    bENEIFSC = json['BENE_IFSC'];
    bNFNAME = json['BNF_NAME'];
    dEBITACCNO = json['DEBIT_ACC_NO'];
    pYMTDATE = json['PYMT_DATE'];
    pYMTMODE = json['PYMT_MODE'];
    pYMTPRODTYPECODE = json['PYMT_PROD_TYPE_CODE'];
    rEMARK = json['REMARK'];
    status = json['status'];
    userId = json['user_id'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AMOUNT'] = this.aMOUNT;
    data['BENE_ACC_NO'] = this.bENEACCNO;
    data['BENE_IFSC'] = this.bENEIFSC;
    data['BNF_NAME'] = this.bNFNAME;
    data['DEBIT_ACC_NO'] = this.dEBITACCNO;
    data['PYMT_DATE'] = this.pYMTDATE;
    data['PYMT_MODE'] = this.pYMTMODE;
    data['PYMT_PROD_TYPE_CODE'] = this.pYMTPRODTYPECODE;
    data['REMARK'] = this.rEMARK;
    data['status'] = this.status;
    data['user_id'] = this.userId;
    data['key'] = this.key;
    return data;
  }
}
