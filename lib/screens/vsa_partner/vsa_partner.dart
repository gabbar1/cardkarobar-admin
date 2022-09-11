import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cardkarobar/screens/user_details/user_controller.dart';
import 'package:cardkarobar/screens/vsa_partner/vsp_price_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../helper/constant.dart';
import '../dashboard/dashboard_controller.dart';
import '../partner/controller/partner_controller.dart';
import '../partner/model/category_model.dart';
import '../partner/model/referModel.dart';
import '../user_details/personalDetailModel.dart';
import 'vsp_controller.dart';

class VSPartner extends StatefulWidget {
  @override
  _VSPartnerState createState() => _VSPartnerState();
}

class _VSPartnerState extends State<VSPartner> {
  UserController _userController = Get.put(UserController());
  VSPController _vSPController = Get.put(VSPController());
  DashBoardController dashBoardController = Get.find();
  bool isCategory = false;
  String existingBank;
  bool isExpand = false;
  bool isClick = false;
  String leadStatus = "--All Category--";
  String updateStatus = "--No Status--";
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  TextEditingController assignController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  FocusNode focusSearch = FocusNode();
  String existingStatus;
  bool showBankDetails = false;

  TextEditingController pName = TextEditingController();
  TextEditingController pUrl = TextEditingController();
  TextEditingController rUrl = TextEditingController();
  TextEditingController pPrice = TextEditingController();
  TextEditingController yUrl = TextEditingController();
  TextEditingController cName = TextEditingController();
  TextEditingController categoryName = TextEditingController();
  TextEditingController productCategoryDetailing = TextEditingController();
  TextEditingController categoryLogo = TextEditingController();
  PartnerController _partnerController = Get.put(PartnerController());

