import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../helper/constant.dart';
import 'controller/partner_controller.dart';
import 'model/category_model.dart';
import 'model/referModel.dart';

class PartnerView extends StatelessWidget {
  PartnerController _PartnerController = Get.put(PartnerController());

  TextEditingController pName = TextEditingController();
  TextEditingController pUrl = TextEditingController();
  TextEditingController rUrl = TextEditingController();
  TextEditingController pPrice = TextEditingController();
  TextEditingController yUrl = TextEditingController();
  TextEditingController cName = TextEditingController();
  TextEditingController categoryName = TextEditingController();
  TextEditingController productCategoryDetailing = TextEditingController();
  TextEditingController categoryLogo = TextEditingController();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  clearText(){
    pName.clear();
    pUrl.clear();
    rUrl.clear();
    pPrice.clear();
    yUrl.clear();
  }

  Widget categoryList(BuildContext context){
    return SizedBox(
      height: MediaQuery.of(context).size.height/2,
      child: Scaffold(
        backgroundColor: appBackGroundColor,
        body: Obx((){
          if(_PartnerController.getProductCategoryList.isNotEmpty){
            return Container(

                padding: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText(text: "Category List",fontSize: 20,fontStyle: FontWeight.bold),
                    Expanded(child: ListView.builder(
                        shrinkWrap: true,
                        itemCount:_PartnerController.getProductCategoryList.length ,
                        itemBuilder: (context,index){
                          return InkWell(
                            onTap: (){
                              cName.text = _PartnerController.getProductCategoryList[index].categoryName;
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
                                            imageUrl: _PartnerController
                                                .getProductCategoryList[index].categoryUrl),
                                      ),
                                      SizedBox(width: 10,),
                                      CommonText(
                                          text:
                                          _PartnerController.getProductCategoryList[index].categoryName,
                                          fontSize:  15,
                                          textColor: Colors.white),
                                    ],
                                  ),
                                  Switch(
                                      activeColor: Constants().mainColor
                                      ,value: _PartnerController.getProductCategoryList[index].isEnabled,
                                      onChanged: (_) {
                                        CategoryModel _categoryModel = CategoryModel(
                                            isEnabled: !_PartnerController.getProductCategoryList[index].isEnabled,
                                            categoryName: _PartnerController.getProductCategoryList[index].categoryName,
                                            categoryUrl: _PartnerController.getProductCategoryList[index].categoryUrl,
                                            key: _PartnerController.getProductCategoryList[index].key
                                        );
                                        _PartnerController.updateCategoryStatus(_categoryModel);
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
        floatingActionButton:FloatingActionButton(
          backgroundColor: Constants().mainColor,
          child: Icon(Icons.add),
          onPressed: (){
            showModalBottomSheet(
                backgroundColor: Constants().appBackGroundColor,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                ),
                context: context,
                builder: (builder){
                  return createCategory(context);
                }
            );
          },
        ) ,
      ),
    );
  }


  Widget createCategory(BuildContext context){

    return Container(
      color: appBackGroundColor,
      padding: EdgeInsets.only(left: 20,right: 20,top: 20),
      height: MediaQuery.of(context).size.height-100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(text: "Add Category",fontSize: 20,fontStyle: FontWeight.bold),
          SizedBox(height: 30,),
          CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"Category Name",inputController:categoryName,textInputType: TextInputType.text,textInputAction: TextInputAction.next,hint:"Enter Category Name"),
          SizedBox(height: 15,),
          CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"Category Logo",inputController:categoryLogo,textInputType: TextInputType.text,textInputAction: TextInputAction.done,hint: "Enter Category Logo"),
          SizedBox(height: 15,),
          Center(child: CommonButton(onPressed: (){
            CategoryModel _categoryModel = CategoryModel(
                isEnabled: false,
                categoryName: categoryName.text,
                categoryUrl: categoryLogo.text
            );
            _PartnerController. createCategory(_categoryModel);
          },buttonText: "Submit",vPadding: 20,buttonColor: Constants().mainColor))],),
    );
  }

  Widget addPartner(BuildContext context){


    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(left: 20,right: 20,top: 20),
      child: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonText(text: "Add Partner",fontSize: 20,fontStyle: FontWeight.bold),
            SizedBox(height: 25,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"Partner name",inputController:pName,textInputAction: TextInputAction.next,hint: "Enter Partner Name" ),
            SizedBox(height: 15,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"partner logo url",inputController:pUrl,textInputAction: TextInputAction.next,hint: "Enter Partner Logo"),
            SizedBox(height: 15,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"partner referral url",inputController:rUrl,textInputAction: TextInputAction.next,hint:"Enter Partner Referral Url"),
            SizedBox(height: 15,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"partner price",inputController:pPrice,textInputType: TextInputType.number,textInputAction: TextInputAction.next,hint:"Enter Price"),
            SizedBox(height: 15,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"youtube URL",inputController:yUrl,textInputType: TextInputType.number,textInputAction: TextInputAction.next,hint: "Enter Youtube Url"),
            SizedBox(height: 15,),
            InkWell(onTap: (){

              _PartnerController.productCategory();
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                  ),
                  backgroundColor: Constants().appBackGroundColor,
                  context: context,
                  isScrollControlled: true,
                  builder: (builder){
                    return categoryList(context);
                  }
              );
            },child:
            AbsorbPointer(
              child: CommonTextInput1(

                  width: MediaQuery.of(context).size.width,
                  isReadOnly:true,lableTextColor: Colors.white,lable:"Category",inputController:cName,textInputType: TextInputType.number,textInputAction: TextInputAction.done,hint: "Select Product Category"),
            )),
            SizedBox(height: 15,),
            Center(child: CommonButton(onPressed: (){
              ReferModel _refer = ReferModel(
                  banner: pUrl.text,
                  isEnabled: false,
                  name: pName.text,
                  price: int.parse(pPrice.text),
                  type: cName.text,
                  url: rUrl.text,
                  youtube: yUrl.text
              );
              _PartnerController.addPartner(_refer);
            },buttonText: "Submit",vPadding: 20,buttonColor: Constants().mainColor)),
            SizedBox(height: 20,)
          ],
        ),
      ),);
  }

  Widget updatePartner(BuildContext context,int index){
    print("================_PartnerController.getReferList[_PartnerController.getUpdateIndex].knowMore=");
    print(jsonEncode(_PartnerController.getReferList[_PartnerController.getUpdateIndex].about));
    return Container(
      height: MediaQuery.of(context).size.height-100,
      padding: EdgeInsets.only(left: 20,right: 20,top: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText(text: "Update Partner",fontSize: 20,fontStyle: FontWeight.bold),
                IconButton(icon: Icon(Icons.delete,color: Colors.white,) ,onPressed: (){
                  _PartnerController.deletePartner(_PartnerController.getReferList[index]);
                },)
              ],
            ),
            SizedBox(height: 25,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"Partner name",inputController:pName,textInputAction: TextInputAction.next,hint: "Enter Partner Name" ),
            SizedBox(height: 15,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"partner logo url",inputController:pUrl,textInputAction: TextInputAction.next,hint: "Enter Partner Logo"),
            SizedBox(height: 15,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"partner referral url",inputController:rUrl,textInputAction: TextInputAction.next,hint:"Enter Partner Referral Url"),
            SizedBox(height: 15,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"partner price",inputController:pPrice,textInputType: TextInputType.number,textInputAction: TextInputAction.done,hint:"Enter Price"),
            SizedBox(height: 15,),
            CommonTextInput1(width: MediaQuery.of(context).size.width,lableTextColor: Colors.white,lable:"youtube URL",inputController:yUrl,textInputType: TextInputType.number,textInputAction: TextInputAction.done,hint: "Enter Youtube Url"),
            SizedBox(height: 15,),
            Obx(()=>_PartnerController.getReferList[_PartnerController.getUpdateIndex].knowMore==null ?
            Center(child: CommonButton(

                onPressed: (){
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                      ),
                      backgroundColor: Constants().appBackGroundColor,
                      context: context,
                      isScrollControlled: true,
                      builder: (builder){
                        return    createProductDetailing(context,"know-more");
                      }
                  );


            },buttonText: "Add Know More Html",buttonColor: Constants().mainColor)):ListView.builder(
              shrinkWrap: true,
                itemCount:_PartnerController.getReferList[_PartnerController.getUpdateIndex].knowMore.length ,
                itemBuilder: (context,index){
                  return Row(
                    children: [
                      Expanded(
                        child: CommonTextInput1(width: MediaQuery.of(context).size.width,
                            lableTextColor: Colors.white,lable:"youtube URL",
                            inputController:TextEditingController(text: _PartnerController.getReferList[_PartnerController.getUpdateIndex].knowMore[index].html),textInputType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            hint: "Enter Youtube Url"),
                      ),
                      SizedBox(width: 10,),
                      index ==_PartnerController.getReferList[_PartnerController.getUpdateIndex].knowMore.length-1?      SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(onTap: (){
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                              ),
                              backgroundColor: Constants().mainColor,
                              context: context,
                              isScrollControlled: true,
                              builder: (builder){
                                return    createMoreProductDetailing(context,"know-more");
                              }
                          );

                        },child: CircleAvatar(backgroundColor:Constants().mainColor ,child: Icon(Icons.add),)),
                      ):SizedBox(

                      )
                    ],
                  );
                }),),
            SizedBox(height: 15,),
            Obx(()=>_PartnerController.getReferList[_PartnerController.getUpdateIndex].howToEarn==null ?
            Center(child: CommonButton(onPressed: (){
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                  ),
                  backgroundColor: Constants().appBackGroundColor,
                  context: context,
                  isScrollControlled: true,
                  builder: (builder){
                    return  createProductDetailing(context,"how-to-earn");
                  }
              );

            },buttonText: "Add How to Earn Html",vPadding: 20,buttonColor: Constants().mainColor)):ListView.builder(
              shrinkWrap: true,
                itemCount:_PartnerController.getReferList[_PartnerController.getUpdateIndex].howToEarn.length ,
                itemBuilder: (context,index){
                  return Row(
                    children: [
                      Expanded(
                        child: CommonTextInput1(width: MediaQuery.of(context).size.width,
                            lableTextColor: Colors.white,lable:"youtube URL",
                            inputController:TextEditingController(text: _PartnerController.getReferList[_PartnerController.getUpdateIndex].howToEarn[index].html),textInputType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            hint: "Enter Youtube Url"),
                      ),
                      SizedBox(width: 10,),
                      index ==_PartnerController.getReferList[_PartnerController.getUpdateIndex].howToEarn.length-1?
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(onTap: (){
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                              ),
                              backgroundColor: Constants().mainColor,
                              context: context,
                              isScrollControlled: true,
                              builder: (builder){
                                return    createMoreProductDetailing(context,"how-to-earn");
                              }
                          );

                        },child: CircleAvatar(backgroundColor:Constants().mainColor ,child: Icon(Icons.add),)),
                      ):SizedBox(

                      )
                    ],
                  );
                }),),
            SizedBox(height: 15,),
            Obx(()=>_PartnerController.getReferList[_PartnerController.getUpdateIndex].about==null ?
            Center(child: CommonButton(onPressed: (){
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                  ),
                  backgroundColor: Constants().appBackGroundColor,
                  context: context,
                  isScrollControlled: true,
                  builder: (builder){
                    return  createProductDetailing(context,"about");
                  }
              );

            },buttonText: "Add About Html",vPadding: 20,buttonColor: Constants().mainColor)):ListView.builder(
              shrinkWrap: true,
                itemCount:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about.length ,
                itemBuilder: (context,index){

                  return Row(
                    children: [
                      Expanded(
                        child: CommonTextInput1(width: MediaQuery.of(context).size.width,
                            lableTextColor: Colors.white,lable:"youtube URL",
                            inputController:TextEditingController(text: _PartnerController.getReferList[_PartnerController.getUpdateIndex].about[index].html),textInputType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            hint: "Enter Youtube Url"),
                      ),
                      SizedBox(width: 10,),
                      index ==_PartnerController.getReferList[_PartnerController.getUpdateIndex].about.length-1?      SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(onTap: (){
                          showModalBottomSheet(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                              ),
                              backgroundColor: Constants().mainColor,
                              context: context,
                              isScrollControlled: true,
                              builder: (builder){
                                return    createMoreProductDetailing(context,"about");
                              }
                          );

                        },child: CircleAvatar(backgroundColor:Constants().mainColor ,child: Icon(Icons.add),)),
                      ):SizedBox(

                      )
                    ],
                  );
                }),),
            SizedBox(height: 15,),
            Center(child: CommonButton(onPressed: (){
              ReferModel _refer = ReferModel(
                  key: _PartnerController.getReferList[index].key,
                  banner: pUrl.text,
                  isEnabled: false,
                  name: pName.text,
                  price: int.parse(pPrice.text),
                  type: cName.text,
                  url: rUrl.text,
                  youtube: yUrl.text,
                  about: _PartnerController.getReferList[_PartnerController.getUpdateIndex].about,
                howToEarn: _PartnerController.getReferList[_PartnerController.getUpdateIndex].howToEarn,
                knowMore: _PartnerController.getReferList[_PartnerController.getUpdateIndex].knowMore

              );
              _PartnerController.updatePartner(_refer);
            },buttonText: "Update",vPadding: 20,buttonColor: Constants().mainColor))
          ],
        ),
      ),);
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
              About about = About(index:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about==null ? 0:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about.length,
              html:productCategoryDetailing.text );
              _PartnerController.referList.value[_PartnerController.getUpdateIndex].about.add(about);
              _PartnerController.referList.refresh();
              Navigator.pop(context);
            }else if(category == "know-more"){
              print("===============know==================");
              KnowMore knowMore = KnowMore(index:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about==null ? 0:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about.length,
                  html:productCategoryDetailing.text );
              print(knowMore.toJson());
              print(_PartnerController.referList.value[_PartnerController.getUpdateIndex].toJson());
              _PartnerController.referList.value[_PartnerController.getUpdateIndex].knowMore = <KnowMore>[knowMore];
              _PartnerController.referList.refresh();
              Navigator.pop(context);
            }else {
              HowToEarn howToEarn = HowToEarn(index:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about==null ? 0:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about.length,
                  html:productCategoryDetailing.text );
              _PartnerController.referList.value[_PartnerController.getUpdateIndex].howToEarn.add(howToEarn);
              _PartnerController.referList.refresh();
              Navigator.pop(context);
            }

          },buttonText: "Submit",vPadding: 20,buttonColor: Constants().mainColor))],),
    );
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
              About about = About(index:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about==null ? 0:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about.length,
              html:productCategoryDetailing.text );
              _PartnerController.referList.value[_PartnerController.getUpdateIndex].about.add(about);
              _PartnerController.referList.refresh();
              Navigator.pop(context);
            }else if(category == "know-more"){
              print("===============know==================");
              KnowMore knowMore = KnowMore(index:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about==null ? 0:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about.length,
                  html:productCategoryDetailing.text );
              print(knowMore.toJson());
              print(_PartnerController.referList.value[_PartnerController.getUpdateIndex].toJson());
              _PartnerController.referList.value[_PartnerController.getUpdateIndex].knowMore.add(knowMore);
              _PartnerController.referList.refresh();
              Navigator.pop(context);
            }else {
              HowToEarn howToEarn = HowToEarn(index:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about==null ? 0:_PartnerController.getReferList[_PartnerController.getUpdateIndex].about.length,
                  html:productCategoryDetailing.text );
              _PartnerController.referList.value[_PartnerController.getUpdateIndex].howToEarn.add(howToEarn);
              _PartnerController.referList.refresh();
              Navigator.pop(context);
            }

          },buttonText: "Submit",vPadding: 20,buttonColor: Constants().mainColor))],),
    );
  }
  Widget build(BuildContext context) {
    _PartnerController.referralPartners(true,"");
    return Row(children: [
      Flexible(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Partners"),
            centerTitle: true,

          ),
          body: Obx(() => _PartnerController.getReferList.isEmpty
              ? Center(
            child: CircularProgressIndicator(
              valueColor:
              new AlwaysStoppedAnimation<Color>(mainColor),
            ),
          )
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                itemCount: _PartnerController.getReferList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      pName.text = _PartnerController.getReferList[index].name;
                      pUrl.text = _PartnerController.getReferList[index].banner;
                      pPrice.text =_PartnerController.getReferList[index].price.toString();
                      rUrl.text =_PartnerController.getReferList[index].url.toString();
                      yUrl.text =_PartnerController.getReferList[index].youtube.toString();
                      _PartnerController.setUpdateIndex=index;
                      _PartnerController.setIsUpdate=true;
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
                                    imageUrl: _PartnerController
                                        .getReferList[index].banner),
                              ),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                      text:
                                      _PartnerController.getReferList[index].name,
                                      fontSize:  15,
                                      textColor: Colors.white),
                                  SizedBox(height: 5,),
                                  CommonText(
                                      text:
                                      _PartnerController.getReferList[index].price.toString(),
                                      textColor: Colors.white),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              InkWell(onTap: (){

                              },child: CommonText(text: "check status")),
                              Switch(
                                  activeColor: Constants().mainColor
                                  ,value: _PartnerController.getReferList[index].isEnabled,
                                  onChanged: (_) {
                                    ReferModel refer = ReferModel(isEnabled: !_PartnerController.getReferList[index].isEnabled,
                                        banner: _PartnerController.getReferList[index].banner,key: _PartnerController.getReferList[index].key,name: _PartnerController.getReferList[index].name,price: _PartnerController.getReferList[index].price,type: _PartnerController.getReferList[index].type,url: _PartnerController.getReferList[index].url,
                                        youtube: _PartnerController.getReferList[index].youtube

                                    );
                                    _PartnerController.updateStatus(refer);
                                  }),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          )),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              clearText();
              _PartnerController.setIsUpdate=false;
            },
            backgroundColor: Constants().mainColor,
            child: Icon(Icons.add),
          ),
        ),
      ),
      Obx(()=>Flexible(child: _PartnerController.getIsUpdate==true ? _PartnerController.getReferList.length==0?Center(
        child: CircularProgressIndicator(
          valueColor:
          new AlwaysStoppedAnimation<Color>(mainColor),
        ),
      ) :updatePartner(context, _PartnerController.getUpdateIndex): addPartner(context)))
    ],);
  }






}
