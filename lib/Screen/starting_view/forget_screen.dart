
import 'dart:async';
import 'dart:convert';

import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/Session.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Screen/Verify_Otp.dart';
import 'package:eshop_multivendor/Screen/starting_view/otp_screen.dart';
import 'package:eshop_multivendor/Screen/starting_view/utils/colors.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

import '../../Helper/my_new_helper.dart';


class ForgetScreen extends StatefulWidget {
  const ForgetScreen({Key? key}) : super(key: key);

  @override
  _ForgetScreenState createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool visible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ccodeController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? mobile, id, countrycode, countryName, mobileno;
  bool _isNetworkAvail = true;

  TextEditingController phoneController = new TextEditingController();
  bool status = false;
  bool selected = false, enabled = false, edit = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

  }
  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      getVerifyUser();
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        if (mounted)
          setState(() {
            _isNetworkAvail = false;
            status =false;
          });
      });
    }
  }
  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
      ),
      backgroundColor: Theme.of(context).colorScheme.lightWhite,
      elevation: 1.0,
    ));
  }


  Future<void> getVerifyUser() async {
    try {
      var data = {MOBILE: phoneController.text, "forgot_otp": "true"};
      Response response =
      await post(getVerifyUserApi, body: data, headers: headers)
          .timeout(Duration(seconds: timeOut));
      print(response.body);
      var getdata = json.decode(response.body);

      bool? error = getdata["error"];
      String? msg = getdata["message"];
      setState(() {
        status =false;
      });

      SettingProvider settingsProvider =
      Provider.of<SettingProvider>(context, listen: false);

      if (!error!) {
        settingsProvider.setPrefrence(MOBILE, phoneController.text);
        settingsProvider.setPrefrence(COUNTRY_CODE, "91");
        Future.delayed(Duration(seconds: 1)).then((_) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => OtpScreen(
                    mobileNumber:phoneController.text,
                    countryCode: "91",
                    otp:getdata["data"]["otp"].toString(),
                    title: getTranslated(context, 'FORGOT_PASS_TITLE'),
                  )));
        });
      } else {
        setSnackbar(getTranslated(context, 'FIRSTSIGNUP_MSG')!);
      }
    } on TimeoutException catch (_) {
      setState(() {
        status =false;
      });
      setSnackbar(getTranslated(context, 'somethingMSg')!);
    }
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.0, -0.5),
                colors: [
                  AppColor().colorBg1(),
                  AppColor().colorBg2(),
                ],
                radius: 0.8,
              ),
            ),
            padding: MediaQuery.of(context).viewInsets,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 22.65.h,
                  width: 100.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/login_option_bg.png"),
                        fit: BoxFit.fill,
                      )),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                            width: 100.w,
                            height: 4.0.h,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 5.w, top: 1.h),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  "assets/images/drawer/back.png",
                                  height: 4.0.h,
                                  width: 8.w,
                                ))),
                        SizedBox(
                          height: 2.08.h,
                        ),
                        text(
                          "Forgot Password",
                          textColor: Color(0xffffffff),
                          fontSize: 22.sp,
                          fontFamily: fontMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(top: 16.h),
                  width: 83.33.w,
                  height:  42.96.h ,
                  decoration:
                  boxDecoration(radius: 50.0, bgColor: Color(0xffffffff)),
                  child:firstSign(context),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top:  58.96.h, bottom: 8.h),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          enabled = true;
                          selected = true;
                        });
                        await Future.delayed(Duration(milliseconds: 200));
                        setState(() {
                          enabled = false;
                        });
                        if(validateMob(
                            phoneController.text,
                            getTranslated(context, 'MOB_REQUIRED'),
                            getTranslated(context, 'VALID_MOB'))!=null){
                          setSnackbar(validateMob(
                              phoneController.text,
                              getTranslated(context, 'MOB_REQUIRED'),
                              getTranslated(context, 'VALID_MOB')).toString());
                          return;
                        }
                        setState(() {
                          status =true;
                        });
                        checkNetwork();
                        //  Navigator.push(context, PageTransition(child: ForgetScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500),));
                      },
                      child:  !status?Container(
                        width: 69.99.w,
                        height: 6.46.h,
                        decoration: boxDecoration(
                            radius: 15.0, bgColor: AppColor().colorPrimaryDark()),
                        child: Center(
                          child: text(
                            "Send",
                            textColor: Color(0xffffffff),
                            fontSize: 14.sp,
                            fontFamily: fontRegular,
                          ),
                        ),
                      ):CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget firstSign(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 4.32.h,
        ),
        Center(
          child: Image.asset(
            "assets/new_img/forgot_password_img.png",
            height: 16.09.h,
            width: 29.72.w,
          ),
        ),

        Center(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.sp),
              child: text(
                  "Enter the mobile number associated with your account we will send you a otp to reset your password.",
                  textColor: AppColor().colorTextPrimary(),
                  fontSize: 9.sp,
                  fontFamily: fontRegular,
                  isCentered: true,
                  maxLine: 3)),
        ),
        SizedBox(
          height: 1.87.h,
        ),
        Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 69.99.w,
                  height: 9.46.h,
                  child: TextFormField(
                    cursorColor: Colors.red,
                    obscureText: false,
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    style: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 10.sp,
                    ),
                    inputFormatters: [],
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(),
                            width: 1.0,
                            style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      labelText: 'Mobile Number',
                      labelStyle: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      helperText: '',
                      counterText: '',
                      fillColor: AppColor().colorEdit(),
                      enabled: true,
                      filled: true,
                      prefixIcon: Padding(
                        padding: EdgeInsets.all(3.5.w),
                        child: Image.asset(
                          "assets/images/phone.png",
                          color: Color(0xffF4B71E),
                          width: 2.04.w,
                          height: 2.04.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      suffixIcon: phoneController.text.length == 10
                          ?Icon(
                        Icons.check,
                        color: AppColor().colorPrimary(),
                        size: 10.sp,
                      )
                          : SizedBox(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColor().colorEdit(), width: 5.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.5.h,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 2.96.h,
        ),
      ],
    );
  }
}
