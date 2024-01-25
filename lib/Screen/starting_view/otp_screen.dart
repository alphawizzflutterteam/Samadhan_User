import 'dart:convert';

import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/Session.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/my_new_helper.dart';
import 'package:eshop_multivendor/Model/VerifyUserModel.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Screen/Set_Password.dart';
import 'package:eshop_multivendor/Screen/starting_view/signup_screen.dart';
import 'package:eshop_multivendor/Screen/starting_view/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  final String? mobileNumber, countryCode, title, otp;
  var i;
  OtpScreen(
      {this.mobileNumber, this.countryCode, this.title, this.otp, this.i});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool status = false;
  bool selected = false, enabled = false, edit1 = false;
  final _pinPutController = TextEditingController();
  final _pinPutFocusNode = FocusNode();
  final dataKey = GlobalKey();
  //String? password;
  bool isCodeSent = false;
  late String _verificationId;
  String signature = "";
  bool _isClickable = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? name,
      email,
      password,
      mobile,
      username,
      id,
      countrycode,
      city,
      area,
      pincode,
      address,
      latitude,
      image,
      longitude,
      referCode,
      friendCode;
  AnimationController? buttonController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void dispose() {
    super.dispose();
  }

  String? otpValue;
  @override
  void initState() {
    super.initState();
    getUserDetails();
    otpValue = widget.otp;
    //  getSingature();
    // _onVerifyCode();
    Future.delayed(Duration(seconds: 60)).then((_) {
      _isClickable = true;
    });
  }

  Future<void> getSingature() async {
    signature = await SmsAutoFill().getAppSignature;
    await SmsAutoFill().listenForCode;
  }

  getUserDetails() async {
    SettingProvider settingsProvider =
        Provider.of<SettingProvider>(context, listen: false);
  }

  Future<void> checkNetworkOtp() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      if (_isClickable) {
        print('____Som______ferfff_______');
        // _onVerifyCode();
        _onFormSubmitted();
      } else {
        setSnackbar(getTranslated(context, 'OTPWR')!);
      }
    } else {
      if (mounted) setState(() {});

      Future.delayed(Duration(seconds: 60)).then((_) async {
        bool avail = await isNetworkAvailable();
        if (avail) {
          if (_isClickable)
            // _onVerifyCode();
            _onFormSubmitted();
          else {
            setSnackbar(getTranslated(context, 'OTPWR')!);
          }
        } else {
          setState(() {
            status = false;
          });
          setSnackbar(getTranslated(context, 'somethingMSg')!);
        }
      });
    }
  }

  verifyUser() async {
    var headers = {
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2NjEzNDUxMDEsImlzcyI6ImVzaG9wIiwiZXhwIjoxNjYxMzQ2OTAxfQ.lqzwR9Hk0Rpdx0YLmtdXrk3_B4oEycMXs3aWk5e7ShY',
      'Cookie': 'ci_session=610d564426ab902e5b3f009dc5ba82748517b67e'
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://samadhaan.online/app/v1/api/verify_user'));
    request.fields
        .addAll({'mobile': '${widget.mobileNumber}', 'forgot_otp': 'true'});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalStr = await response.stream.bytesToString();
      final jsonResponse = VerifyUserModel.fromJson(json.decode(finalStr));
      String ootp = jsonResponse.data!.otp.toString();
    } else {
      print(response.reasonPhrase);
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

  void _onVerifyCode() async {
    if (mounted)
      setState(() {
        isCodeSent = true;
      });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((UserCredential value) {
        if (value.user != null) {
          SettingProvider settingsProvider =
              Provider.of<SettingProvider>(context, listen: false);

          setSnackbar(getTranslated(context, 'OTPMSG')!);
          settingsProvider.setPrefrence(MOBILE, widget.mobileNumber!);
          settingsProvider.setPrefrence(COUNTRY_CODE, widget.countryCode!);
          if (widget.title == getTranslated(context, 'SEND_OTP_TITLE')) {
            Future.delayed(Duration(seconds: 2)).then((_) {
              id = widget.i[ID];
              name = widget.i[USERNAME];
              email = widget.i[EMAIL];
              mobile = widget.i[MOBILE];
              //countrycode=i[COUNTRY_CODE];
              CUR_USERID = id;
              // CUR_USERNAME = name;

              UserProvider userProvider = context.read<UserProvider>();
              userProvider.setName(name ?? "");

              SettingProvider settingProvider = context.read<SettingProvider>();
              settingProvider.saveUserDetail(id!, name, email, mobile, city,
                  area, address, pincode, latitude, longitude, "", context);

              Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
            });
          } else if (widget.title ==
              getTranslated(context, 'FORGOT_PASS_TITLE')) {
            Future.delayed(Duration(seconds: 2)).then((_) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          SetPass(mobileNumber: widget.mobileNumber!)));
            });
          }
        } else {
          setSnackbar(getTranslated(context, 'OTPERROR')!);
        }
      }).catchError((error) {
        setSnackbar("OTP is not correct");
        setSnackbar(error.toString());
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      setSnackbar("OTP is not correct");

      if (mounted)
        setState(() {
          isCodeSent = false;
        });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      if (mounted)
        setState(() {
          _verificationId = verificationId;
        });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      if (mounted)
        setState(() {
          _isClickable = true;
          _verificationId = verificationId;
        });
    };

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+${widget.countryCode}${widget.mobileNumber}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  String? reOtp;
  Future<void> getLoginUser() async {
    var data = {MOBILE: widget.mobileNumber};
    Response response =
        await post(getUserLoginWithOtpApi, body: data, headers: headers)
            .timeout(Duration(seconds: timeOut));
    var getdata = json.decode(response.body);
    print(response.body);
    otpValue = getdata['otp'].toString();
    bool error = getdata["error"];
    String? msg = getdata["message"];
    setState(() {
      status = false;
    });
    if (!error) {
      print("msg here ${msg}");
      setSnackbar("${msg!}");
      if (msg == "User does not exists !") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpScreen()));
      }
      var i = getdata["data"][0];
      id = i[ID];
      username = i[USERNAME];
      email = i[EMAIL];
      mobile = i[MOBILE];
      city = i[CITY];
      area = i[AREA];
      address = i[ADDRESS];
      pincode = i[PINCODE];
      latitude = i[LATITUDE];
      longitude = i[LONGITUDE];
      image = i[IMAGE];
      CUR_USERID = id;
      // CUR_USERNAME = username;
      // UserProvider userProvider =
      // Provider.of<UserProvider>(this.context, listen: false);
      // userProvider.setName(username ?? "");
      // userProvider.setEmail(email ?? "");
      // userProvider.setProfilePic(image ?? "");
      //
      // SettingProvider settingProvider =
      // Provider.of<SettingProvider>(context, listen: false);
      //
      // settingProvider.saveUserDetail(id!, username, email, mobile, city, area,
      //     address, pincode, latitude, longitude, image, context);

      // Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen(
      //   otp: getdata["otp"].toString(),
      //   title: "Log In",
      //   mobileNumber: phoneController.text,
      //   countryCode: "91",
      //   i: i,
      // )
      // ));
      // Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
    } else {
      setSnackbar(" ${msg!}");
    }
  }

  void _onFormSubmitted() async {
    String code = _pinPutController.text.trim();

    if (code == otpValue) {
      if (code != null) {
        SettingProvider settingsProvider =
            Provider.of<SettingProvider>(context, listen: false);

        setState(() {
          status = false;
        });
        setSnackbar(getTranslated(context, 'OTPMSG')!);
        settingsProvider.setPrefrence(MOBILE, widget.mobileNumber!);
        settingsProvider.setPrefrence(COUNTRY_CODE, "91");
        if (widget.title == getTranslated(context, 'SEND_OTP_TITLE')) {
          id = widget.i[ID];
          name = widget.i[USERNAME];
          email = widget.i[EMAIL];
          mobile = widget.i[MOBILE];
          //countrycode=i[COUNTRY_CODE];
          CUR_USERID = id;
          // CUR_USERNAME = name;
          UserProvider userProvider = context.read<UserProvider>();
          userProvider.setName(name ?? "");

          SettingProvider settingProvider = context.read<SettingProvider>();
          settingProvider.saveUserDetail(id!, name, email, mobile, city, area,
              address, pincode, latitude, longitude, "", context);
          Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
        } else if (widget.title ==
            getTranslated(context, 'FORGOT_PASS_TITLE')) {
          Future.delayed(Duration(seconds: 2)).then((_) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SetPass(mobileNumber: widget.mobileNumber!)));
          });
        } else if (widget.title == "Log In") {
          id = widget.i[ID];
          name = widget.i[USERNAME];
          email = widget.i[EMAIL];
          mobile = widget.i[MOBILE];
          //countrycode=i[COUNTRY_CODE];
          CUR_USERID = id;
          // CUR_USERNAME = name;
          UserProvider userProvider = context.read<UserProvider>();
          userProvider.setName(name ?? "");
          SettingProvider settingProvider = context.read<SettingProvider>();
          settingProvider.saveUserDetail(id!, name, email, mobile, city, area,
              address, pincode, latitude, longitude, "", context);
          Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
        }
      } else {
        setSnackbar(getTranslated(context, 'ENTEROTP')!);
      }
    } else {
      setState(() {
        status = false;
      });
      setSnackbar("Wrong Otp");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor().colorBg2(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            width: 100.w,
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
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(top: 18.h),
                  width: 99.33.w,
                  height: 72.05.h,
                  child: firstSign(context),
                ),
                Container(
                  height: 17.89.h,
                  width: 100.w,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 1.h),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/login_option_bg.png"),
                    fit: BoxFit.fill,
                  )),
                  child: Column(
                    children: [
                      Container(
                          width: 100.w,
                          height: 4.0.h,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 5.w, top: 0.5.h),
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
                        height: 1.08.h,
                      ),
                      // text(
                      //   "OTP ${widget.otp}",
                      //
                      //   textColor: Color(0xffffffff),
                      //   fontSize: 22.sp,
                      //   fontFamily: fontMedium,
                      // ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10.49.h,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 14.66.h,
                        width: 14.66.h,
                        child: Image(
                          image: AssetImage("assets/images/otp.png"),
                          fit: BoxFit.cover,
                          height: 14.66.h,
                          width: 14.66.h,
                        ),
                      ),
                    ],
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
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 9.92.h,
        ),
        text(
          "ENTER YOUR 4 DIGIT CODE",
          textColor: AppColor().colorTextPrimary(),
          fontSize: 14.sp,
          fontFamily: fontBold,
        ), 
        SizedBox(
          height: 3.02.h,
        ),
        // Text("${widget.otp}"),
        text(
          "Don't share it with any other",
          textColor: AppColor().colorTextSecondary(),
          fontSize: 10.sp,
          fontFamily: fontRegular,
        ),
        SizedBox(
          height: 3.02.h,
        ),
        Container(
          width: 90.w,
          child: PinPut(
            validator: (s) {},
            autovalidateMode: AutovalidateMode.always,
            withCursor: true,
            fieldsCount: 4,
            fieldsAlignment: MainAxisAlignment.spaceAround,
            textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
            eachFieldMargin: EdgeInsets.all(0),
            eachFieldWidth: 14.0.w,
            eachFieldHeight: 14.0.w,
            focusNode: _pinPutFocusNode,
            controller: _pinPutController,
            submittedFieldDecoration: pinPutDecoration,
            selectedFieldDecoration: pinPutDecoration.copyWith(
              color: Colors.white,
              border: Border.all(
                width: 2,
                color: const Color.fromRGBO(160, 215, 220, 1),
              ),
            ),
            followingFieldDecoration: pinPutDecoration,
            pinAnimationType: PinAnimationType.scale,
          ),
        ),
        SizedBox(
          height: 3.02.h,
        ),
        text(
          "Enter 4 Digit OTP number Sent to your Phone",
          textColor: AppColor().colorTextSecondary(),
          fontSize: 10.sp,
          fontFamily: fontRegular,
        ),
        SizedBox(
          height: 5.02.h,
        ),
        Container(
          child: InkWell(
            onTap: () {
              getLoginUser();
              // setState(() {
              //   edit1 = true;
              // });
              // await Future.delayed(Duration(milliseconds: 200));
              // setState(() {
              //   edit1 = false;
              // });
              // setState(() {
              //   status = false;
              // });
              //  checkNetworkOtp();
            },
            child: RichText(
              text: new TextSpan(
                text: "Didn't Got Code? ",
                style: TextStyle(
                  color: Color(0xff171717),
                  fontSize: 10.sp,
                  fontFamily: fontBold,
                ),
                children: <TextSpan>[
                  new TextSpan(
                    text: 'Resend',
                    style: TextStyle(
                      color: Color(0xffF4B71E),
                      fontSize: 12.sp,
                      fontFamily: fontBold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5.02.h,
        ),
        Center(
          child: Container(
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
                if (_pinPutController.text.length == 4) {
                  setState(() {
                    status = true;
                  });
                  _onFormSubmitted();
                } else {
                  setSnackbar("Please Enter Valid Otp");
                }
              },
              child: !status
                  ? Container(
                      width: 79.99.w,
                      height: 6.46.h,
                      decoration: boxDecoration(
                          radius: 15.0, bgColor: AppColor().colorPrimaryDark()),
                      child: Center(
                        child: text(
                          "Submit",
                          textColor: Color(0xffffffff),
                          fontSize: 14.sp,
                          fontFamily: fontRegular,
                        ),
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
          ),
        ),
        // InkWell(
        //   onTap: (){
        //     _onFormSubmitted();
        //   },
        //     child: Text("ddd")),
        SizedBox(
          height: 1.46.h,
        ),
      ],
    );
  }
}
