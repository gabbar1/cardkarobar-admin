

class UploadModel {
  String applicationNumber;
  String customerName;
  int customerPhone;
  String product;
  String type;
  String status;
  int referralPrice;
  bool isLeadClosed;
  String key;

  UploadModel(
      {this.applicationNumber,
        this.customerName,
        this.customerPhone,
        this.product,
        this.type,
        this.status,
        this.referralPrice,
        this.isLeadClosed,
        this.key
      });

  UploadModel.fromJson(Map<String, dynamic> json) {
    applicationNumber = json['applicationNumber'];
    customerName = json['customer_name'];
    customerPhone = json['customer_phone'];
    product = json['product'];
    type = json['type'];
    status = json['status'];
    referralPrice = json['referral_price'];
    isLeadClosed = json['isLeadClosed'];
    key = json['key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['applicationNumber'] = this.applicationNumber;
    data['customer_name'] = this.customerName;
    data['customer_phone'] = this.customerPhone;
    data['product'] = this.product;
    data['type'] = this.type;
    data['status'] = this.status;
    data['referral_price'] = this.referralPrice;
    data['isLeadClosed'] = this.isLeadClosed;
    data['key'] = this.key;
    return data;
  }
}
