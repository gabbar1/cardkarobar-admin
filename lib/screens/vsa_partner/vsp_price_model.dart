class VSPPriceModel {
  bool isEnabled;
  String name;
  int price;
  String type;
  String partnerPhone;

  VSPPriceModel({this.isEnabled, this.name, this.price, this.type,this.partnerPhone});

  VSPPriceModel.fromJson(Map<String, dynamic> json) {
    isEnabled = json['isEnabled'];
    name = json['name'];
    price = json['price'];
    type = json['type'];
    type = json['type'];
    partnerPhone = json['partnerPhone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isEnabled'] = this.isEnabled;
    data['name'] = this.name;
    data['price'] = this.price;
    data['type'] = this.type;
    data['partnerPhone'] = this.partnerPhone;
    return data;
  }
}
