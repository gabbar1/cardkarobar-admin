import 'dart:convert';

import 'package:cardkarobar/screens/user_details/personalDetailModel.dart';
import 'package:cardkarobar/screens/user_details/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../../../helper/constant.dart';
import '../dashboard/dashboard_controller.dart';

import '../dashboard/model/contact_model.dart';
import '../dashboard/model/lead_model.dart';

class UserView extends StatefulWidget {
  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  UserController _userController = Get.put(UserController());
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

  Widget categoryBar() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 20, left: 20.0, right: 20.0, bottom: 10.0),
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
            items: <String>[
              '--All Category--',
              'Demat',
              'Credit Card',
              'Insurance'
            ].map((String value) {
              setState(() {
                existingBank = value;
              });
              return DropdownMenuItem<String>(
                onTap: () {
                  print("===============ontap");
                  print(value);
                  if (value == '--All Category--') {
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
  Widget usersearch(List<UserDetailModel> userList) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10.0),
      child: Center(
        child: Container(
          height: 60,
          width: !isExpand
              ? MediaQuery.of(context).size.width / 5
              : MediaQuery.of(context).size.width / 8,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: mainColor)),
          child: Center(
            child: SizedBox(
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

                  try{
                     var phone = int.parse(val);
                    if(val.length==10){
                      _userController.getSearchByUserPhone(phone.toString());
                    }
                  }catch(e){
                    _debouncer.call(() {
                      _userController.getSearchByUserName(val.toString());
                    });
                  }

                },
              ),
            ),
          ),
        ),
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
                onEndOfPage: () => isCategory
                    ? _userController.myNewUserRefreshList()
                    : _userController.getRefreshUserList(),
                child: ListView.builder(
                  // scrollDirection: Axis.horizontal,
                  itemCount: userList.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _userController.setUserDetails = userList[index];
                        _userController.bankDetails(userList[index].key,index);
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

  Widget user() {
    return Scaffold(
        backgroundColor: appBackGroundColor,
        body: Padding(
          padding:
              const EdgeInsets.only(bottom: 40, right: 40, top: 60, left: 40),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 4,
                    child: SizedBox(
                        //height: MediaQuery.of(context).size.height / 1.6,
                        child: Obx(
                            () => _userlogList(_userController.getUsersList)))),
                AnimatedContainer(
                    height: MediaQuery.of(context).size.height,
                    duration: const Duration(milliseconds: 500),
                    //width: isExpand ? MediaQuery.of(context).size.width / 3 : MediaQuery.of(context).size.width / 2,
                    width:MediaQuery.of(context).size.width*0.6,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            usersearch(_userController.getUsersList),
                            SizedBox(
                              width: 10,
                            ),
                            userBar(),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 280),
                          child: Text("User Detail",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        isClick
                            ? Expanded(
                                child: Obx(() => Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20,
                                          left: 0.0,
                                          right: 0.0,
                                          bottom: 15.0),
                                      child: userDetails(
                                          _userController.getUserDetails),
                                    )))
                            : const Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 40, right: 280.0),
                                  child: Center(
                                      child: Text("Click to load User Data")),
                                ),
                              )
                      ],
                    )),
              ],
            ),
            // child: ,
          ),
        ));
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
            !showBankDetails? Column(children: [
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
                    CommonText(text: "User Name:", textColor: inactiveColor),
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
                    CommonText(text: "User Email: ", textColor: inactiveColor),
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
                        text: "User Mobile No:", textColor: inactiveColor),
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
                    CommonText(text: "User Dob:", textColor: inactiveColor),
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
                    CommonText(text: "User State:", textColor: inactiveColor),
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
                    CommonText(text: "User City:", textColor: inactiveColor),
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
                    CommonText(text: "Refered By:", textColor: inactiveColor),
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
                    CommonText(text: "User Wallet:", textColor: inactiveColor),
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
                onTap: (){
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
            ]):SizedBox(),
            SizedBox(
              width: 20,
            ),
            showBankDetails
                ? Expanded(
                child:  Padding(
                  padding: const EdgeInsets.only(
                      top: 20,
                      left: 0.0,
                      right: 0.0,
                      bottom: 15.0),
                  child: Column(
                    children: [
                      CommonText(
                        text: "User Bank Details:", textColor: inactiveColor, fontSize: 30.00,),

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
                                text: "User Bank Account:", textColor: inactiveColor),
                            SizedBox(
                              width: 15,
                            ),
                            CommonText(
                                text: userDetailModel.bankDetails.accHolderNumber == null
                                    ? "Empty Data"
                                    : userDetailModel.bankDetails.accHolderNumber.toString(),
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
                                text: "User IFSC Code:", textColor: inactiveColor),
                            SizedBox(
                              width: 15,
                            ),
                            CommonText(
                                text: userDetailModel.bankDetails.accHolderIfsc == null
                                    ? "Empty Data"
                                    : userDetailModel.bankDetails.accHolderIfsc,
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
                                text: "Account Holder Name:", textColor: inactiveColor),
                            SizedBox(
                              width: 15,
                            ),
                            CommonText(
                                text: userDetailModel.bankDetails.accHolderName == null
                                    ? "Empty Data"
                                    : userDetailModel.bankDetails.accHolderName,
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
                                text: "Account Type:", textColor: inactiveColor),
                            SizedBox(
                              width: 15,
                            ),
                            CommonText(
                                text: userDetailModel.bankDetails.accHolderDocType == null
                                    ? "Empty Data"
                                    : userDetailModel.bankDetails.accHolderDocType,
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
                                text: "Account Bank Name:", textColor: inactiveColor),
                            SizedBox(
                              width: 15,
                            ),
                            CommonText(
                                text: userDetailModel.bankDetails.bankName == null
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
                        child:  userDetailModel.bankDetails.accHolderDocUrl ==null ?SizedBox():

                            Image.network(userDetailModel.bankDetails.accHolderDocUrl)

                      ),
                      InkWell(
                        onTap: (){
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
                :  Center(
              child:Card(
                child: SizedBox(
                  width: 400,
                  // decoration: BoxDecoration(border: Border.all(color: inactiveColor), borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        userDetailModel.advisorUrl==null? Padding(
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
                        ):Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blue,
                              ),
                              child: Image.network(userDetailModel.advisorUrl)
                            ),
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
                                  text: "Adviser", textColor: Colors.black),
                              CommonText(
                                  text: userDetailModel.advisorName,
                                  textColor: Colors.black),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
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


  @override
  void initState() {
    // TODO: implement initState
    _userController.getUserList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user(),
    );
  }
}
