import 'dart:io';
import 'dart:math';

import 'package:eshop_multivendor/Helper/String.dart';
import 'package:flutter/material.dart';
import 'package:upi_pay_x/upi_pay.dart';

class UpiPayment{
  String? amount;
  String? upi;
  String? upiName;

  BuildContext? context;
  ValueChanged? onResult;
  List<ApplicationMeta>? _apps;
  UpiPayment({
    this.amount,
    this.upi,
    this.upiName,
    this.context,
    this.onResult,
  });

  void initPayment()async{
    _apps = await UpiPay.getInstalledUpiApplications(
        statusType: UpiApplicationDiscoveryAppStatusType.all);

    showModalBottomSheet(
        isDismissible: true,
        context: context!, builder: (BuildContext context){
      return Container(
        // color: Colors.red,
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text("jhgsufgff")
            appsGrid(_apps!),
          ],
        ),
      );
    });
  }

  GridView appsGrid(List<ApplicationMeta> apps) {
    apps.sort((a, b) => a.upiApplication
        .getAppName()
        .toLowerCase()
        .compareTo(b.upiApplication.getAppName().toLowerCase()));
    return
      GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        // childAspectRatio: 1.6,
        physics: NeverScrollableScrollPhysics(),
        children: apps
            .map(
              (it) => Material(
            key: ObjectKey(it.upiApplication),
            // color: Colors.grey[200],
            child: InkWell(
              onTap: Platform.isAndroid ? () async => await onTap(it) : null,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    it.iconImage(48),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      alignment: Alignment.center,
                      child: Text(
                        it.upiApplication.getAppName(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
            .toList(),
      );
  }
  Future<void> onTap(ApplicationMeta app) async {
    print("this is upi ${upi.toString()}");
    print("this is upi ${upiName.toString()}");

    try {
      final transactionRef = Random.secure().nextInt(1 << 32).toString();
      print("Starting transaction with id $transactionRef");
      UpiTransactionResponse response = await UpiPay.initiateTransaction(
            amount: amount.toString(),
            app: app.upiApplication,
            receiverName: "${upiName}",
            // receiverUpiAddress: "7024663830@upi".trim(),
            receiverUpiAddress:upi!.trim(),
            transactionRef: transactionRef,
            transactionNote: 'UPIPayment',
            // merchantCode: '7372',

      );

    onResult!(response);
    print("this is response here now" + response.status.toString());
    print(response.txnId);
    print(response.txnRef);
    print(response.approvalRefNo);
    }catch (e){
      print('${e}_________');
    }
  }
}