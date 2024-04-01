import 'dart:convert';

import 'package:samadhaan_user/Helper/Color.dart';
import 'package:samadhaan_user/Helper/Constant.dart';
import 'package:samadhaan_user/Helper/Session.dart';
import 'package:samadhaan_user/Helper/String.dart';
import 'package:samadhaan_user/Helper/my_new_helper.dart';
import 'package:samadhaan_user/Provider/SettingProvider.dart';
import 'package:samadhaan_user/Provider/UserProvider.dart';
import 'package:samadhaan_user/Screen/SendOtp.dart';
import 'package:samadhaan_user/Screen/starting_view/forget_screen.dart';
import 'package:samadhaan_user/Screen/starting_view/otp_screen.dart';
import 'package:samadhaan_user/Screen/starting_view/signup_screen.dart';
import 'package:samadhaan_user/Screen/starting_view/utils/colors.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  bool status = false;
  bool selected = false, enabled = false, edit = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
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
                center: Alignment(0.0, -0.1),
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
                  height: 35.65.h,
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
                          height: 10.08.h,
                        ),
                        text(
                          "Log In",
                          textColor: Color(0xffffffff),
                          fontSize: 27.sp,
                          fontFamily: fontMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(top: 25.h),
                  width: 83.33.w,
                  height: 30.96.h,
                  decoration: boxDecoration(
                      radius: 50.0,
                      bgColor: Color(0xffffffff),
                      showShadow: true),
                  child: firstSign(context),
                ),
                Container(
                  // alignment: Alignment.bottomCenter,
                  margin: EdgeInsets.only(top: 72.81.h, bottom: 8.h),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        edit = true;
                      });
                      await Future.delayed(Duration(milliseconds: 200));
                      setState(() {
                        edit = false;
                      });
                      navigateScreen(context, SignUpScreen());
                    },
                    child: RichText(
                      text: new TextSpan(
                        text: "Don't Have An Account? ",
                        style: TextStyle(
                          color: Color(0xff171717),
                          fontSize: 10.sp,
                          fontFamily: fontBold,
                        ),
                        children: <TextSpan>[
                          new TextSpan(
                            text: 'SignUp',
                            style: TextStyle(
                              color: Color(0xffF4B71E),
                              fontSize: 10.sp,
                              fontFamily: fontBold,
                            ),
                          ),
                        ],
                      ),
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
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 6.05.h,
          ),
          Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 69.99.w,
                    height: 80,
                    child: TextFormField(
                      maxLength: 10,
                      cursorColor: Colors.red,
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      style: TextStyle(
                        color: AppColor().colorTextFour(),
                        fontSize: 10.sp,
                      ),
                      inputFormatters: [],
                      decoration: InputDecoration(
                        counterText: '',
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
                        fillColor: AppColor().colorEdit(),
                        enabled: true,
                        filled: true,
                        prefixIcon: Container(
                          padding: EdgeInsets.all(4.0.w),
                          child: Image.asset(
                            "assets/images/phone.png",
                            width: 1.04.w,
                            height: 1.04.w,
                            color: Color(0xffF4B71E),
                            fit: BoxFit.fill,
                          ),
                        ),
                        helperText: '',
                        suffixIcon: phoneController.text.length == 10
                            ? Icon(
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
                    height: 1.55.h,
                  ),
                  /* Container(
                    width: 69.99.w,
                    height: 9.46.h,
                    child: TextFormField(
                      cursorColor: Colors.red,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: passController,
                      style:TextStyle(
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
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: AppColor().colorTextFour(),
                          fontSize: 10.sp,
                        ),
                        fillColor: AppColor().colorEdit() ,
                        enabled: true,
                        filled: true,
                        helperText: '',
                        prefixIcon:  Padding(
                          padding: EdgeInsets.all(4.0.w),
                          child: Image.asset(
                            "assets/images/lock.png",
                            width: 2.04.w,
                            height:  2.04.w,
                            color: Color(0xffF4B71E),
                            fit: BoxFit.fill,
                          ),
                        ),
                        suffixIcon: passController.text.length>5
                            ? Icon(
                              Icons.check,
                              color: AppColor().colorPrimary(),
                              size: 10.sp,
                            )
                            : SizedBox(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColor().colorEdit(), width: 5.0),
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      navigateScreen(context, ForgetScreen());
                    },
                    child: Container(
                      width: 69.99.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          text(
                            "Forgot Password ?",
                            textColor: AppColor().colorTextThird(),
                            fontSize: 10.sp,
                            fontFamily: fontMedium,
                          ),
                        ],
                      ),
                    ),
                  )*/
                ],
              ),
            ),
          ),
          // SizedBox(
          //   height:4.75.h,
          // ),
          Center(
            child: InkWell(
              onTap: () async {
                setState(() {
                  enabled = true;
                });
                await Future.delayed(Duration(milliseconds: 200));
                setState(() {
                  enabled = false;
                });
                if (validateMob(
                        phoneController.text,
                        getTranslated(context, 'MOB_REQUIRED'),
                        getTranslated(context, 'VALID_MOB')) !=
                    null) {
                  setSnackbar(validateMob(
                          phoneController.text,
                          getTranslated(context, 'MOB_REQUIRED'),
                          getTranslated(context, 'VALID_MOB'))
                      .toString());
                  return;
                }
                // if(validatePass(
                //     passController.text,
                //     getTranslated(context, 'PWD_REQUIRED'),
                //     getTranslated(context, 'PWD_LENGTH'))!=null){
                //   setSnackbar(validatePass(
                //       passController.text,
                //       getTranslated(context, 'PWD_REQUIRED'),
                //       getTranslated(context, 'PWD_LENGTH')).toString());
                //   return;
                // }
                setState(() {
                  status = true;
                });
                checkNetwork();
                // Navigator.push(context, MaterialPageRoute(builder: (context) => OtpScreen()));
              },
              child: !status
                  ? Container(
                      width: 69.99.w,
                      height: 6.46.h,
                      decoration: boxDecoration(
                          radius: 15.0, bgColor: AppColor().colorPrimaryDark()),
                      child: Center(
                        child: text(
                          "Get OTP",
                          textColor: Color(0xffffffff),
                          fontSize: 14.sp,
                          fontFamily: fontRegular,
                        ),
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
          ),
          SizedBox(
            height: 6.53.h,
          ),
        ],
      ),
    );
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
      ),
      backgroundColor: Theme.of(context).colorScheme.lightWhite,
      elevation: 1.0,
    ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  String? countryName;
  FocusNode? passFocus, monoFocus = FocusNode();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool visible = false;
  String? password,
      mobile,
      username,
      email,
      id,
      mobileno,
      city,
      area,
      pincode,
      address,
      latitude,
      longitude,
      image;
  bool _isNetworkAvail = true;
  Future<void> checkNetwork() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      getLoginUser();
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        if (mounted)
          setState(() {
            _isNetworkAvail = false;
            status = false;
          });
      });
    }
  }

  /*Future<void> getLoginUser() async {
    var data = {MOBILE: phoneController.text, PASSWORD: passController.text};

    Response response =
    await post(getUserLoginApi, body: data, headers: headers)
        .timeout(Duration(seconds: timeOut));
    var getdata = json.decode(response.body);
    print(response.body);
    bool error = getdata["error"];
    String? msg = getdata["message"];
    setState(() {
      status =false;
    });
    if (!error) {
      setSnackbar(msg!);
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

      UserProvider userProvider =
      Provider.of<UserProvider>(this.context, listen: false);
      userProvider.setName(username ?? "");
      userProvider.setEmail(email ?? "");
      userProvider.setProfilePic(image ?? "");

      SettingProvider settingProvider =
      Provider.of<SettingProvider>(context, listen: false);

      settingProvider.saveUserDetail(id!, username, email, mobile, city, area,
          address, pincode, latitude, longitude, image, context);

      Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
    } else {
      setSnackbar(msg!);
    }
  }*/
  Future<void> getLoginUser() async {
    var data = {MOBILE: phoneController.text};

    Response response =
        await post(getUserLoginWithOtpApi, body: data, headers: headers)
            .timeout(Duration(seconds: timeOut));
    var getdata = json.decode(response.body);
    print(response.body);
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

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OtpScreen(
                    otp: getdata["otp"].toString(),
                    title: "Log In",
                    mobileNumber: phoneController.text,
                    countryCode: "91",
                    i: i,
                  )));
      // Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
    } else {
      setSnackbar(" ${msg!}");
    }
  }
}