  Widget usersearch(List<UserDetailModel> userList) {
    return Padding(
      padding: const EdgeInsets.only(left: 50, top: 20, bottom: 10.0),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / 5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: mainColor)),
        child: TextField(
          controller: assignController,
          decoration: const InputDecoration(
            prefixIcon: Icon(
              Icons.account_circle_outlined,
              size: 25,
              color: Colors.grey,
            ),
            border: InputBorder.none,
            hintText: 'Search User Here.',
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.only(left: 8.0, top: 15.0),
          ),
          onChanged: (val) {
            try {
              var phone = int.parse(val);
              if (val.length == 10) {
                _vSPController.getSearchByUserPhone(phone.toString());
              }
            } catch (e) {
              _debouncer.call(() {
                _vSPController.getSearchByUserName(val.toString());
              });
            }
          },
        ),
      ),
    );
  }
  Widget searchNewUser() {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width / 5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: mainColor)),
      child: TextField(

        controller: assignController,
        decoration: const InputDecoration(
          prefixIcon: Icon(
            Icons.account_circle_outlined,
            size: 25,
            color: Colors.grey,
          ),
          border: InputBorder.none,
          hintText: 'Search User',
          filled: true,
          fillColor: Colors.white,

          contentPadding: EdgeInsets.only(left: 8.0, top: 15.0),
        ),
        onChanged: (val) {
            var phone = int.parse(val);
            if (val.length == 10) {
              _vSPController.getSearchByNewUserPhone(phone.toString());
            }
        },
      ),
    );
  }
  Widget userBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Center(
        child: Container(
          height: 60,
          width: !isExpand
              ? MediaQuery.of(context).size.width / 5
              : MediaQuery.of(context).size.width / 8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: mainColor)),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: DropdownButtonFormField<String>(
            value: leadStatus,
            decoration: const InputDecoration(
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            items: <String>['--All Category--', 'All Users', 'New Users']
                .map((String value) {
              setState(() {
                existingBank = value;
              });
              return DropdownMenuItem<String>(
                onTap: () {
                  print("===============ontap");
                  print(value);
                  if (value == 'All Users') {
                    isCategory = false;
                    _userController.getUserList();
                  } else {
                    isCategory = true;
                    _userController.myNewUsers();
                  }
                },
                value: existingBank,
                child: CommonText(text: existingBank, textColor: mainColor),
              );
            }).toList(),
            validator: (value) {
              print("-----------ValidatedOr not------------");
              print(value);
              if (value == null) {
                return 'Field required';
              }
              return null;
            },
            onChanged: (val) {},
          ),
        ),
      ),
    );
  }
  Widget _userlogList(List<UserDetailModel> userList) {
    return userList.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
            ),
          )
        : Padding(
            padding:
                const EdgeInsets.only(left: 40, top: 8, right: 40, bottom: 8),
            child: LazyLoadScrollView(
                onEndOfPage: () => _vSPController.myNewUserRefreshList(),
                child: ListView.builder(
                  // scrollDirection: Axis.horizontal,
                  itemCount: userList.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _userController.setUserDetails = userList[index];
                        _userController.bankDetails(userList[index].key, index);
                        setState(() {
                          isClick = true;
                        });
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CommonText(
                                        text: "User Name:",
                                        textColor: mainColor),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .6,
                                      child: Text(
                                        userList[index].advisorName,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CommonText(
                                        text: "Mobile or Date:",
                                        textColor: mainColor),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CommonText(
                                        text:
                                            userList[index].advisorPhoneNumber,
                                        textColor: Colors.black,
                                        fontSize: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
          );
  }
  Widget categoryList(BuildContext context){
    return SizedBox(
      height: MediaQuery.of(context).size.height/2,
      child: Scaffold(
        backgroundColor: appBackGroundColor,
        body: Obx((){
          if(_partnerController.getProductCategoryList.isNotEmpty){
            return Container(

                padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(text: "Category List",fontSize: 20,fontStyle: FontWeight.bold),
                    Expanded(child: ListView.builder(
                        shrinkWrap: true,
                        itemCount:_partnerController.getProductCategoryList.length ,
                        itemBuilder: (context,index){
                          return InkWell(
                            onTap: (){
                              cName.text = _partnerController.getProductCategoryList[index].categoryName;
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15.0),
                                        child: CachedNetworkImage(
                                            height: 100,
                                            width: 120,
                                            fit: BoxFit.cover,
                                            imageUrl: _partnerController
                                                .getProductCategoryList[index].categoryUrl),
                                      ),
                                      SizedBox(width: 10,),
                                      CommonText(
                                          text:
                                          _partnerController.getProductCategoryList[index].categoryName,
                                          fontSize:  15,
                                          textColor: Colors.white),
                                    ],
                                  ),
                                  Switch(
                                      activeColor: Constants().mainColor
                                      ,value: _partnerController.getProductCategoryList[index].isEnabled,
                                      onChanged: (_) {
                                        CategoryModel _categoryModel = CategoryModel(
                                            isEnabled: !_partnerController.getProductCategoryList[index].isEnabled,
                                            categoryName: _partnerController.getProductCategoryList[index].categoryName,
                                            categoryUrl: _partnerController.getProductCategoryList[index].categoryUrl,
                                            key: _partnerController.getProductCategoryList[index].key
                                        );
                                        _partnerController.updateCategoryStatus(_categoryModel);
                                      })
                                ],
                              ),
                            ),
                          );
                        })),
                  ],
                ));
          }else{
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                new AlwaysStoppedAnimation<Color>(Constants().mainColor),
              ),
            );
          }

        }),

      ),
    );
  }


  Widget updatePartner(BuildContext context,int index){
  
    return Container(
      color: appBackGroundColor,
      height: MediaQuery.of(context).size.height-100,
      padding: EdgeInsets.only(left: 20,right: 20,top: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(text: "Add Product to Partner",fontSize: 20,fontStyle: FontWeight.bold),

              ],
            ),
            SizedBox(height: 25,),
            CommonText(text: "Partner Name"),
            SizedBox(height: 10,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"Partner name",inputController:pName,textInputAction: TextInputAction.next,hint: "Enter Product Name" ),
            SizedBox(height: 15,),
            CommonText(text: "Partner Price"),
            SizedBox(height: 10,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"partner price",inputController:pPrice,textInputAction: TextInputAction.next,hint: "Enter Product Name"),
            SizedBox(height: 15,),
            CommonText(text: "Product Type"),
            SizedBox(height: 10,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"Product Type",inputController:categoryName,textInputAction: TextInputAction.next,hint:"Enter Product Type"),
            SizedBox(height: 15,),
            Center(child: CommonButton(onPressed: (){
              VSPPriceModel _vSPPriceModel = VSPPriceModel(
                isEnabled: true,
                name: pName.text,
                price: int.parse(pPrice.text),
                type: categoryName.text,
                partnerPhone: _vSPController.getNewPartner.advisorPhoneNumber
              );
              _vSPController.addPartnerProductPrice ( _vSPPriceModel);
            },buttonText: "Add Product",vPadding: 20,buttonColor: Constants().mainColor))
          ],
        ),
      ),);
  }
  Widget listPartnerProduct(BuildContext context,int index){

    return Container(
      color: appBackGroundColor,
      height: MediaQuery.of(context).size.height-100,
      padding: EdgeInsets.only(left: 20,right: 20,top: 20),
      child:Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          separatorBuilder: (BuildContext context,sIndex){
            return Divider(color: Colors.white,);
          },
            shrinkWrap: true,
            itemCount: _vSPController.getPartnerPriceList.length,
            itemBuilder: (context, index) {
              return Container(
                  color: appBackGroundColor,
                  padding: const EdgeInsets.all(10),
                child: Row(
                  children: [

                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonText(
                            text:
                            _vSPController.getPartnerPriceList[index].name,
                            fontSize:  15,
                            textColor: Colors.white),
                        SizedBox(height: 5,),
                        CommonText(
                            text:
                            _vSPController.getPartnerPriceList[index].price.toString(),
                            textColor: Colors.white),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ) ,);
  }

  Widget createMoreProductDetailing(BuildContext context,String category){
    productCategoryDetailing.clear();
    return Container(
      color: appBackGroundColor,
      padding: EdgeInsets.only(left: 20,right: 20,top: 20),
      height: MediaQuery.of(context).size.height-100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(text: "Add ${category}",fontSize: 20,fontStyle: FontWeight.bold),
          SizedBox(height: 30,),
          CommonTextInput1(minLines: 10,width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"Product Category HTML",inputController:productCategoryDetailing,textInputType: TextInputType.text,textInputAction: TextInputAction.next,hint:"Product $category HTML"),
          SizedBox(height: 15,),
          Center(child: CommonButton(onPressed: (){
            if(category =="about"){
              About about = About(index:_partnerController.getReferList[_partnerController.getUpdateIndex].about==null ? 0:_partnerController.getReferList[_partnerController.getUpdateIndex].about.length,
                  html:productCategoryDetailing.text );
              _partnerController.referList.value[_partnerController.getUpdateIndex].about.add(about);
              _partnerController.referList.refresh();
              Navigator.pop(context);
            }else if(category == "know-more"){
              print("===============know==================");
              KnowMore knowMore = KnowMore(index:_partnerController.getReferList[_partnerController.getUpdateIndex].about==null ? 0:_partnerController.getReferList[_partnerController.getUpdateIndex].about.length,
                  html:productCategoryDetailing.text );
              print(knowMore.toJson());
              print(_partnerController.referList.value[_partnerController.getUpdateIndex].toJson());
              _partnerController.referList.value[_partnerController.getUpdateIndex].knowMore.add(knowMore);
              _partnerController.referList.refresh();
              Navigator.pop(context);
            }else {
              HowToEarn howToEarn = HowToEarn(index:_partnerController.getReferList[_partnerController.getUpdateIndex].about==null ? 0:_partnerController.getReferList[_partnerController.getUpdateIndex].about.length,
                  html:productCategoryDetailing.text );
              _partnerController.referList.value[_partnerController.getUpdateIndex].howToEarn.add(howToEarn);
              _partnerController.referList.refresh();
              Navigator.pop(context);
            }

          },buttonText: "Submit",vPadding: 20,buttonColor: Constants().mainColor))],),
    );
  }
  Widget createProductDetailing(BuildContext context,String category){
    productCategoryDetailing.clear();
    return Container(
      color: appBackGroundColor,
      padding: EdgeInsets.only(left: 20,right: 20,top: 20),
      height: MediaQuery.of(context).size.height-100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(text: "Add ${category}",fontSize: 20,fontStyle: FontWeight.bold),
          SizedBox(height: 30,),
          CommonTextInput1(
              minLines: 10,
              width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"Product Category HTML",inputController:productCategoryDetailing,textInputType: TextInputType.text,textInputAction: TextInputAction.next,hint:"Product $category HTML"),
          SizedBox(height: 15,),
          Center(child: CommonButton(onPressed: (){
            if(category =="about"){
              About about = About(index:_partnerController.getReferList[_partnerController.getUpdateIndex].about==null ? 0:_partnerController.getReferList[_partnerController.getUpdateIndex].about.length,
                  html:productCategoryDetailing.text );
              _partnerController.referList.value[_partnerController.getUpdateIndex].about.add(about);
              _partnerController.referList.refresh();
              Navigator.pop(context);
            }else if(category == "know-more"){
              print("===============know==================");
              KnowMore knowMore = KnowMore(index:_partnerController.getReferList[_partnerController.getUpdateIndex].about==null ? 0:_partnerController.getReferList[_partnerController.getUpdateIndex].about.length,
                  html:productCategoryDetailing.text );
              print(knowMore.toJson());
              print(_partnerController.referList.value[_partnerController.getUpdateIndex].toJson());
              _partnerController.referList.value[_partnerController.getUpdateIndex].knowMore = <KnowMore>[knowMore];
              _partnerController.referList.refresh();
              Navigator.pop(context);
            }else {
              HowToEarn howToEarn = HowToEarn(index:_partnerController.getReferList[_partnerController.getUpdateIndex].about==null ? 0:_partnerController.getReferList[_partnerController.getUpdateIndex].about.length,
                  html:productCategoryDetailing.text );
              _partnerController.referList.value[_partnerController.getUpdateIndex].howToEarn.add(howToEarn);
              _partnerController.referList.refresh();
              Navigator.pop(context);
            }

          },buttonText: "Submit",vPadding: 20,buttonColor: Constants().mainColor))],),
    );
  }
  Widget user() {
    return Scaffold(
        backgroundColor: appBackGroundColor,
        body: Padding(
          padding:
              const EdgeInsets.only(bottom: 40, right: 40, top: 60, left: 40),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    usersearch(_userController.getUsersList),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) =>  AlertDialog(
                              title: const Text('Add partner'),
                              content:  SizedBox(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                child: Row(children: [
                                  SizedBox(
                                    width: 200,
                                    child: Column(children: [
                                      searchNewUser(),
                                      SizedBox(height: 10,),
                                      Obx(()=>_vSPController.getNewPartner.advisorPhoneNumber==null ?SizedBox():InkWell(
                                        onTap: (){
                                          print(_vSPController.getNewPartner.isOwner);
                                          if(_vSPController.getNewPartner.isOwner==true){
                                            commonSnackBar("Alert", "This partner is already added");
                                          }else{
                                            _vSPController.setIsClicked(true);
                                          }
                                        },
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:  SizedBox(
                                              width: MediaQuery.of(context).size.width / 8,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  CommonText(
                                                      text: "User Name:",
                                                      textColor: mainColor),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    width: MediaQuery.of(context).size.width *
                                                        .6,
                                                    child: Text(
                                                      _vSPController.getNewPartner.advisorName,
                                                      style: const TextStyle(fontSize: 15),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  CommonText(
                                                      text: "Mobile or Date:",
                                                      textColor: mainColor),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  CommonText(
                                                      text:
                                                      _vSPController.getNewPartner.advisorPhoneNumber,
                                                      textColor: Colors.black,
                                                      fontSize: 20),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                    ],),
                                  ),
                                   Obx(()=> Expanded(child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            if(_vSPController.newPartner.value.isOwner==true)   productList(),
                                          if(_vSPController.newPartner.value.isOwner==true)  Obx(()=>Flexible(child: _partnerController.getIsUpdate==true ? _partnerController.getReferList.length==0?Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                new AlwaysStoppedAnimation<Color>(mainColor),
                                              ),
                                            ) :updatePartner(context, _partnerController.getUpdateIndex): SizedBox())),
                                           if(_vSPController.newPartner.value.isOwner==true) Obx(()=>Flexible(child:
                                            _partnerController.getIsUpdate==true ? _partnerController.getReferList.length==0?
                                            Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                new AlwaysStoppedAnimation<Color>(mainColor),
                                              ),
                                            ) :listPartnerProduct(context, _partnerController.getUpdateIndex): SizedBox())),

                                          ],
                                        ),
                                      ),
                                      _vSPController.getIsClicked?InkWell(
                                        onTap: (){
                                          _vSPController.markAsPartner();
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width/5,
                                          height: 60,
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Constants().mainColor,
                                          ),
                                          child:  Center(
                                            child: Text(
                                              "Add Partner",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ):SizedBox(),
                                    ],
                                  ),))
                                ],),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .pop(); // dismisses only the dialog and returns nothing
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Constants().mainColor,
                          ),
                          child: const Text(
                            "Add Partner",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                      child:
                          Obx(() => _userlogList(_vSPController.getUsersList))),
                ),
              ],
            ),
            // child: ,
          ),
        ));
  }

  Widget productList(){
    return  Flexible(
      child: Obx(() => _partnerController.getReferList.isEmpty
          ? Center(
        child: CircularProgressIndicator(
          valueColor:
          new AlwaysStoppedAnimation<Color>(mainColor),
        ),
      )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: _partnerController.getReferList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    pName.text = _partnerController.getReferList[index].name;
                    pUrl.text = _partnerController.getReferList[index].banner;
                    pPrice.text =_partnerController.getReferList[index].price.toString();
                    categoryName.text = _partnerController.getReferList[index].type.toString();
                    _partnerController.setUpdateIndex=index;
                    _partnerController.setIsUpdate=true;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: appBackGroundColor
                    ),
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: CachedNetworkImage(
                                  height: 100,
                                  width: 120,
                                  fit: BoxFit.fill,
                                  imageUrl: _partnerController
                                      .getReferList[index].banner),
                            ),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CommonText(
                                    text:
                                    _partnerController.getReferList[index].name,
                                    fontSize:  15,
                                    textColor: Colors.white),
                                SizedBox(height: 5,),
                                CommonText(
                                    text:
                                    _partnerController.getReferList[index].price.toString(),
                                    textColor: Colors.white),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              })),
    );
  }
  Widget userDetails(UserDetailModel userDetailModel) {
    print("===================userDetailModel.advisorUrl=================");
    print(userDetailModel.advisorUrl);
    print(jsonEncode(userDetailModel.bankDetails));
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        //  decoration: BoxDecoration(border: Border.all(color: inactiveColor), borderRadius: BorderRadius.circular(1)),
        child: Row(
          children: [
            !showBankDetails
                ? Column(children: [
                    Container(
                      //  width: !isExpand ? MediaQuery.of(context).size.width / 5 : MediaQuery.of(context).size.width / 8,

                      width: 300,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: inactiveColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonText(
                              text: "User Name:", textColor: inactiveColor),
                          SizedBox(
                            width: 15,
                          ),
                          CommonText(
                              text: userDetailModel.advisorName == null
                                  ? "Empty Data"
                                  : userDetailModel.advisorName,
                              textColor: mainColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      //  width: !isExpand ? MediaQuery.of(context).size.width / 5 : MediaQuery.of(context).size.width / 8,

                      width: 300,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: inactiveColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonText(
                              text: "User Email: ", textColor: inactiveColor),
                          //SizedBox(width: 15,),
                          CommonText(
                              text: userDetailModel.advisorEmail == null
                                  ? "Empty Data"
                                  : userDetailModel.advisorEmail,
                              textColor: mainColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      //  width: !isExpand ? MediaQuery.of(context).size.width / 5 : MediaQuery.of(context).size.width / 8,

                      width: 300,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: inactiveColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonText(
                              text: "User Mobile No:",
                              textColor: inactiveColor),
                          SizedBox(
                            width: 15,
                          ),
                          CommonText(
                              text: userDetailModel.advisorPhoneNumber == null
                                  ? "Empty Data"
                                  : userDetailModel.advisorPhoneNumber,
                              textColor: mainColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      //  width: !isExpand ? MediaQuery.of(context).size.width / 5 : MediaQuery.of(context).size.width / 8,

                      width: 300,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: inactiveColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonText(
                              text: "User Dob:", textColor: inactiveColor),
                          SizedBox(
                            width: 15,
                          ),
                          CommonText(
                              text: userDetailModel.advisorDob == null
                                  ? "Empty Data"
                                  : userDetailModel.advisorDob,
                              textColor: mainColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      //  width: !isExpand ? MediaQuery.of(context).size.width / 5 : MediaQuery.of(context).size.width / 8,

                      width: 300,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: inactiveColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonText(
                              text: "User State:", textColor: inactiveColor),
                          SizedBox(
                            width: 15,
                          ),
                          CommonText(
                              text: userDetailModel.advisorState == null
                                  ? "Empty Data"
                                  : userDetailModel.advisorState,
                              textColor: mainColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      //  width: !isExpand ? MediaQuery.of(context).size.width / 5 : MediaQuery.of(context).size.width / 8,

                      width: 300,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: inactiveColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonText(
                              text: "User City:", textColor: inactiveColor),
                          SizedBox(
                            width: 15,
                          ),
                          CommonText(
                              text: userDetailModel.advisorCity == null
                                  ? "Empty Data"
                                  : userDetailModel.advisorCity,
                              textColor: mainColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      //  width: !isExpand ? MediaQuery.of(context).size.width / 5 : MediaQuery.of(context).size.width / 8,

                      width: 300,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: inactiveColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonText(
                              text: "Refered By:", textColor: inactiveColor),
                          SizedBox(
                            width: 15,
                          ),
                          CommonText(
                              text: userDetailModel.referedBy == null
                                  ? "Empty Data"
                                  : userDetailModel.referedBy,
                              textColor: mainColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      //  width: !isExpand ? MediaQuery.of(context).size.width / 5 : MediaQuery.of(context).size.width / 8,

                      width: 300,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: inactiveColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Row(
                        //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CommonText(
                              text: "User Wallet:", textColor: inactiveColor),
                          SizedBox(
                            width: 15,
                          ),
                          CommonText(
                              text: userDetailModel.total_wallet == null
                                  ? "Empty Data"
                                  : userDetailModel.total_wallet,
                              textColor: mainColor),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        setState(() {
                          showBankDetails = true;
                        });
                      },
                      child: Container(
                        height: 60,
                        width: !isExpand
                            ? MediaQuery.of(context).size.width / 6
                            : MediaQuery.of(context).size.width / 8,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: mainColor,
                            border: Border.all(color: inactiveColor),
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: CommonText(
                            text: "Account Details",
                          ),
                        ),
                      ),
                    ),
                  ])
                : SizedBox(),
            SizedBox(
              width: 20,
            ),
            showBankDetails
                ? Expanded(
                    child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 0.0, right: 0.0, bottom: 15.0),
                    child: Column(
                      children: [
                        CommonText(
                          text: "User Bank Details:",
                          textColor: inactiveColor,
                          fontSize: 30.00,
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 300,
                          height: 60,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: inactiveColor),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CommonText(
                                  text: "User Bank Account:",
                                  textColor: inactiveColor),
                              SizedBox(
                                width: 15,
                              ),
                              CommonText(
                                  text: userDetailModel
                                              .bankDetails.accHolderNumber ==
                                          null
                                      ? "Empty Data"
                                      : userDetailModel
                                          .bankDetails.accHolderNumber
                                          .toString(),
                                  textColor: mainColor),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          //  width: !isExpand ? MediaQuery.of(context).size.width / 5 : MediaQuery.of(context).size.width / 8,

                          width: 300,
                          height: 60,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: inactiveColor),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CommonText(
                                  text: "User IFSC Code:",
                                  textColor: inactiveColor),
                              SizedBox(
                                width: 15,
                              ),
                              CommonText(
                                  text: userDetailModel
                                              .bankDetails.accHolderIfsc ==
                                          null
                                      ? "Empty Data"
                                      : userDetailModel
                                          .bankDetails.accHolderIfsc,
                                  textColor: mainColor),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 300,
                          height: 60,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: inactiveColor),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CommonText(
                                  text: "Account Holder Name:",
                                  textColor: inactiveColor),
                              SizedBox(
                                width: 15,
                              ),
                              CommonText(
                                  text: userDetailModel
                                              .bankDetails.accHolderName ==
                                          null
                                      ? "Empty Data"
                                      : userDetailModel
                                          .bankDetails.accHolderName,
                                  textColor: mainColor),
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 60,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: inactiveColor),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CommonText(
                                  text: "Account Type:",
                                  textColor: inactiveColor),
                              SizedBox(
                                width: 15,
                              ),
                              CommonText(
                                  text: userDetailModel
                                              .bankDetails.accHolderDocType ==
                                          null
                                      ? "Empty Data"
                                      : userDetailModel
                                          .bankDetails.accHolderDocType,
                                  textColor: mainColor),
                            ],
                          ),
                        ),
                        Container(
                          width: 300,
                          height: 60,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(color: inactiveColor),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CommonText(
                                  text: "Account Bank Name:",
                                  textColor: inactiveColor),
                              SizedBox(
                                width: 15,
                              ),
                              CommonText(
                                  text: userDetailModel.bankDetails.bankName ==
                                          null
                                      ? "Empty Data"
                                      : userDetailModel.bankDetails.bankName,
                                  textColor: mainColor),
                            ],
                          ),
                        ),
                        Container(
                            width: 300,
                            height: 200,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: inactiveColor),
                                borderRadius: BorderRadius.circular(5)),
                            child:
                                userDetailModel.bankDetails.accHolderDocUrl ==
                                        null
                                    ? SizedBox()
                                    : Image.network(userDetailModel
                                        .bankDetails.accHolderDocUrl)),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showBankDetails = false;
                            });
                          },
                          child: Container(
                            height: 60,
                            width: !isExpand
                                ? MediaQuery.of(context).size.width / 6
                                : MediaQuery.of(context).size.width / 8,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: mainColor,
                                border: Border.all(color: inactiveColor),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: CommonText(
                                text: "Back to Details",
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                      ],
                    ),
                  ))
                : Center(
                    child: Card(
                      child: SizedBox(
                        width: 400,
                        // decoration: BoxDecoration(border: Border.all(color: inactiveColor), borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              userDetailModel.advisorUrl == null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Container(
                                          width: 90,
                                          height: 90,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blue,
                                          ),
                                          child: Icon(
                                            Icons.account_circle,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue,
                                            ),
                                            child: Image.network(
                                                userDetailModel.advisorUrl)),
                                      ),
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    CommonText(
                                        text: userDetailModel.advisorName,
                                        textColor: Colors.black,
                                        fontSize: 25),
                                    CommonText(
                                        text: "Adviser",
                                        textColor: Colors.black),
                                    CommonText(
                                        text: userDetailModel.advisorName,
                                        textColor: Colors.black),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      height: 60,
                                      width: !isExpand
                                          ? MediaQuery.of(context).size.width /
                                              6
                                          : MediaQuery.of(context).size.width /
                                              8,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          border:
                                              Border.all(color: inactiveColor),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: CommonText(
                                          text: "Account Details",
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
  clearText(){
    pName.clear();
    pUrl.clear();
    rUrl.clear();
    pPrice.clear();
    yUrl.clear();
  }
  @override
  void initState() {
    // TODO: implement initState
    _vSPController.myNewUsers();
    _vSPController.partnerProductPriceList();
    _partnerController.referralPartners(true,"");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user(),
    );
  }
}
