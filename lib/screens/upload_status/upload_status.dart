import 'package:cardkarobar/screens/upload_status/upload_status_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../../helper/constant.dart';
import '../lead_update/lead_update_controller.dart';

class LeadExcel extends StatefulWidget {
  @override
  State<LeadExcel> createState() => _LeadExcelState();
}

class _LeadExcelState extends State<LeadExcel> {

  UploadStatusController  _uploadStatusController= Get.put(UploadStatusController());
  String leadStatus="---Filter---";
  String selectedFilter;
  @override
  void initState() {
    // TODO: implement initState
    _uploadStatusController.productList();
    _uploadStatusController.unassignNumber();
    super.initState();
  }

  Widget _filterBar() {
    return Obx(()=>Container(
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
        items: _uploadStatusController.getProductList.map((String value) {
          selectedFilter = value;
          return DropdownMenuItem<String>(
            onTap: () {
              print("===============ontap");
              print(value);
              if (value == '---Filter---') {
                Get.snackbar("Alert", "Please select Category");
              } else {
                _uploadStatusController.downloadList(value);
                // _leadUpdateController.leadUpdate(value);
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
    ));
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //backgroundColor: appBackGroundColor,
      appBar: AppBar(
        actions: [_filterBar()],
      ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Scaffold(
                body: Obx(()=> SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: LazyLoadScrollView(
                    //   onEndOfPage: _leadUpdateController.refreshLeadUpdate(),
                    child: DataTable(
                      headingRowColor:
                      MaterialStateColor.resolveWith((states) => Colors.grey.withOpacity(0.5)),
                      columns: [
                        DataColumn(label: Text('Application No',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Customer Name',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Customer Phone',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Product',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Type',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Status',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Price',style: TextStyle(fontWeight: FontWeight.bold),)),
                        DataColumn(label: Text('Lead Closed',style: TextStyle(fontWeight: FontWeight.bold),)),
                      ],
                      rows:
                      List.generate(
                          _uploadStatusController.getUploadList.length, (index) {
                        return DataRow(cells: [
                          DataCell(Text(_uploadStatusController.getUploadList[index].applicationNumber==null ? " ":_uploadStatusController.getUploadList[index].applicationNumber),),
                          DataCell(Text(_uploadStatusController.getUploadList[index].customerName==null ?"No Name":_uploadStatusController.getUploadList[index].customerName)),
                          DataCell(Text(_uploadStatusController.getUploadList[index].customerPhone.toString()==null ?"No Phone":_uploadStatusController.getUploadList[index].customerPhone.toString())),
                          DataCell(Text(_uploadStatusController.getUploadList[index].product==null?"No Product":_uploadStatusController.getUploadList[index].product)),
                          DataCell(Text(_uploadStatusController.getUploadList[index].type==null ? "No Type":_uploadStatusController.getUploadList[index].type)),
                          DataCell(Text(_uploadStatusController.getUploadList[index].status==null ? "No Status":_uploadStatusController.getUploadList[index].status)),
                          DataCell(Text(_uploadStatusController.getUploadList[index].referralPrice.toString()==null ? "0":_uploadStatusController.getUploadList[index].referralPrice.toString())),
                          DataCell(Text(_uploadStatusController.getUploadList[index].isLeadClosed.toString()==null ? "No details":_uploadStatusController.getUploadList[index].isLeadClosed.toString())),
                        ]);
                      }),
                    ),
                  ),
                )),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: mainColor,
                  onPressed: (){
                    if(_uploadStatusController.getUploadList.isEmpty){
                      commonSnackBar("Alert", "No data found to upload");
                    }else{
                      _uploadStatusController.updateLeadStatus();
                    }
                  },
                  child: Icon(Icons.cloud_upload_rounded,color: Colors.white,),
                ),
              ),
            ),
            VerticalDivider(color: mainColor),
            Expanded(
              child: Obx(()=> SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: LazyLoadScrollView(
                  //   onEndOfPage: _leadUpdateController.refreshLeadUpdate(),
                  child: DataTable(
                    headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.grey.withOpacity(0.5)),
                    columns: [
                      DataColumn(label: Text('Application No',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Customer Name',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Customer Phone',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Product',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Type',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Status',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Price',style: TextStyle(fontWeight: FontWeight.bold),)),
                      DataColumn(label: Text('Lead Closed',style: TextStyle(fontWeight: FontWeight.bold),)),
                    ],
                    rows:
                    List.generate(
                        _uploadStatusController.getUploadedList.length, (index) {
                      return DataRow(cells: [
                        DataCell(Text(_uploadStatusController.getUploadedList[index].applicationNumber==null ? " ":_uploadStatusController.getUploadedList[index].applicationNumber),),
                        DataCell(Text(_uploadStatusController.getUploadedList[index].customerName==null ?"No Name":_uploadStatusController.getUploadedList[index].customerName)),
                        DataCell(Text(_uploadStatusController.getUploadedList[index].customerPhone.toString()==null ?"No Phone":_uploadStatusController.getUploadedList[index].customerPhone.toString())),
                        DataCell(Text(_uploadStatusController.getUploadedList[index].product==null?"No Product":_uploadStatusController.getUploadedList[index].product)),
                        DataCell(Text(_uploadStatusController.getUploadedList[index].type==null ? "No Type":_uploadStatusController.getUploadedList[index].type)),
                        DataCell(Text(_uploadStatusController.getUploadedList[index].status==null ? "No Status":_uploadStatusController.getUploadedList[index].status)),
                        DataCell(Text(_uploadStatusController.getUploadedList[index].referralPrice.toString()==null ? "0":_uploadStatusController.getUploadedList[index].referralPrice.toString())),
                        DataCell(Text(_uploadStatusController.getUploadedList[index].isLeadClosed.toString()==null ? "No details":_uploadStatusController.getUploadedList[index].isLeadClosed.toString())),
                      ]);
                    }),
                  ),
                ),
              )),
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        child: Icon(Icons.add),
        onPressed: (){
_uploadStatusController.uploadData();
        },
      ),


    );
  }
}
