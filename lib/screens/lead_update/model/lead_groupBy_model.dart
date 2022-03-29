

import 'package:cardkarobar/screens/lead_update/model/lead_model.dart';

class LeadGroupByModel {
  String name;
  int count;
  List<LeadModel> leadList;

  LeadGroupByModel({this.name,this.count,this.leadList});

  LeadGroupByModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    count = json['count'];
    if (json['leadList'] != null) {
      leadList = <LeadModel>[];
      json['lst'].forEach((v) {
        leadList.add(new LeadModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['count'] = this.count;
    if (this.leadList != null) {
      data['leadList'] = this.leadList.map((v) => v.toJson()).toList();
    }
    return data;
  }

}