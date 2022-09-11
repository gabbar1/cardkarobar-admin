import 'package:cloud_firestore/cloud_firestore.dart';

class DownloadModel {
  String applicationNumber;
  String customerName;
  double customerPhone;
  String product;
  String type;
  Timestamp time;
  String status;
  double referralPrice;
  bool isLeadClosed;
  String key;

  DownloadModel(
      {this.applicationNumber,
        this.customerName,
        this.customerPhone,
        this.product,
        this.type,
        this.time,
        this.status,
        this.referralPrice,
        this.isLeadClosed,
        this.key
      });

  DownloadModel.fromJson(Map<String, dynamic> json) {
    applicationNumber = json['applicationNumber'].toString();
    customerName = json['customer_name'].toString();
    print("========================referral_price================");
     print(json['customer_phone']);
    customerPhone = json['customer_phone'];
    product = json['product'].toString();
    type = json['type'].toString();
    time = json['time'];
    status = json['status'].toString();
    print(json['referral_price']);
    referralPrice = json['referral_price'];
    isLeadClosed = json['isLeadClosed'];
    key = json['key'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applicationNumber'] = this.applicationNumber;
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['product'] = this.product;
    data['type'] = this.type;
    data['time'] = this.time;
    data['status'] = this.status;
    data['referral_price'] = this.referralPrice;
    data['isLeadClosed'] = this.isLeadClosed;
    data['key'] = this.key;
    return data;
  }
}
