import 'package:cardkarobar/screens/history/history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../helper/constant.dart';
import '../dashboard/dashboard_controller.dart';
import '../dashboard/model/lead_model.dart';
class HistoryView extends StatefulWidget {
 

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
HistoryController _historyController = Get.put(HistoryController());
DashBoardController dashBoardController = Get.find();
bool isCategory = false;
String existingBank = '--All Category--';
bool isExpand = false;
bool isClick = false;
String leadStatus = "--All Category--";
String updateStatus = "--No Status--";
final _debouncer = Debouncer(delay: const Duration(milliseconds: 500));
TextEditingController assignController = TextEditingController();
TextEditingController commentController = TextEditingController();
FocusNode focusSearch = FocusNode();
String existingStatus;

  Widget leadDetails(LeadModel _leadModel) {
  commentController.text =
  _leadModel.comment == null ? "" : _leadModel.comment;

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
                      text: _leadModel.customerName, textColor: mainColor),
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
                      text: _leadModel.customerPhone.toString(),
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
                      text: _leadModel.customerEmail, textColor: mainColor),
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
                      text: _leadModel.product.toString(),
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
                  CommonText(text: _leadModel.type, textColor: mainColor),
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
                      text: _leadModel.referralPrice.toString(),
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
                      text: _leadModel.customerCity,
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
                      text: _leadModel.customerState.toString(),
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
                      text: _leadModel.customerLeadType,
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
                          ? _leadModel.customerSalary.toString()
                          : _leadModel.customerLeadType == "Business"
                          ? _leadModel.customerItr
                          : _leadModel.customerCardLimit,
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
          'Insurance'
        ].map((String value) {


          existingBank = value;
          return DropdownMenuItem<String>(
            onTap: () {
              existingBank = value;
              print("===============ontap");
              print(value);
              if (value == '--All Category--') {
                isCategory = false;
                _historyController.myhistory();
              } else {
                isCategory = true;
                _historyController.myCategoryLeads(value);
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
  Widget _leadList() {
    return Obx(() => _historyController.getHistoryLeadList.isEmpty
        ? Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
      ),
    )
        : Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
      child: LazyLoadScrollView(
        onEndOfPage: () => isCategory
            ? _historyController.myCategoryRefreshLeads(existingBank)
            : _historyController.myRefreshHistoryLeads(),
        child: ListView.builder(
          //controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: _historyController.getHistoryLeadList.length,
            shrinkWrap: true,
            padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  _historyController.setLeadDetail = _historyController.getHistoryLeadList[index];

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
                                    _historyController
                                        .getHistoryLeadList[index].customerName,
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
                                    text: _historyController
                                        .getHistoryLeadList[index].product,
                                    textColor: Colors.black,
                                    fontSize: 20),
                              ],
                            ),
                          ),
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
                                    text: _historyController
                                        .getHistoryLeadList[index].status)),
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
  Widget history() {

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
                  width: MediaQuery.of(context).size.width / 3.7,
                  child: _leadList()),
              AnimatedContainer(
                  height: MediaQuery.of(context).size.height,
                  duration: const Duration(milliseconds: 500),
                  width: isExpand ? MediaQuery.of(context).size.width / 3 : MediaQuery.of(context).size.width / 2,
                  child: Column(
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
                                _historyController.getLeadDetail ),
                          ))):const Center(child: Padding(
                        padding: EdgeInsets.only(right: 90.0),
                        child: Text("Load History Data"),
                      ),)
                    ],
                  )),
            ],
          ),
          // child: ,
        ),
      )
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    _historyController.myhistory();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: history(),
    );
  }
}
