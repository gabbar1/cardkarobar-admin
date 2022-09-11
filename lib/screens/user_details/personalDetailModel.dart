import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailModel {
  String advisor;
  String advisorEmail;
  String advisorName;
  String advisorPhoneNumber;
  String referedBy;
  String advisorDob;
  String advisorAdd1;
  String advisorAdd2;
  String advisorCity;
  String advisorState;
  int advisorPincode;
  String advisorOccupation;
  String advisorUrl;
  String total_wallet;
  String current_wallet;
  bool isAdmin;
  bool isEnabled;
  bool isOwner;
  String key;
  Timestamp registerDate;
  BankDetailModel bankDetails;

  UserDetailModel(
      {this.advisor,
        this.advisorEmail,
        this.advisorName,
        this.advisorPhoneNumber,
        this.referedBy,
        this.advisorDob,
        this.advisorAdd1,
        this.advisorAdd2,
        this.advisorCity,
        this.advisorState,
        this.advisorPincode,
        this.advisorOccupation,
        this.advisorUrl,
        this.total_wallet,
        this.current_wallet,
        this.isEnabled,
        this.isAdmin,
        this.key,
        this.registerDate,
        this.bankDetails,
        this.isOwner
      });

  UserDetailModel.fromJson(Map<String, dynamic> json) {
    advisor = json['advisor'].toString();
    advisorEmail = json['advisor_email'].toString();
    advisorName = json['advisor_name'].toString();
    advisorPhoneNumber = json['advisor_phone_number'].toString();
    referedBy = json['refered_By'].toString();
    advisorDob = json['advisor_dob'].toString();
    advisorAdd1 = json['advisor_add1'].toString();
    advisorAdd2 = json['advisor_add2'].toString();
    advisorCity = json['advisor_city'].toString();
    advisorState = json['advisor_state'].toString();
    advisorPincode = json['advisor_pincode'];
    advisorOccupation = json['advisor_occupation'].toString();
    advisorUrl = json['advisor_Url'].toString();
    total_wallet = json['total_wallet'].toString();
    current_wallet = json['current_wallet'].toString();
    isAdmin = json['isAdmin'];
     isEnabled = json['isEnabled'];
     key = json['key'].toString();
    registerDate = json['registerDate'];
    bankDetails = json['bankDetails'];
    isOwner = json['isOwner'];

  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['advisor'] = this.advisor;
    data['advisor_email'] = this.advisorEmail;
    data['advisor_name'] = this.advisorName;
    data['advisor_phone_number'] = this.advisorPhoneNumber;
    data['refered_By'] = this.referedBy;
    data['advisor_dob'] = this.advisorDob;
    data['advisor_add1'] = this.advisorAdd1;
    data['advisor_add2'] = this.advisorAdd2;
    data['advisor_city'] = this.advisorCity;
    data['advisor_state'] = this.advisorState;
    data['advisor_pincode'] = this.advisorPincode;
    data['advisor_occupation'] = this.advisorOccupation;
    data['advisor_Url'] = this.advisorUrl;
    data['total_wallet'] = this.total_wallet;
    data['current_wallet'] = this.current_wallet;
    data['isAdmin'] = this.isAdmin;
    data['isEnabled'] = this.isEnabled;
    data['key'] = this.key;
    data['registerDate'] = this.registerDate;
    data['bankDetails'] = this.bankDetails;
    data['isOwner'] = this.isOwner;
    return data;
  }
}
class BankDetailModel {
  String accHolderDocType;
  String accHolderDocUrl;
  String accHolderIfsc;
  String accHolderName;
  String accHolderNumber;
  String bankName;
  bool docVerification;

  BankDetailModel(
      {this.accHolderDocType,
        this.accHolderDocUrl,
        this.accHolderIfsc,
        this.accHolderName,
        this.accHolderNumber,
        this.bankName,
        this.docVerification});

  BankDetailModel.fromJson(Map<String, dynamic> json) {
    accHolderDocType = json['acc_holder_doc_type'];
    accHolderDocUrl = json['acc_holder_doc_url'];
    accHolderIfsc = json['acc_holder_ifsc'];
    accHolderName = json['acc_holder_name'];
    accHolderNumber = json['acc_holder_number'].toString();
    bankName = json['bank_name'];
    docVerification = json['doc_verification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acc_holder_doc_type'] = this.accHolderDocType;
    data['acc_holder_doc_url'] = this.accHolderDocUrl;
    data['acc_holder_ifsc'] = this.accHolderIfsc;
    data['acc_holder_name'] = this.accHolderName;
    data['acc_holder_number'] = this.accHolderNumber;
    data['bank_name'] = this.bankName;
    data['doc_verification'] = this.docVerification;
    return data;
  }
}
