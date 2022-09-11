import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../helper/constant.dart';
import 'lead_update_controller.dart';

class LeadUpdate extends StatefulWidget {
  @override
  State<LeadUpdate> createState() => _LeadUpdateState();
}

class _LeadUpdateState extends State<LeadUpdate> {
  LeadUpdateController _leadUpdateController = Get.put(LeadUpdateController());
  String leadStatus="---Filter---";
  String selectedFilter;
  String leadByStatus="---Filter---";
  String selectedByFilter;
  @override
  void initState() {
    // TODO: implement initState
    _leadUpdateController.leadUpdate("Today");
    super.initState();
  }

  Widget _filterBar() {
    return Container(
      width:  MediaQuery.of(context).size.width / 8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black87)),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
      child: DropdownButtonFormField<String>(
        dropdownColor: mainColor,
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
          '---Filter---',
          'Today',
          'YesterDay',
          'This Week',
          'Last Week',
          'This Month',
          'Last Month'
        ].map((String value) {
          setState(() {
            selectedFilter = value;
          });
          return DropdownMenuItem<String>(
            onTap: () {
              print("===============ontap");
              print(value);
              if (value == '---Filter---') {
                Get.snackbar("Alert", "Please select Category");
              } else {
                _leadUpdateController.leadUpdate(value);
              }
            },
            value: selectedFilter,
            child: CommonText(text: selectedFilter, textColor: Colors.white),
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
    );
  }
  Widget _filterByStatus() {
    return Container(
      width:  MediaQuery.of(context).size.width / 8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.black87)),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
      child: DropdownButtonFormField<String>(
        dropdownColor: mainColor,
        value: leadByStatus,
        decoration: const InputDecoration(
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        items: <String>[
          '---Filter---',
          'Pending',
          'Login',
          'UnderProcess',
          'Rejected',
          'Declined',
          'Approved'
        ].map((String value) {
          setState(() {
            selectedByFilter = value;
          });
          return DropdownMenuItem<String>(
            onTap: () {
              print("===============ontap");
              print(value);
              if (value == '---Filter---') {
                Get.snackbar("Alert", "Please select Category");
              } else {
                _leadUpdateController.leadUpdate(value);
              }
            },
            value: selectedByFilter,
            child: CommonText(text: selectedByFilter, textColor: Colors.white),
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
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Lead Status"),
          actions: [
             Obx(()=>Center(child: Text("Total Lead ${_leadUpdateController.getLeadCount.toString()}")),),
            SizedBox(width: 20,),
            _filterByStatus(),
            _filterBar()
          ],
        ),
        body: Obx(() => ListView.builder(
            itemCount: _leadUpdateController.getLeadGroupByList.length,
            itemBuilder: (context, index) {
              return ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_leadUpdateController.getLeadGroupByList[index].name),
                    Text(_leadUpdateController
                        .getLeadGroupByList[index].leadList.length
                        .toString())
                  ],
                ),
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      sortAscending: true,
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.grey.withOpacity(0.5)),
                      columns: [
                        DataColumn(
                            label: Text(
                              'Index',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        DataColumn(
                            label: Text(
                              'Application No',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        DataColumn(
                            label: Text(
                          'Customer Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'CustomerPhone',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Type',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Status',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Product',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                              'RM Number',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        DataColumn(
                            label: Text(
                          'VSA Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'RM Remark',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Admin Remark',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Text(
                          'Lead Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        //DataColumn(label: Text('Assign To')),
                      ],
                      rows: List.generate(
                          _leadUpdateController.getLeadGroupByList[index].leadList
                              .length, (childIndex) {
                        return DataRow(
                            cells: [
                              DataCell(
                            Text(_leadUpdateController.getLeadGroupByList[index]
                                .leadList.length ==
                                0
                                ? "0"
                                : (childIndex+1).toString()),
                          ),
                              DataCell(
                                Text(_leadUpdateController.getLeadGroupByList[index]
                                    .leadList[childIndex].applicationNo ==
                                    null
                                    ? " "
                                    : _leadUpdateController.getLeadGroupByList[index]
                                    .leadList[childIndex].applicationNo),
                              ),
                              DataCell(
                            Text(_leadUpdateController.getLeadGroupByList[index]
                                        .leadList[childIndex].customerName ==
                                    null
                                ? "No Name"
                                : _leadUpdateController.getLeadGroupByList[index]
                                    .leadList[childIndex].customerName),
                          ),
                              DataCell(Text(_leadUpdateController
                                      .getLeadGroupByList[index]
                                      .leadList[childIndex]
                                      .customerPhone
                                      .toString() ==
                                  null
                              ? "No Phone "
                              : _leadUpdateController.getLeadGroupByList[index]
                                  .leadList[childIndex].customerPhone
                                  .toString())),
                              DataCell(Text(_leadUpdateController
                                      .getLeadGroupByList[index]
                                      .leadList[childIndex]
                                      .type ==
                                  null
                              ? "Product Type"
                              : _leadUpdateController.getLeadGroupByList[index]
                                  .leadList[childIndex].type)),
                              DataCell(Text(_leadUpdateController
                                      .getLeadGroupByList[index]
                                      .leadList[childIndex]
                                      .status ==
                                  null
                              ? "No Status"
                              : _leadUpdateController.getLeadGroupByList[index]
                                  .leadList[childIndex].status)),
                              DataCell(Text(_leadUpdateController
                                      .getLeadGroupByList[index]
                                      .leadList[childIndex]
                                      .product ==
                                  null
                              ? "No Product"
                              : _leadUpdateController.getLeadGroupByList[index]
                                  .leadList[childIndex].product)),
                              DataCell(Text(_leadUpdateController
                                  .getLeadGroupByList[index]
                                  .leadList[childIndex]
                                  .referralId
                                  .toString() ==
                                  null
                                  ? "No Referral Name"
                                  : _leadUpdateController.getLeadGroupByList[index]
                                  .name
                                  .toString())),
                              DataCell(Text(_leadUpdateController
                                  .getLeadGroupByList[index]
                                  .leadList[childIndex].assignedTo
                                  .toString() ==
                                  null
                                  ? "Not Assigned Yet"
                                  : _leadUpdateController
                                  .getLeadGroupByList[index]
                                  .leadList[childIndex].assignedTo
                                  .toString())),
                              DataCell(Text(_leadUpdateController
                                      .getLeadGroupByList[index]
                                      .leadList[childIndex]
                                      .adminComment ==
                                  null
                              ? "No Comment"
                              : _leadUpdateController.getLeadGroupByList[index]
                                  .leadList[childIndex].adminComment)),
                              DataCell(Text(_leadUpdateController
                                      .getLeadGroupByList[index]
                                      .leadList[childIndex]
                                      .comment ==
                                  null
                              ? "No Comment"
                              : _leadUpdateController.getLeadGroupByList[index]
                                  .leadList[childIndex].comment)),
                              DataCell(Text(_leadUpdateController
                                  .getLeadGroupByList[index]
                                  .leadList[childIndex]
                                  .time.toString() ==
                                  null
                                  ? "No Time"
                                  : DateFormat().format( _leadUpdateController.getLeadGroupByList[index]
                                  .leadList[childIndex].time.toDate()).toString())),
                        ]);
                      }),
                    ),
                  )
                ],
              );
            })));
  }
}
