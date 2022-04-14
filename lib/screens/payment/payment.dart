import 'package:cardkarobar/helper/constant.dart';
import 'package:cardkarobar/screens/payment/payment_controller.dart';
import 'package:cardkarobar/screens/payment/payment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentView extends StatefulWidget {
  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  PaymentController _paymentController = Get.put(PaymentController());
  @override
  void initState() {
    // TODO: implement initState
    _paymentController.newPaymentRequest();
    _paymentController.oldPaymentRequest();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //print(_paymentController.getOldPaymentList.toString());
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Scaffold(
              body: Obx(()=>ListView.builder(
                  itemCount: _paymentController.getNewPaymentList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_paymentController.getNewPaymentList[index].bNFNAME),
                            Text(_paymentController.getNewPaymentList[index].userId),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_paymentController.getNewPaymentList[index].aMOUNT),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        PaymentModel paymentModel = PaymentModel(
                                            key: _paymentController.getNewPaymentList[index].key,
                                            status: "Credited",
                                            aMOUNT: _paymentController.getNewPaymentList[index].aMOUNT,
                                            bENEACCNO: _paymentController.getNewPaymentList[index].bENEACCNO,
                                            bENEIFSC: _paymentController.getNewPaymentList[index].bENEIFSC,
                                            bNFNAME: _paymentController.getNewPaymentList[index].bNFNAME,
                                            dEBITACCNO: _paymentController.getNewPaymentList[index].dEBITACCNO,
                                            pYMTDATE: Timestamp.now(),
                                            pYMTMODE: _paymentController.getNewPaymentList[index].pYMTMODE,
                                            pYMTPRODTYPECODE: _paymentController.getNewPaymentList[index].pYMTPRODTYPECODE,
                                            userId: _paymentController.getNewPaymentList[index].userId
                                        );
                                        _paymentController.acceptOrRejectPayment(paymentModel);
                                      },
                                      child: Container(
                                        padding:const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.grey)),
                                        child:const Text(
                                          'Accept',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    InkWell(
                                      onTap: (){
                                        PaymentModel paymentModel = PaymentModel(
                                          key: _paymentController.getNewPaymentList[index].key,
                                          status: "Declined",
                                          aMOUNT: _paymentController.getNewPaymentList[index].aMOUNT,
                                          bENEACCNO: _paymentController.getNewPaymentList[index].bENEACCNO,
                                          bENEIFSC: _paymentController.getNewPaymentList[index].bENEIFSC,
                                          bNFNAME: _paymentController.getNewPaymentList[index].bNFNAME,
                                          dEBITACCNO: _paymentController.getNewPaymentList[index].dEBITACCNO,
                                          pYMTDATE: Timestamp.now(),
                                          pYMTMODE: _paymentController.getNewPaymentList[index].pYMTMODE,
                                          pYMTPRODTYPECODE: _paymentController.getNewPaymentList[index].pYMTPRODTYPECODE,
                                          rEMARK: "Invalid Request",
                                          userId: _paymentController.getNewPaymentList[index].userId
                                        );
                                        _paymentController.acceptOrRejectPayment(paymentModel);
                                      },
                                      child: Container(
                                        padding:const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.grey)),
                                        child:const Text(
                                          'Reject',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  })),
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  _paymentController.downloadPaymentList();
                },
                backgroundColor: mainColor,
                child: Icon(Icons.add),
              ),
            ),
          ),
          Expanded(
              child: Obx(()=>ListView.builder(
                  itemCount: _paymentController.getOldPaymentList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_paymentController.getOldPaymentList[index].bNFNAME),
                                    Text(_paymentController.getOldPaymentList[index].userId)
                                  ],
                                ),
                                Text(DateTime.parse(_paymentController.getOldPaymentList[index].pYMTDATE.toDate().toString()).toString())
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_paymentController.getOldPaymentList[index].aMOUNT),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      border:
                                      Border.all(color: mainColor)),
                                  child: Text(
                                    _paymentController.getOldPaymentList[index].status,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Text(_paymentController.getOldPaymentList[index].rEMARK.toString())
                          ],
                        ),
                      ),
                    );
                  })))
        ],
      ),
    );
  }
}
