import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cc_avenue/cc_avenue.dart';
import 'package:samadhaan_user/Model/DateModel.dart';
import 'package:samadhaan_user/Model/NewDateModel.dart';
import 'package:samadhaan_user/Provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper/AppBtn.dart';
import '../Helper/Color.dart';
import '../Helper/Constant.dart';
import '../Helper/PaymentRadio.dart';
import '../Helper/Session.dart';
import '../Helper/SimBtn.dart';
import '../Helper/String.dart';
import '../Helper/Stripe_Service.dart';
import '../Model/Model.dart';
import 'Cart.dart';
import 'package:http/http.dart' as http;

class Payment extends StatefulWidget {
  final Function update;
  final String? msg;
  String? isEnbleUpi;

  Payment(this.update, this.msg, this.isEnbleUpi);

  @override
  State<StatefulWidget> createState() {
    return StatePayment();
  }
}

List<Model> timeSlotList = [];
String? allowDay;
bool codAllowed = true;
String? bankName, bankNo, acName, acNo, exDetails;

class StatePayment extends State<Payment> with TickerProviderStateMixin {
  bool _isLoading = true;
  String? startingDate;

  bool showExpireTime = false;
  String? selectedTimes;
  late bool cod,
      paypal,
      upi = true,
      razorpay,
      paumoney,
      paystack,
      flutterwave,
      stripe,
      paytm = true,
      gpay = false,
      bankTransfer = true;
  // bool upi;
  List<RadioModel> timeModel = [];
  List<RadioModel> payModel = [];
  List<RadioModel> timeModelList = [];
  bool timeSelected = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<String?> paymentMethodList = [];
  List<String> paymentIconList = [
    Platform.isIOS ? 'assets/images/applepay.svg' : 'assets/images/gpay.svg',
    'assets/images/cod.svg',
    'assets/images/paypal.svg',
    'assets/icons/upi-icon.svg',
    'assets/images/payu.svg',
    'assets/images/rozerpay.svg',
    'assets/images/paystack.svg',
    'assets/images/flutterwave.svg',
    'assets/images/stripe.svg',
    'assets/images/paytm.svg',
    'assets/images/banktransfer.svg',
  ];

  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  bool _isNetworkAvail = true;
  final plugin = PaystackPlugin();
  String? limitStatus = "false";
  String? timeId;
  String? deliveryTimes;
  String? limits;
  String? total;
  List<String> timeList = [];
  String? selectedindex;
  List<dynamic> timesList = [];
  getTimes(String? date) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token-key");
    var response = await http.post(
        Uri.parse("https://samadhaan.online/app/v1/api/checklimit"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          "date": date.toString(),
          'user_id': CUR_USERID.toString()
        });
    print("checking response of getTime ${response.body}");
    var result = NewDateModel.fromJson(json.decode(response.body)).data;
    timesList.clear();
    for (var i = 0; i < result!.length; i++) {
      print("result here ${result[i].title}");
      print("TOTAL ORDER here ${result[i].totalOrder}");
      timesList.add(result[i]);
    }
    setState(() {});
  }

  var finalResult;
  getTimeSlot() async {
    timeList.clear();
    print("working");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString("token-key");
    print("token key ${token}");
    print("dsdfs ${selDate} and ${selectedDate}");
    var response = await http.post(
        Uri.parse("https://samadhaan.online/app/v1/api/checklimit"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          "date": "${selDate}"
        });
    log("checking date response ${response.body}");
    List<String> timeLists = [];
    // var data = DateModel.fromJson(json.decode(response.body)).data;
    finalResult = DateModel.fromJson(json.decode(response.body)).data;
    // if(data != null){
    print("final result here ${finalResult} and ");
    for (var i = 0; i < finalResult!.length; i++) {
      print("total-----${finalResult[i].limit} and");
      total = finalResult[i].total;
      limitStatus = finalResult[i].status;
      deliveryTimes = finalResult[i].deliveryTime;
      limits = finalResult[i].limit;
      timeList.add(deliveryTimes!);
      timeLists.add(finalResult[i].deliveryTime!);
    }
  }

  String? currentTime;
  String? checkDate;
  getCurrentTimeNow() {
    DateTime dateTime = DateTime.now();
    print("date time now here ${dateTime}");
    setState(() {
      checkDate = DateFormat('yyyy-MM-dd').format(dateTime);
      print("Check date: $checkDate");
    });
    currentTime = DateFormat("HH:mm:ss").format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _getdateTime();
    getCurrentTimeNow();
    getTimes(checkDate);
    timeSlotList.length = 0;
    new Future.delayed(Duration.zero, () {
      paymentMethodList = [
        Platform.isIOS
            ? getTranslated(context, 'APPLEPAY')
            : getTranslated(context, 'GPAY'),
        getTranslated(context, 'COD_LBL'),
        // getTranslated(context, 'UPI'),

        getTranslated(context, 'PAYPAL_LBL'),
        "UPI",
        getTranslated(context, 'PAYUMONEY_LBL'),
        getTranslated(context, 'RAZORPAY_LBL'),
        getTranslated(context, 'PAYSTACK_LBL'),
        getTranslated(context, 'FLUTTERWAVE_LBL'),
        getTranslated(context, 'STRIPE_LBL'),
        getTranslated(context, 'PAYTM_LBL'),
        getTranslated(context, 'BANKTRAN'),
      ];
    });
    if (widget.msg != '')
      WidgetsBinding.instance
          .addPostFrameCallback((_) => setSnackbar(widget.msg!));
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    buttonSqueezeanimation = new Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(new CurvedAnimation(
      parent: buttonController!,
      curve: new Interval(
        0.0,
        0.150,
      ),
    ));
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  // getCheckLimitResponse()async{
  //   DateModel model = await checkLimit();
  //   if(model != null){
  //     setState(() {
  //       limitStatus = model.status;
  //     });
  //   }
  //   print("JVJV+ $limitStatus");
  // }

  // Future checkLimit() async {
  //   var request = http.MultipartRequest('POST', Uri.parse('https://samadhaan.online/app/v1/api/checklimit'));
  //   request.fields.addAll({
  //     'date': '$selDate'
  //   });
  //
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //
  //   if (response.statusCode == 200) {
  //     print("now ${response.stream}");
  //    final str = await response.stream.bytesToString();
  //    print("okkk ${str}");
  //    return DateModel.fromJson(json.decode(str));
  //   }
  //   else {
  //   return null;
  //   }
  // }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: getTranslated(context, 'TRY_AGAIN_INT_LBL'),
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  _getdateTime();
                } else {
                  await buttonController!.reverse();
                  if (mounted) setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await CcAvenue.cCAvenueInit(
          transUrl: 'https://test.ccavenue.com/transaction/initTrans',
          accessCode: '4YRUXLSRO20O8NIH',
          amount: '10',
          cancelUrl: 'http://122.182.6.216/merchant/ccavResponseHandler.jsp',
          currencyType: 'INR',
          merchantId: '2',
          orderId: '519',
          redirectUrl: 'http://122.182.6.216/merchant/ccavResponseHandler.jsp',
          rsaKeyUrl: 'https://secure.ccavenue.com/transaction/jsp/GetRSA.jsp');
    } on PlatformException {
      print('PlatformException');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: getSimpleAppBar(
            getTranslated(context, 'PAYMENT_METHOD_LBL')!, context),
        // getAppBar(getTranslated(context, 'PAYMENT_METHOD_LBL')!, context),
        body: _isNetworkAvail
            ? _isLoading
                ? getProgress()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 5),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Consumer<UserProvider>(
                                    builder: (context, userProvider, _) {
                                  return Card(
                                    elevation: 0,
                                    child: userProvider.curBalance != "0" &&
                                            // userProvider.curBalance.isNotEmpty &&
                                            userProvider.curBalance != "" &&
                                            userProvider.curBalance != null
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: CheckboxListTile(
                                              dense: true,
                                              contentPadding: EdgeInsets.all(0),
                                              value: isUseWallet,
                                              onChanged: (bool? value) {
                                                if (mounted)
                                                  setState(() {
                                                    isUseWallet = value!;
                                                    if (value) {
                                                      if (totalPrice <=
                                                          double.parse(
                                                              userProvider
                                                                  .curBalance)) {
                                                        remWalBal = (double.parse(
                                                                userProvider
                                                                    .curBalance) -
                                                            totalPrice);
                                                        usedBal = totalPrice;
                                                        payMethod = "Wallet";

                                                        isPayLayShow = false;
                                                      } else {
                                                        remWalBal = 0;
                                                        usedBal = double.parse(
                                                            userProvider
                                                                .curBalance);
                                                        isPayLayShow = true;
                                                      }
                                                      totalPrice =
                                                          totalPrice - usedBal;
                                                    } else {
                                                      totalPrice =
                                                          totalPrice + usedBal;
                                                      remWalBal = double.parse(
                                                          userProvider
                                                              .curBalance);
                                                      payMethod = null;
                                                      selectedMethod = null;
                                                      usedBal = 0;
                                                      isPayLayShow = true;
                                                    }

                                                    widget.update();
                                                  });
                                              },
                                              title: Text(
                                                getTranslated(
                                                    context, 'USE_WALLET')!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle1,
                                              ),
                                              subtitle: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Text(
                                                  isUseWallet!
                                                      ? getTranslated(context,
                                                              'REMAIN_BAL')! +
                                                          " : " +
                                                          CUR_CURRENCY! +
                                                          " " +
                                                          remWalBal
                                                              .toStringAsFixed(
                                                                  2)
                                                      : getTranslated(context,
                                                              'TOTAL_BAL')! +
                                                          " : " +
                                                          CUR_CURRENCY! +
                                                          " " +
                                                          double.parse(
                                                                  userProvider
                                                                      .curBalance)
                                                              .toStringAsFixed(
                                                                  2),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .black),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  );
                                }),
                                isTimeSlot!
                                    ? Card(
                                        elevation: 0,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                getTranslated(
                                                    context, 'PREFERED_TIME')!,
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .fontColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            Divider(),
                                            Container(
                                              height: 90,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      int.parse(allowDay!),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return dateCell(index);
                                                  }),
                                            ),
                                            Divider(),
                                            showTime
                                                ? ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: timesList.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      // print("checking limit here  ${timesList[index].limit} and ${timesList[index].totalOrder} and ${timesList[index].id}");
                                                      // print("TOITLAQ===" + int.parse(timesList[0].totalOrder.toString()).toString());
                                                      return int.parse(timesList[
                                                                      index]
                                                                  .totalOrder
                                                                  .toString()) >=
                                                              int.parse(timesList[
                                                                      index]
                                                                  .limit
                                                                  .toString())
                                                          ? SizedBox.shrink()
                                                          : Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom: 8,
                                                                      left: 5),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    selectedindex =
                                                                        timesList[index]
                                                                            .id;
                                                                    print(
                                                                        "selected id here ${selectedindex}");
                                                                    selTime = timesList[
                                                                            index]
                                                                        .title;
                                                                  });
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    selectedindex ==
                                                                            timesList[index].id
                                                                        ? Container(
                                                                            height:
                                                                                20,
                                                                            width:
                                                                                20,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.green,
                                                                              borderRadius: BorderRadius.circular(100),
                                                                              border: Border.all(color: Colors.grey),
                                                                            ),
                                                                            child:
                                                                                Icon(
                                                                              Icons.check,
                                                                              color: Colors.white,
                                                                              size: 15,
                                                                            ),
                                                                          )
                                                                        : Container(
                                                                            height:
                                                                                20,
                                                                            width:
                                                                                20,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              // color: Colors.green,
                                                                              borderRadius: BorderRadius.circular(100),
                                                                              border: Border.all(color: Colors.grey),
                                                                            ),
                                                                            // child: Icon(Icons.check,color: Colors.white,size: 15,),
                                                                          ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    Text(
                                                                        "${timesList[index].title}")
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                      // return timeSlotItem(index,timeModel[index].name);
                                                    })
                                                : Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            2,
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Holiday",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 25,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .fontColor),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "Please select other date",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ],
                                                    ))
                                          ],
                                        ),
                                      )
                                    : Container(),
                                showTime == false
                                    ? SizedBox.shrink()
                                    : isPayLayShow
                                        ? Card(
                                            elevation: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    getTranslated(context,
                                                        'SELECT_PAYMENT')!,
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .fontColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                Divider(),
                                                // Padding(
                                                //   padding:  EdgeInsets.only(left: 10),
                                                //   child: InkWell(
                                                //       onTap: (){
                                                //         initPlatformState();
                                                //       },
                                                //       child: Text("Pay online",style: TextStyle(color: Colors.white),)),
                                                // ),
                                                ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    itemCount: paymentMethodList
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      if (index == 1 && cod)
                                                        return paymentItem(
                                                            index);
                                                      else if (index == 2 &&
                                                          paypal)
                                                        return paymentItem(
                                                            index);
                                                      else if (index == 3 &&
                                                          upi)
                                                        return widget
                                                                    .isEnbleUpi ==
                                                                "1"
                                                            ? paymentItem(index)
                                                            : SizedBox.shrink();
                                                      else if (index == 4 &&
                                                          paumoney)
                                                        return paymentItem(
                                                            index);
                                                      else if (index == 5 &&
                                                          razorpay)
                                                        return paymentItem(
                                                            index);
                                                      else if (index == 6 &&
                                                          paystack)
                                                        return paymentItem(
                                                            index);
                                                      else if (index == 7 &&
                                                          flutterwave)
                                                        return paymentItem(
                                                            index);
                                                      else if (index == 8 &&
                                                          stripe)
                                                        return paymentItem(
                                                            index);
                                                      else if (index == 9 &&
                                                          paytm)
                                                        return paymentItem(
                                                            index);
                                                      else if (index == 0 &&
                                                          gpay)
                                                        return paymentItem(
                                                            index);
                                                      else if (index == 10 &&
                                                          bankTransfer)
                                                        return paymentItem(
                                                            index);
                                                      else
                                                        return Container();
                                                    }),
                                              ],
                                            ),
                                          )
                                        : Container()
                              ],
                            ),
                          ),
                        ),
                        showTime == false
                            ? SizedBox.shrink()
                            : SimBtn(
                                size: 0.8,
                                title: getTranslated(context, 'DONE'),
                                onBtnSelected: () {
                                  selectedDate = -1;
                                  // payMethod = "0";
                                  Navigator.pop(context);
                                },
                              ),
                      ],
                    ),
                  )
            : noInternet(context),
      ),
    );
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.black),
      ),
      backgroundColor: Theme.of(context).colorScheme.white,
      elevation: 1.0,
    ));
  }

  dateCell(int index) {
    DateTime today = DateTime.parse(startingDate!);

    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selectedDate == index ? colors.primary : null),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('EEE').format(today.add(Duration(days: index))),
              style: TextStyle(
                  color: selectedDate == index
                      ? Theme.of(context).colorScheme.white
                      : Theme.of(context).colorScheme.lightBlack2),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                DateFormat('dd').format(today.add(Duration(days: index))),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: selectedDate == index
                        ? Theme.of(context).colorScheme.white
                        : Theme.of(context).colorScheme.lightBlack2),
              ),
            ),
            Text(
              DateFormat('MMM').format(today.add(Duration(days: index))),
              style: TextStyle(
                  color: selectedDate == index
                      ? Theme.of(context).colorScheme.white
                      : Theme.of(context).colorScheme.lightBlack2),
            ),
          ],
        ),
      ),
      onTap: () {
        DateTime dates = DateTime.now();
        String formate = DateFormat('yyyy-MM-dd').format(dates);
        // getTimes(formate);
        DateTime date = today.add(Duration(days: index));
        if (mounted) selectedDate = index;
        //   if(selectedDate  == 0){
        //     _getdateTime();
        // }
        //   _getdateTime();
        //   print("selected Date ${selectedDate}");
        for (var v in holiday) {
          if (v['holiday_date'] == DateFormat("yyyy-MM-dd").format(date)) {
            setState(() {
              showTime = false;
            });
            break;
          } else {
            setState(() {
              showTime = true;
              // getTimeSlot();
            });
          }
        }
        selectedTime = null;
        selTime = null;
        selDate = DateFormat('yyyy-MM-dd').format(date);
        print("selected date here ${selDate}");
        getTimes(selDate);
        DateTime cur = DateTime.now();
        DateTime tdDate = DateTime(cur.year, cur.month, cur.day);
        // if (date == tdDate) {
        //   print("time check now ${timeSlotList.length}");
        //   if (timeSlotList.length > 0) {
        //     for (int i = 0; i < timeSlotList.length; i++) {
        //
        //       DateTime cur = DateTime.now();
        //       // String time = timeSlotList[i].toTime!;
        //       String times = timeSlotList[i].name!;
        //       print("ok now ${times} and ${timeSlotList[i].name} and ${timeSlotList[i].lastTime}");
        //       DateTime last = DateTime(
        //           cur.year,
        //           cur.month,
        //           cur.day,
        //           int.parse(times.split(':')[0]),
        //           int.parse(times.split(':')[1]),
        //           int.parse(times.split(':')[2]));
        //
        //       var data2 = DateTime.parse(timeSlotList[i].lastTime!.split(" ").toString());
        //       if (cur.isBefore(last)) {
        //
        //         timeModel.add(new RadioModel(
        //             isSelected: i == selectedTime ? true : false,
        //
        //             name:  timeSlotList[i].name,
        //             limit: timeSlotList[i].limit.toString(),
        //             img: ''));
        //       }
        //     }
        //   }
        // } else {
        //   print("time length ${timeSlotList.length}");
        //   if (timeSlotList.length > 0) {
        //     print("working here ${timeSlotList.length}");
        //     for (int i = 0; i < timeSlotList.length; i++) {
        //       print("just ${timeSlotList[i].name}");
        //       timeModel.add(new RadioModel(
        //           isSelected: i == selectedTime ? true : false,
        //          //name: "39",
        //            name:  timeSlotList[i].name,
        //           limit: timeSlotList[i].limit.toString(),
        //           img: ''));
        //     }
        //   }
        // }
        // setState(() {});
      },
    );
  }

  //
  // String getTime(String date){
  //   int time = DateTime.parse(date).difference(DateTime.now()).inHours;
  //   return time.toString() ;
  //
  // }

  bool showTime = true;
  var holiday = [];
  Future<void> _getdateTime() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      timeSlotList.clear();
      try {
        var parameter = {TYPE: PAYMENT_METHOD, USER_ID: CUR_USERID};
        print("parameter for times ${PAYMENT_METHOD} and ${CUR_USERID}");
        Response response =
            await post(getSettingApi, body: parameter, headers: headers)
                .timeout(Duration(seconds: timeOut));
        print("response of time ${response} and ${response.body} vff");
        if (response.statusCode == 200) {
          var getdata = json.decode(response.body);
          print("get data ${getdata}");
          bool error = getdata["error"];
          // String msg = getdata["message"];
          if (!error) {
            var data = getdata["data"];
            var time_slot = data["time_slot_config"];
            allowDay = time_slot["allowed_days"];
            isTimeSlot =
                time_slot["is_time_slots_enabled"] == "1" ? true : false;
            startingDate = time_slot["starting_date"];
            codAllowed = data["is_cod_allowed"] == 1 ? true : false;
            var timeSlots = data["time_slots"];
            holiday = data["holiday"];
            timeSlotList = (timeSlots as List)
                .map((timeSlots) => new Model.fromTimeSlot(timeSlots))
                .toList();
            print("okss ${timeSlots.length}");

            if (timeSlotList.length > 0) {
              for (int i = 0; i < timeSlotList.length; i++) {
                if (selectedDate != null) {
                  DateTime today = DateTime.parse(startingDate!);
                  DateTime date = today.add(Duration(days: selectedDate!));
                  for (var v in holiday) {
                    if (v['holiday_date'] ==
                        DateFormat("yyyy-MM-dd").format(date)) {
                      showTime = false;
                      break;
                    }
                  }
                  DateTime cur = DateTime.now();
                  DateTime tdDate = DateTime(cur.year, cur.month, cur.day);
                  print("compare ${date} and ${tdDate}");
                  if (date == tdDate) {
                    DateTime cur = DateTime.now();
                    String time = timeSlotList[i].toTime!;
                    String times = timeSlotList[i].name!;
                    selectedTimes = times;
                    print("again time here ${time} and ${times}");
                    DateTime last = DateTime(
                        cur.year,
                        cur.month,
                        cur.day,
                        int.parse(time.split(':')[0]),
                        int.parse(time.split(':')[1]),
                        int.parse(time.split(':')[2]));

                    // String orderTime = getTime(timeSlotList[i].lastTime!);
                    if (cur.isBefore(last)) {
                      // int.parse(currentTime!.split(":")[0].toString()) <=
                      //         int.parse(timeSlotList[i].name!.split(":")[0].toString())
                      //     ? timeModel.add(new RadioModel(
                      //         isSelected: i == selectedTime ? true : false,
                      //         name: timeSlotList[i].name,
                      //         limit: timeSlotList[i].limit.toString(),
                      //         img: ''))
                      //     : SizedBox.shrink();
                    }
                  } else {
                    timeModel.add(new RadioModel(
                        isSelected: i == selectedTime ? true : false,
                        name: timeSlotList[i].name,
                        limit: timeSlotList[i].limit.toString(),
                        img: ''));
                  }
                } else {
                  print(
                      "selected detail here ${i} and  ${selectedTime} and ${timeSlotList[i].name}");
                  timeModel.add(new RadioModel(
                      isSelected: i == selectedTime ? true : false,
                      name: timeSlotList[i].name,
                      // name: "8943",
                      limit: timeSlotList[i].limit.toString(),
                      img: ''));
                }
              }
            }
            var payment = data["payment_method"];
            cod = codAllowed
                ? payment["cod_method"] == "1"
                    ? true
                    : false
                : false;
            paypal = payment["paypal_payment_method"] == "1" ? true : false;
            paumoney =
                payment["payumoney_payment_method"] == "1" ? true : false;
            flutterwave =
                payment["flutterwave_payment_method"] == "1" ? true : false;
            razorpay = payment["razorpay_payment_method"] == "1" ? true : false;
            paystack = payment["paystack_payment_method"] == "1" ? true : false;
            stripe = payment["stripe_payment_method"] == "1" ? true : false;
            paytm = payment["paytm_payment_method"] == "1" ? true : false;
            bankTransfer =
                payment["direct_bank_transfer"] == "1" ? true : false;
            if (razorpay) razorpayId = payment["razorpay_key_id"];
            if (paystack) {
              paystackId = payment["paystack_key_id"];
              plugin.initialize(publicKey: paystackId!);
            }
            if (stripe) {
              stripeId = payment['stripe_publishable_key'];
              stripeSecret = payment['stripe_secret_key'];
              stripeCurCode = payment['stripe_currency_code'];
              stripeMode = payment['stripe_mode'] ?? 'test';
              StripeService.secret = stripeSecret;
              StripeService.init(stripeId, stripeMode);
            }
            if (paytm) {
              paytmMerId = payment['paytm_merchant_id'];
              paytmMerKey = payment['paytm_merchant_key'];
              payTesting =
                  payment['paytm_payment_mode'] == 'sandbox' ? true : false;
            }
            if (bankTransfer) {
              bankName = payment['bank_name'];
              bankNo = payment['bank_code'];
              acName = payment['account_name'];
              acNo = payment['account_number'];
              exDetails = payment['notes'];
            }
            for (int i = 0; i < paymentMethodList.length; i++) {
              payModel.add(RadioModel(
                  isSelected: i == selectedMethod ? true : false,
                  name: paymentMethodList[i],
                  img: paymentIconList[i]));
            }
          } else {
            // setSnackbar(msg);
          }
        }
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      } on TimeoutException catch (_) {
        //setSnackbar( getTranslated(context,'somethingMSg'));
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }

  Widget timeSlotItem(int index, String? name) {
    print("working on it ${name}");
    return new InkWell(
      onTap: () {
        if (limits != total) {
          print("working condition 3");
          // if (mounted)
          setState(() {
            selectedTime = index;
            selTime = timeModel[selectedTime!].name;
            //timeSlotList[selectedTime].name;
            timeModel.forEach((element) => element.isSelected = false);
            timeModel[index].isSelected = true;
          });
        } else {
          //7738050402
          setSnackbar("This Time Order Limit Reached");
        }
      },
      child: new RadioItem(timeModel[index]),
    );
  }

  Widget paymentItem(int index) {
    return new InkWell(
      onTap: () {
        if (mounted)
          setState(() {
            selectedMethod = index;
            payMethod = paymentMethodList[selectedMethod!];

            payModel.forEach((element) => element.isSelected = false);
            payModel[index].isSelected = true;
          });
      },
      child: new RadioItem(payModel[index]),
    );
  }
}
