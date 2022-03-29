import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../helper/constant.dart';
import 'dashboard_controller.dart';
import 'model/contact_model.dart';
import 'model/lead_model.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';


class DashBoardView extends StatefulWidget {
  @override
  _DashBoardViewState createState() => _DashBoardViewState();
}

class _DashBoardViewState extends State<DashBoardView> {
  DashBoardController dashBoardController = Get.put(DashBoardController());
  final ScrollController _scrollController = ScrollController();
  TextEditingController commentController = TextEditingController();

  FocusNode focusSearch = FocusNode();
  String leadStatus = "--All Category--";
  String updateStatus = "--No Status--";
  String existingBank;
  String existingStatus;
  bool isCategory = false;
  bool isExpand = false;
  bool isClick = false;
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
  TextEditingController assignController = TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    dashBoardController.myLeads();
    dashBoardController.getUserList();
    super.initState();
  }

  Widget searchBar() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 20, left: 20.0, right: 10.0, bottom: 15.0),
      child: Container(
        height: 60,
        width: !isExpand
            ? MediaQuery.of(context).size.width / 5
            : MediaQuery.of(context).size.width / 8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: mainColor)),
        child: Center(
          child: TextFormField(
            focusNode: focusSearch,
            controller: dashBoardController.searchTextController,
            onChanged: (val) {
              setState(() {
                if (dashBoardController.searchTextController.text.length ==
                    10) {
                  _debouncer.call(() {
                    dashBoardController.searchByCategory(int.parse(val));
                  });
                }
              });
            },
            onTap: () {},
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w200, fontSize: 14),
            decoration: new InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                size: 25,
                color: Colors.grey,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: "Search your product",
              hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w200,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }

  Widget categoryBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20.0, bottom: 15.0),
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
            'Insurance',
            'Loans',
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
                  dashBoardController.myLeads();
                } else {
                  isCategory = true;
                  dashBoardController.myCategoryLeads(value);
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
    );
  }

  Widget _categoryBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10.0, bottom: 15.0),
      child: Container(
        height: 53,
        width: !isExpand
            ? MediaQuery.of(context).size.width / 5
            : MediaQuery.of(context).size.width / 8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.black87)),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
        child: DropdownButtonFormField<String>(
          value: leadStatus,
          decoration: const InputDecoration(
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          items: <String>[
            '--All Category--',
            'Demat',
            'Credit Card',
            'Insurance',
            'Loans',
          ].map((String value) {
            setState(() {
              existingBank = value;
            });
            return DropdownMenuItem<String>(
              onTap: () {
                print("===============ontap");
                print(value);
                if (value == '--All Category--') {
                  Get.snackbar("Alert", "Please select Category");
                } else {
                  dashBoardController.setAssignType = value;
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
    );
  }



  Widget assign(List<UserContactModel> userList ) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.03,
      right: MediaQuery.of(context).size.width * 0.03, ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: SizedBox(
              width: 200,
              child: Text(
                "Assign Lead",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(

            children: [
              SizedBox(
                width: 65,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5.0, bottom: 10),
                  child: CommonTextInput1(
                      textInputType: TextInputType.number,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      width: 100,
                      inputController:
                          dashBoardController.searchLimitController,
                      labeltext: "Search Limit",
                      hint: "limit",
                      onChanged: (val) {
                        dashBoardController.setAssignLimit = int.parse(val);
                      }),
                ),
              ),
              _categoryBar()
            ],
          ),
          SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 200,
                      child: TextField(
                        controller: assignController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search to Assign',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.only(
                              left: 8.0, bottom: 8.0, top: 8.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: mainColor),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: mainColor),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            userList.where(
                                (element) => element.name.contains(val));
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 10,),
                    SizedBox(
                      height:200,
                      width: 200,
                      child: ListView.builder(
                        // scrollDirection: Axis.horizontal,
                        itemCount: userList.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) {
                          if (assignController.text.isEmpty) {
                            return InkWell(
                              onTap: () {
                                dashBoardController.setAssignUserPhone = userList[index].mobile;
                                dashBoardController.setAssignUserName = userList[index].name;
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(userList[index].name),
                                ),
                              ),
                            );
                          } else if (userList[index]
                              .name
                              .toLowerCase()
                              .contains(assignController.text)) {
                            return InkWell(
                              onTap: () {
                                dashBoardController.setAssignUserPhone = userList[index].mobile;
                                dashBoardController.setAssignUserName = userList[index].name;
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(userList[index].name),
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5,),
                const Divider(
                  thickness: 5,
                ),
                const SizedBox(height: 5,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => CommonText(
                        text:
                        "User Name : ${dashBoardController.getAssignUserName.toString()}",
                        textColor: inactiveColor,
                        fontSize: 15)),
                    Obx(() => CommonText(
                        text:
                        "Number of Lead : ${dashBoardController.getAssignLimit.toString()}",
                        textColor: inactiveColor,
                        fontSize: 15)),
                    Obx(() => CommonText(
                        text:
                        "Lead Type : ${dashBoardController.getAssignType.toString()}",
                        textColor: inactiveColor,
                        fontSize: 15)),
                    Obx(() => CommonText(
                        text:
                        "Total ${dashBoardController.getAssignLeadList.length.toString()} lead can be assigned to ${dashBoardController.getAssignUserName.toString()} ",
                        textColor: inactiveColor,
                        fontSize: 15)),
                    Row(
                      children: [
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: 100,
                            child: Card(
                              color: mainColor,
                              child: Center(
                                  child:
                                  InkWell(
                                      onTap: () {
                                        if(dashBoardController.getAssignType.isEmpty){

                                          commonSnackBar("Alert", "Please select lead type");

                                        }else if (dashBoardController.getAssignLimit.toString().isEmpty){

                                          commonSnackBar("Alert", "Please select lead limit");
                                        }else if (dashBoardController.getAssignUserPhone.toString().isEmpty){

                                          commonSnackBar("Alert", "Please select user to assign");

                                        }else{
                                          dashBoardController.getAssignLead(
                                              type: dashBoardController.getAssignType,
                                              limit: dashBoardController.getAssignLimit,
                                              empPhone: dashBoardController.getAssignUserPhone
                                          );
                                        }

                                      },
                                      child:CommonText(
                                      text: "Search Data",
                                      textColor: Colors.white,
                                      fontSize: 15)),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: 100,
                            child: Card(
                              color: mainColor,
                              child: Center(
                                  child:
                                  InkWell(
                                      onTap: () {

                                         if (dashBoardController.getAssignLimit.toString().isEmpty){

                                          commonSnackBar("Alert", "Please select lead limit");
                                        }else if (dashBoardController.getAssignUserPhone.toString().isEmpty){

                                          commonSnackBar("Alert", "Please select user to assign");

                                        }else if(dashBoardController.getAssignLeadList.isEmpty){
                                        commonSnackBar("Alert", "No Lead to assign");
                                        }else{
                                          dashBoardController.assignLead();
                                        }
                                      },
                                      child:CommonText(
                                      text: "Assign Data",
                                      textColor: Colors.white,
                                      fontSize: 15)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),


                  ],
                ),
              ],
            ),
          ),
        ],
      ));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appBackGroundColor,
      body: Padding(
        padding: const EdgeInsets.only(
            bottom: 40, right: 40, top: 60, left: 40),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width / 4,
                  child: leadList()),
              AnimatedContainer(
                  height: MediaQuery.of(context).size.height,
                  duration: const Duration(milliseconds: 500),
                  width: isExpand
                      ? MediaQuery.of(context).size.width / 3
                      : MediaQuery.of(context).size.width / 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [

                          searchBar(),
                          categoryBar()
                        ],
                      ),
                      isClick ?  Expanded(
                          child: Obx(() => Padding(
                            padding: const EdgeInsets.only(
                                top: 20,
                                left: 20.0,
                                right: 20.0,
                                bottom: 15.0),
                            child: leadDetails(
                                dashBoardController.getLeadDetail),
                          ))):const Center(child: Padding(
                        padding:  EdgeInsets.only(right: 90.0),
                        child: Text("Load Data"),
                      ),)
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 25, top: 25, right: 10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isExpand = !isExpand;
                        });
                      },
                      child: const CircleAvatar(
                        child: Icon(Icons.arrow_back_ios),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: MediaQuery.of(context).size.height,
                    width: !isExpand
                        ? MediaQuery.of(context).size.width * 0.03
                        : MediaQuery.of(context).size.width /4.68,

                    child: assign(dashBoardController.getUsersList),
                  )
                ],
              ),
            ],
          ),
          // child: ,
        ),
      )
    );
  }
