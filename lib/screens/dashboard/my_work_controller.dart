import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:excel/excel.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:path_provider/path_provider.dart';

import '../../helper/constant.dart';
import 'model/contact_model.dart';
//import 'package:upen/commonWidget/loader.dart';
//import 'package:upen/screen/helper/constant.dart';

//import '../model/contact_model.dart';
showLoader(
    {bool isLoading = false}) {
  Widget progressIndicator = CupertinoActivityIndicator(
    radius: 14,
  );

  return Get.dialog(
    Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      body: Center(
          child: isLoading
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Loading....",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              progressIndicator
            ],
          )
              : progressIndicator),
    ),
    barrierColor: Colors.black.withOpacity(0.3),
    barrierDismissible: false,
  );
}

closeLoader() {
  if (Get.isOverlaysOpen) Get.back();
}



class MyWorkController extends GetxController{





}




class ResponseModel {
  String profession;
  String zip;
  String lastName;
  String gender;
  String decision;
  String name;
  String mobile;
  String city;
  String state;
  String version;
  String email;
  String status;

  ResponseModel(
      {this.profession,
        this.zip,
        this.lastName,
        this.gender,
        this.decision,
        this.name,
        this.mobile,
        this.city,
        this.state,
        this.version,
        this.email,
        this.status});

  ResponseModel.fromJson(Map<String, dynamic> json) {
    profession = json['profession'].toString();
    zip = json['zip'].toString();
    lastName = json['last name'].toString();
    gender = json['gender'].toString();
    decision = json['decision'].toString();
    name = json['name'].toString();
    mobile = json['mobile'].toString();
    city = json['City'].toString();
    state = json['state'].toString();
    version = json['version'].toString();
    email = json['email'].toString();
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profession'] = this.profession;
    data['zip'] = this.zip;
    data['last name'] = this.lastName;
    data['gender'] = this.gender;
    data['decision'] = this.decision;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['City'] = this.city;
    data['state'] = this.state;
    data['version'] = this.version;
    data['email'] = this.email;
    data['status'] = this.status;
    return data;
  }
}