//

  //
  Widget leadList() {
    return Obx(() => dashBoardController.getLeadList.isEmpty
        ? Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
            child: LazyLoadScrollView(
              onEndOfPage: () => isCategory
                  ? dashBoardController.myCategoryRefreshLeads(existingBank)
                  : dashBoardController.myRefreshLeads(),
              child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: dashBoardController.getLeadList.length,
                  shrinkWrap: true,
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        dashBoardController.setLeadDetail = dashBoardController.getLeadList[index];
                        print(dashBoardController.getLeadList[index].toJson());
                       setState(() {
                         isClick =true;
                       });
                      },
                      child: Card(
                        color: Colors.white,
                        child: SizedBox(
                          height: 140,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 2, bottom: 20),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CommonText(
                                          text: "Customer Name",
                                          textColor: Colors.black),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .6,
                                        child: Text(
                                          dashBoardController
                                              .getLeadList[index].customerName,
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CommonText(
                                          text: "Product Name",
                                          textColor: Colors.black),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      CommonText(
                                          text: dashBoardController
                                              .getLeadList[index].product,
                                          textColor: Colors.black,
                                          fontSize: 20),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Obx(()=>Checkbox(
                                        value: dashBoardController
                                        .getLeadList[index].isAssigned, onChanged: (val){
                                      dashBoardController.leadList.value[index].isAssigned = val;
                                      dashBoardController.leadList.refresh();
                                      if(!dashBoardController.getLeadList[index].isAssigned){
                                        dashBoardController.assignLeadList.value.removeWhere((element) => element.key ==dashBoardController.getLeadList[index].key );
                                        dashBoardController.assignLeadList.refresh();
                                      }else{
                                        dashBoardController.leadList.value[index].status == "UnderProcess";
                                        dashBoardController.assignLeadList.value.add(dashBoardController.leadList.value[index]);
                                        dashBoardController.assignLeadList.refresh();
                                      }
                                    },
                                      activeColor: mainColor,
                                    )),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5),
                                      child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 5, right: 5, bottom: 5, top: 5),
                                          decoration: BoxDecoration(
                                              color: mainColor.withOpacity(0.7),
                                              borderRadius: const BorderRadius.all(
                                                  const Radius.circular(5))),
                                          child: CommonText(
                                              text: dashBoardController
                                                  .getLeadList[index].status)),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ));
  }

  Widget leadDetails(LeadModel _leadModel) {

    commentController.text = _leadModel.comment == null ? "" : _leadModel.comment;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: !isExpand
                    ? MediaQuery.of(context).size.width / 5
                    : MediaQuery.of(context).size.width / 8,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: inactiveColor),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    CommonText(text: "Customer Name", textColor: inactiveColor),
                    CommonText(
                        text: _leadModel.customerName==null ?"Empty Data":_leadModel.customerName, textColor: mainColor),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                width: !isExpand
                    ? MediaQuery.of(context).size.width / 5
                    : MediaQuery.of(context).size.width / 8,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: inactiveColor),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    CommonText(
                        text: "Customer Phone", textColor: inactiveColor),
                    CommonText(
                        text: _leadModel.customerPhone.toString()==null ?"Empty Data":_leadModel.customerPhone.toString(),
                        textColor: mainColor),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: !isExpand
                    ? MediaQuery.of(context).size.width / 5
                    : MediaQuery.of(context).size.width / 8,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: inactiveColor),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    CommonText(
                        text: "Customer Email", textColor: inactiveColor),
                    CommonText(
                        text: _leadModel.customerEmail==null ?"Empty Data": _leadModel.customerEmail, textColor: mainColor),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                width: !isExpand
                    ? MediaQuery.of(context).size.width / 5
                    : MediaQuery.of(context).size.width / 8,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: inactiveColor),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    CommonText(text: "Product", textColor: inactiveColor),
                    CommonText(
                        text: _leadModel.product.toString()==null ? "Empty Data":_leadModel.product.toString(),
                        textColor: mainColor),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: !isExpand
                    ? MediaQuery.of(context).size.width / 5
                    : MediaQuery.of(context).size.width / 8,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: inactiveColor),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    CommonText(text: "Product Type", textColor: inactiveColor),
                    CommonText(text: _leadModel.type==null ?"Empty Data":_leadModel.type, textColor: mainColor),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                width: !isExpand
                    ? MediaQuery.of(context).size.width / 5
                    : MediaQuery.of(context).size.width / 8,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: inactiveColor),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    CommonText(text: "Product Price", textColor: inactiveColor),
                    CommonText(
                        text: _leadModel.referralPrice.toString()==null ? "Empty Data": _leadModel.referralPrice.toString(),
                        textColor: mainColor),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _leadModel.type != "Demat"
              ? Row(
                  children: [
                    Container(
                      width: !isExpand
                          ? MediaQuery.of(context).size.width / 5
                          : MediaQuery.of(context).size.width / 8,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: inactiveColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          CommonText(
                              text: "Customer City", textColor: inactiveColor),
                          CommonText(
                              text: _leadModel.customerCity==null ? "Empty Data":_leadModel.customerCity,
                              textColor: mainColor),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: !isExpand
                          ? MediaQuery.of(context).size.width / 5
                          : MediaQuery.of(context).size.width / 8,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: inactiveColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          CommonText(
                              text: "Customer State", textColor: inactiveColor),
                          CommonText(
                              text: _leadModel.customerState.toString()==null ? "Empty Data":_leadModel.customerState.toString(),
                              textColor: mainColor),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          _leadModel.type == "Credit Card"
              ? Row(
                  children: [
                    Container(
                      width: !isExpand
                          ? MediaQuery.of(context).size.width / 5
                          : MediaQuery.of(context).size.width / 8,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: inactiveColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          CommonText(
                              text: "Lead Type", textColor: inactiveColor),
                          CommonText(
                              text: _leadModel.customerLeadType==null ? "Empty data": _leadModel.customerLeadType,
                              textColor: mainColor),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: !isExpand
                          ? MediaQuery.of(context).size.width / 5
                          : MediaQuery.of(context).size.width / 8,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: inactiveColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          CommonText(
                              text: _leadModel.customerLeadType == "Salary"
                                  ? "Customer Salary"
                                  : _leadModel.customerLeadType == "Business"
                                      ? "Customer ITR"
                                      : _leadModel.customerLeadType == "c2c"
                                          ? "Customer Existing Card Limit and Bank"
                                          : _leadModel.customerLeadType ==
                                                  "cibil"
                                              ? "Cibil"
                                              : "Customer has Card",
                              textColor: inactiveColor),
                          CommonText(
                              text: _leadModel.customerLeadType == "Salary"
                                  ? (_leadModel.customerSalary.toString()==null ? "Empty Data":_leadModel.customerSalary.toString())
                                  : _leadModel.customerLeadType == "Business"
                                      ? (_leadModel.customerItr ==null ? "Empty Data":_leadModel.customerItr)
                                      : _leadModel.customerCardLimit==null ? "Empty Data":_leadModel.customerCardLimit,
                              textColor: mainColor),
                        ],
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CommonTextInput1(
              width:!isExpand
                  ? MediaQuery.of(context).size.width / 2.461
                  : MediaQuery.of(context).size.width / 3.9,

                //width: MediaQuery.of(context).size.width,
                minLines: 5,
                inputController: commentController,
                hint: "Enter Comment"),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: !isExpand
                    ? MediaQuery.of(context).size.width / 5
                    : MediaQuery.of(context).size.width / 8,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    border: Border.all(color: inactiveColor),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    CommonText(
                        //text: _leadModel.customerLeadType == "Salary"? "Customer Salary":_leadModel.customerLeadType == "Business"? "Customer ITR":_leadModel.customerLeadType=="c2c"?"Customer Existing Card Limit and Bank":_leadModel.customerLeadType=="cibil"?"Cibil":"Customer has Card",
                        text: "Application Status",
                        textColor: inactiveColor),
                    CommonText(
                        // text: _leadModel.customerLeadType == "Salary"?_leadModel.customerSalary.toString():_leadModel.customerLeadType == "Business"? _leadModel.customerItr:_leadModel.customerCardLimit ,
                        text: _leadModel.status,
                        textColor: mainColor),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                height: 56,
                width: !isExpand
                    ? MediaQuery.of(context).size.width / 5
                    : MediaQuery.of(context).size.width / 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: inactiveColor)),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
                child: DropdownButtonFormField<String>(
                  value: updateStatus,
                  decoration: const InputDecoration(
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  items: <String>[
                    '--No Status--',
                    'Submitted',
                    'Login',
                    'Rejected',
                    'Success'
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      onTap: () {
                        existingStatus = value;
                      },
                      value: value,
                      child: CommonText(text: value, textColor: mainColor),
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
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              LeadModel newLeadModel = _leadModel;
              newLeadModel.comment = commentController.text;
              newLeadModel.status = existingStatus;
              print("================existingStatus================");
              print(existingStatus);
              if (existingStatus == "--No Status--" || existingStatus == null) {
                Get.snackbar("Alert", "Select Status type",
                    backgroundColor: mainColor);
              } else {
                dashBoardController.submitReferral(newLeadModel);
              }
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 85.0),
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
                      text: "Update Status",
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
