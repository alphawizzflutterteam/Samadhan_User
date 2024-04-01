import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:samadhaan_user/Helper/Color.dart';
import 'package:samadhaan_user/Helper/Constant.dart';
import 'package:samadhaan_user/Helper/Session.dart';
import 'package:samadhaan_user/Helper/String.dart';
import 'package:samadhaan_user/Helper/my_new_helper.dart';
import 'package:samadhaan_user/Model/User.dart';
import 'package:samadhaan_user/Provider/SettingProvider.dart';
import 'package:samadhaan_user/Screen/starting_view/otp_screen.dart';
import 'package:samadhaan_user/Screen/starting_view/utils/colors.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../Model/GetSocityMOdel.dart';
import '../../Model/GetZipCodeModel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String? selectedValue;
  String? selectedpincode;
  bool? _showPassword = false;
  bool visible = false;
  String selectedSociety = "";
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final societycontroller = TextEditingController();
  final socitynameController = TextEditingController();
  final pincodeController = TextEditingController();
  final ccodeController = TextEditingController();
  final passwordController = TextEditingController();
  final referController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  TextEditingController cPassController = new TextEditingController();
  int count = 1;
  bool openSocietySearch = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? name,
      email,
      password,
      mobile,
      id,
      countrycode,
      city,
      area,
      pincode,
      address,
      latitude,
      longitude,
      referCode,
      friendCode;
  FocusNode? nameFocus,
      emailFocus,
      passFocus = FocusNode(),
      referFocus = FocusNode();
  bool _isNetworkAvail = true;
  bool status = false;
  bool selected = false, enabled = false, edit = false;
  List<User> cityList = [];
  List<User> citySearchLIst = [];
  int? selAreaPos = -1, selCityPos = -1;

  List<String> searchResult = [];
  @override
  void initState() {
    super.initState();
    getUserDetails();
    generateReferral();
    callApi();
    // callzipApi();
    _controller = AnimationController(vsync: this);
  }

  Future<void> generateReferral() async {
    String refer = getRandomString(8);

    try {
      var data = {
        REFERCODE: refer,
      };

      Response response =
          await post(validateReferalApi, body: data, headers: headers)
              .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      bool error = getdata["error"];

      if (!error) {
        referCode = refer;
        REFER_CODE = refer;
        if (mounted) setState(() {});
      } else {
        if (count < 5) generateReferral();
        count++;
      }
    } on TimeoutException catch (_) {}
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  getUserDetails() async {
    SettingProvider settingsProvider =
        Provider.of<SettingProvider>(context, listen: false);

    mobile = await settingsProvider.getPrefrence(MOBILE);
    countrycode = await settingsProvider.getPrefrence(COUNTRY_CODE);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
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
                        "Sign Up",
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
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(top: 16.h),
                width: 83.33.w,
                height: 74.14.h,
                decoration:
                    boxDecoration(radius: 20.0, bgColor: Color(0xffffffff)),
                child: firstSign(context),
              ),
              Container(
                margin: EdgeInsets.only(top: 98.35.h, bottom: 8.h),
                child: InkWell(
                  onTap: () async {
                    setState(() {
                      edit = true;
                    });
                    await Future.delayed(Duration(milliseconds: 200));
                    setState(() {
                      edit = false;
                    });
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: new TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        color: Color(0xff171717),
                        fontSize: 10.sp,
                        fontFamily: fontBold,
                      ),
                      children: <TextSpan>[
                        new TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: AppColor().colorPrimary(),
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
    );
  }

  Widget firstSign(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 4.32.h,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: 7.00.w,
                      height: 7.4.h,
                      decoration: BoxDecoration(
                        color: AppColor().colorEdit(),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0)),
                      ),
                      padding: EdgeInsets.only(left: 5),
                      child: Icon(
                        Icons.pin_drop,
                        color: Color(0xffF4B71E),
                      )),
                  Container(
                      width: 62.99.w,
                      height: 7.4.h,
                      decoration: BoxDecoration(
                        color: AppColor().colorEdit(),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8.0),
                            bottomRight: Radius.circular(8.0)),
                      ),
                      padding: EdgeInsets.only(left: 15, right: 20),
                      child: FutureBuilder(
                          future: getZipCodeUser(selectedValue.toString()),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            GetZipCodeModel? getzipcode = snapshot.data;
                            if (snapshot.hasData) {
                              return DropdownButtonFormField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                ),
                                // value: selectedpincode == null ? Text("Select Pincode") : Text("$selectedpincode"),
                                hint: Text(
                                  "Select your pinCode",
                                  // "${getzipcode!.data![0].zipcode}",
                                  style: TextStyle(
                                    color: AppColor().colorTextFour(),
                                    fontSize: 12.sp,
                                  ),
                                ),
                                items: getzipcode!.data!.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id,
                                    child: Text(
                                      value.zipcode!,
                                      style: TextStyle(fontSize: 12.sp),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    // print(
                                    selectedpincode = value.toString();
                                    pincodeController.text = value.toString();
                                  });
                                  print(
                                      "SELECTED PINCODE === $selectedpincode");
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text("No Internet Available!!"));
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          })),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                  width: 69.99.w,
                  // height: 7.0.h,
                  decoration: BoxDecoration(
                    color: AppColor().colorEdit(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.only(left: 0, right: 20),
                  child: FutureBuilder(
                      future: getSocityUser(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        GetSocityMOdel? getsocity = snapshot.data;
                        // selectedValue = "${getsocity!.data![0].name}";
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              TextFormField(
                                cursorColor: Colors.red,
                                keyboardType: TextInputType.text,
                                controller: societycontroller,
                                style: TextStyle(
                                  color: AppColor().colorTextFour(),
                                  fontSize: 12.sp,
                                ),
                                onChanged: (v) {
                                  searchResult.clear();
                                  if (societycontroller.text.isNotEmpty ||
                                      societycontroller.text != null) {
                                    for (int i = 0;
                                        i < getsocity!.data!.length;
                                        i++) {
                                      String datas = getsocity.data![i].name!;
                                      if (datas
                                          .toLowerCase()
                                          .contains(v.toLowerCase())) {
                                        searchResult.add(datas);
                                      }
                                    }
                                    setState(() {
                                      openSocietySearch = true;
                                    });
                                  }
                                  if (societycontroller.text.isEmpty ||
                                      societycontroller.text == null) {
                                    setState(() {
                                      openSocietySearch = false;
                                    });
                                  }
                                },
                                inputFormatters: [],
                                decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(3.5.w),
                                    child: Image.asset(
                                      "assets/images/society.png",
                                      width: 2.04.w,
                                      height: 2.04.w,
                                      fit: BoxFit.fill,
                                      color: Color(0xffF4B71E),
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor().colorEdit(),
                                        width: 1.0,
                                        style: BorderStyle.solid),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                  labelText: 'Search your society',
                                  labelStyle: TextStyle(
                                    color: AppColor().colorTextFour(),
                                    fontSize: 12.sp,
                                  ),
                                  counterText: '',
                                  fillColor: AppColor().colorEdit(),
                                  enabled: true,
                                  filled: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColor().colorEdit(),
                                        width: 5.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                  ),
                                ),
                              ),
                              openSocietySearch == true
                                  ? Container(
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: AppColor().colorEdit(),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListView.builder(
                                          itemCount: searchResult.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (c, i) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 5),
                                              child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedSociety =
                                                          searchResult[i];
                                                      openSocietySearch = false;
                                                    });
                                                    societycontroller.text =
                                                        selectedSociety;
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                        "${searchResult[i]}"),
                                                  )),
                                            );
                                          }),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          );
                          //   DropdownButton(
                          //   underline: SizedBox.shrink(),
                          //     icon:  Padding(
                          //       padding:  EdgeInsets.only(left: 5),
                          //       child: Icon(Icons.arrow_drop_down),
                          //     ),
                          //     hint: Container(
                          //     width: 50.00.w,
                          //     child: Text(
                          //       selectedValue == "" ? "Please select society" : selectedValue! ,
                          //       overflow: TextOverflow.ellipsis,
                          //       maxLines: 1,
                          //       style: TextStyle(
                          //           color: colors.black54, fontSize: 8,overflow: TextOverflow.ellipsis,),
                          //     ),
                          //   ),
                          //   items: getsocity!.data!.map((value) {
                          //     return DropdownMenuItem<String>(
                          //       value: value.id,
                          //       child: Container(
                          //           width: 50.00.w,
                          //           child: Text(value.name!,overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontSize:13),)),
                          //     );
                          //   }).toList(),
                          //       value: selectedValue!,
                          //   onChanged: (String? value) {
                          //     setState(() {
                          //       selectedValue = value;
                          //       callzipApi(selectedValue.toString());
                          //     });
                          //   },
                          // );
                        } else if (snapshot.hasError) {
                          return Center(child: Text("No Internet Available!!"));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      })),
              SizedBox(
                height: 15,
              ),
              // name field
              Container(
                width: 69.99.w,
                height: 9.46.h,
                child: TextFormField(
                  cursorColor: Colors.red,
                  keyboardType: TextInputType.name,
                  controller: firstNameController,
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
                    labelText: 'First Name',
                    labelStyle: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 12.sp,
                    ),
                    counterText: '',
                    fillColor: AppColor().colorEdit(),
                    enabled: true,
                    filled: true,
                    prefixIcon: Container(
                      padding: EdgeInsets.all(3.5.w),
                      child: Image.asset(
                        "assets/images/person.png",
                        width: 1.04.w,
                        height: 1.04.w,
                        color: Color(0xffF4B71E),
                        fit: BoxFit.fill,
                      ),
                    ),
                    suffixIcon: nameController.text.length > 2
                        ? Icon(
                            Icons.check,
                            color: AppColor().colorPrimary(),
                            size: 10.sp,
                          )
                        : SizedBox(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColor().colorEdit(), width: 5.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              Container(
                width: 69.99.w,
                height: 9.46.h,
                child: TextFormField(
                  cursorColor: Colors.red,
                  keyboardType: TextInputType.name,
                  controller: lastNameController,
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
                    labelText: 'Last Name',
                    labelStyle: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 12.sp,
                    ),
                    counterText: '',
                    fillColor: AppColor().colorEdit(),
                    enabled: true,
                    filled: true,
                    prefixIcon: Container(
                      padding: EdgeInsets.all(3.5.w),
                      child: Image.asset(
                        "assets/images/person.png",
                        width: 1.04.w,
                        height: 1.04.w,
                        color: Color(0xffF4B71E),
                        fit: BoxFit.fill,
                      ),
                    ),
                    suffixIcon: nameController.text.length > 2
                        ? Icon(
                            Icons.check,
                            color: AppColor().colorPrimary(),
                            size: 10.sp,
                          )
                        : SizedBox(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColor().colorEdit(), width: 5.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 0.5.h,
              ),
              //
              // email field
              Container(
                width: 69.99.w,
                height: 9.46.h,
                child: TextFormField(
                  cursorColor: Colors.red,
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
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
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 12.sp,
                    ),
                    counterText: '',
                    fillColor: AppColor().colorEdit(),
                    enabled: true,
                    filled: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.5.w),
                      child: Image.asset(
                        "assets/images/email.png",
                        width: 2.04.w,
                        height: 2.04.w,
                        fit: BoxFit.fill,
                        color: Color(0xffF4B71E),
                      ),
                    ),
                    suffixIcon: emailController.text.length > 9
                        ? Icon(
                            Icons.check,
                            color: AppColor().colorPrimary(),
                            size: 12.sp,
                          )
                        : SizedBox(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColor().colorEdit(), width: 5.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 0.5.h,
              ),
              //down/// final socitynameController = TextEditingController();
              Container(
                width: 69.99.w,
                height: 10.56.h,
                child: TextFormField(
                  cursorColor: Colors.red,
                  maxLength: 10,
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
                      fontSize: 12.sp,
                    ),
                    counterText: '',
                    fillColor: AppColor().colorEdit(),
                    enabled: true,
                    filled: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.5.w),
                      child: Image.asset(
                        "assets/images/phone.png",
                        width: 2.04.w,
                        height: 2.04.w,
                        color: Color(0xffF4B71E),
                        fit: BoxFit.fill,
                      ),
                    ),
                    helperText: "",
                    suffixIcon: phoneController.text.length == 10
                        ? Icon(
                            Icons.check,
                            color: AppColor().colorPrimary(),
                            size: 10.sp,
                          )
                        : SizedBox(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColor().colorEdit(), width: 5.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),
              // Container(
              //   width: 69.99.w,
              //   height: 9.46.h,
              //   child:TextFormField(
              //     keyboardType: TextInputType.text,
              //     focusNode: referFocus,
              //     controller: referController,
              //     style: TextStyle(
              //       color: AppColor().colorTextFour(),
              //       fontSize: 10.sp,
              //     ),
              //     onSaved: (String? value) {
              //       friendCode = value;
              //     },
              //     decoration: InputDecoration(
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(
              //             color: AppColor().colorEdit(),
              //             width: 1.0,
              //             style: BorderStyle.solid),
              //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       ),
              //       prefixIcon: Icon(
              //         Icons.card_giftcard_outlined,
              //         color: Theme.of(context).colorScheme.fontColor,
              //         size: 17,
              //       ),
              //       hintText: getTranslated(context, 'REFER'),
              //       hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
              //           color: Theme.of(context).colorScheme.fontColor,
              //           fontWeight: FontWeight.normal),
              //       // filled: true,
              //       // fillColor: Theme.of(context).colorScheme.lightWhite,
              //       contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //       prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 25),
              //       // focusedBorder: OutlineInputBorder(
              //       //   borderSide: BorderSide(color: Theme.of(context).colorScheme.fontColor),
              //       //   borderRadius: BorderRadius.circular(10.0),
              //       // ),
              //       enabledBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(
              //             color: AppColor().colorEdit(), width: 5.0),
              //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       ),
              //     ),
              //   ),
              //
              //
              //
              //   // TextFormField(
              //   //   cursorColor: Colors.red,
              //   //   keyboardType: TextInputType.number,
              //   //   controller: pincodeController,
              //   //   ////vcvcvcvcvcv
              //   //   style: TextStyle(
              //   //     color: AppColor().colorTextFour(),
              //   //     fontSize: 10.sp,
              //   //   ),
              //   //   inputFormatters: [],
              //   //   decoration: InputDecoration(
              //   //     focusedBorder: UnderlineInputBorder(
              //   //       borderSide: BorderSide(
              //   //           color: AppColor().colorEdit(),
              //   //           width: 1.0,
              //   //           style: BorderStyle.solid),
              //   //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //   //     ),
              //   //     labelText: 'Pincode',
              //   //     labelStyle: TextStyle(
              //   //       color: AppColor().colorTextFour(),
              //   //       fontSize: 10.sp,
              //   //     ),
              //   //     counterText: '',
              //   //     fillColor: AppColor().colorEdit(),
              //   //     enabled: true,
              //   //     filled: true,
              //   //     prefixIcon: Padding(
              //   //       padding: EdgeInsets.all(3.5.w),
              //   //       child: Image.asset(
              //   //         "assets/images/phone.png",
              //   //         width: 2.04.w,
              //   //         height: 2.04.w,
              //   //         color: Color(0xffF4B71E),
              //   //         fit: BoxFit.fill,
              //   //       ),
              //   //     ),
              //   //     helperText: "",
              //   //     suffixIcon: pincodeController.text.length == 6
              //   //         ? Icon(
              //   //             Icons.check,
              //   //             color: AppColor().colorPrimary(),
              //   //             size: 10.sp,
              //   //           )
              //   //         : SizedBox(),
              //   //     enabledBorder: UnderlineInputBorder(
              //   //       borderSide: BorderSide(
              //   //           color: AppColor().colorEdit(), width: 5.0),
              //   //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //   //     ),
              //   //   ),
              //   // ),
              // ),

              Container(
                width: 69.99.w,
                height: 9.46.h,
                child: TextFormField(
                  cursorColor: Colors.red,
                  keyboardType: TextInputType.name,
                  controller: referController,
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
                    labelText: 'Referral Code (Optional)',
                    labelStyle: TextStyle(
                      color: AppColor().colorTextFour(),
                      fontSize: 12.sp,
                    ),
                    counterText: '',
                    fillColor: AppColor().colorEdit(),
                    enabled: true,
                    filled: true,
                    prefixIcon: Container(
                      padding: EdgeInsets.all(3.5.w),
                      child: Image.asset(
                        "assets/images/refer.png",
                        width: 1.04.w,
                        height: 1.04.w,
                        color: Color(0xffF4B71E),
                        fit: BoxFit.fill,
                      ),
                    ),
                    suffixIcon: referController.text.length > 10
                        ? Icon(
                            Icons.check,
                            color: AppColor().colorPrimary(),
                            size: 10.sp,
                          )
                        : SizedBox(),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: AppColor().colorEdit(), width: 5.0),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ),
              ),

              // setRefer()
              // Container(
              //   width: 69.99.w,
              //   height: 9.46.h,
              //   child: TextFormField(
              //     cursorColor: Colors.red,
              //     obscureText: true,
              //     keyboardType: TextInputType.visiblePassword,
              //     controller: passwordController,
              //     style: TextStyle(
              //       color: AppColor().colorTextFour(),
              //       fontSize: 10.sp,
              //     ),
              //     inputFormatters: [],
              //     decoration: InputDecoration(
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(
              //             color: AppColor().colorEdit(),
              //             width: 1.0,
              //             style: BorderStyle.solid),
              //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       ),
              //       labelText: 'Password',
              //       labelStyle: TextStyle(
              //         color: AppColor().colorTextFour(),
              //         fontSize: 10.sp,
              //       ),
              //       counterText: '',
              //       fillColor: AppColor().colorEdit(),
              //       enabled: true,
              //       filled: true,
              //       prefixIcon: Padding(
              //         padding: EdgeInsets.all(3.5.w),
              //         child: Image.asset(
              //           "assets/images/lock.png",
              //           width: 2.04.w,
              //           height: 2.04.w,
              //           color: Color(0xffF4B71E),
              //           fit: BoxFit.fill,
              //         ),
              //       ),
              //       suffixIcon: passwordController.text.length > 5
              //           ? Icon(
              //               Icons.check,
              //               color: AppColor().colorPrimary(),
              //               size: 10.sp,
              //             )
              //           : SizedBox(),
              //       enabledBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(
              //             color: AppColor().colorEdit(), width: 5.0),
              //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 0.5.h,
              // ),
              // Container(
              //   width: 69.99.w,
              //   height: 9.46.h,
              //   child: TextFormField(
              //     cursorColor: Colors.red,
              //     obscureText: true,
              //     keyboardType: TextInputType.visiblePassword,
              //     controller: cPassController,
              //     style: TextStyle(
              //       color: AppColor().colorTextFour(),
              //       fontSize: 10.sp,
              //     ),
              //     inputFormatters: [],
              //     decoration: InputDecoration(
              //       focusedBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(
              //             color: AppColor().colorEdit(),
              //             width: 1.0,
              //             style: BorderStyle.solid),
              //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       ),
              //       labelText: 'Confirm Password',
              //       labelStyle: TextStyle(
              //         color: AppColor().colorTextFour(),
              //         fontSize: 10.sp,
              //       ),
              //       counterText: '',
              //       fillColor: AppColor().colorEdit(),
              //       enabled: true,
              //       filled: true,
              //       prefixIcon: Padding(
              //         padding: EdgeInsets.all(3.5.w),
              //         child: Image.asset(
              //           "assets/images/lock.png",
              //           width: 2.04.w,
              //           height: 2.04.w,
              //           fit: BoxFit.fill,
              //           color: Color(0xffF4B71E),
              //         ),
              //       ),
              //       suffixIcon:
              //           cPassController.text == passwordController.text
              //               ? Icon(
              //                   Icons.check,
              //                   color: AppColor().colorPrimary(),
              //                   size: 10.sp,
              //                 )
              //               : SizedBox(),
              //       enabledBorder: UnderlineInputBorder(
              //         borderSide: BorderSide(
              //             color: AppColor().colorEdit(), width: 5.0),
              //         borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 0.5.h,
              // ),
            ],
          ),
          // SizedBox(
          //   height: 2.96.h,
          // ),

          Center(
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
                if (validateUserName(
                        firstNameController.text,
                        getTranslated(context, 'FIRST_REQUIRED'),
                        getTranslated(context, 'USER_LENGTH')) !=
                    null) {
                  setSnackbar(validateUserName(
                          lastNameController.text,
                          getTranslated(context, 'FIRST_REQUIRED'),
                          getTranslated(context, 'USER_LENGTH'))
                      .toString());
                  return;
                }
                if (validateUserName(
                        lastNameController.text,
                        getTranslated(context, 'SECOND_REQUIRED'),
                        getTranslated(context, 'USER_LENGTH')) !=
                    null) {
                  setSnackbar(validateUserName(
                          lastNameController.text,
                          getTranslated(context, 'SECOND_REQUIRED'),
                          getTranslated(context, 'USER_LENGTH'))
                      .toString());
                  return;
                }
                if (validateEmail(
                        emailController.text,
                        getTranslated(context, 'EMAIL_REQUIRED'),
                        getTranslated(context, 'VALID_EMAIL')) !=
                    null) {
                  setSnackbar(validateEmail(
                          emailController.text,
                          getTranslated(context, 'EMAIL_REQUIRED'),
                          getTranslated(context, 'VALID_EMAIL'))
                      .toString());
                  return;
                }
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

                if (validateSocity(
                        societycontroller.text,
                        getTranslated(context, 'SOCITY_REQUIRED'),
                        getTranslated(context, 'SOCITY_LENGTH')) !=
                    null) {
                  setSnackbar(validateSocity(
                          societycontroller.text,
                          getTranslated(context, 'SOCITY_REQUIRED'),
                          getTranslated(context, 'SOCITY_LENGTH'))
                      .toString());
                  return;
                }

                if (validatePincode(pincodeController.text,
                        getTranslated(context, 'PIN_REQUIRED')) !=
                    null) {
                  setSnackbar(validatePincode(pincodeController.text,
                          getTranslated(context, 'PIN_REQUIRED'))
                      .toString());
                  return;
                }

                // if (validatePass(
                //         passwordController.text,
                //         getTranslated(context, 'PWD_REQUIRED'),
                //         getTranslated(context, 'PWD_LENGTH')) !=
                //     null) {
                //   setSnackbar(validatePass(
                //           passwordController.text,
                //           getTranslated(context, 'PWD_REQUIRED'),
                //           getTranslated(context, 'PWD_LENGTH'))
                //       .toString());
                //   return;
                // }
                // if (passwordController.text != cPassController.text) {
                //   setSnackbar("Both Password doesn't match");
                //   return;
                // }
                setState(() {
                  status = true;
                });
                checkNetwork();
                //  Navigator.push(context, PageTransition(child: SignUpScreen(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 500),));
              },
              child: !status
                  ? Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Container(
                        width: 69.99.w,
                        height: 6.46.h,
                        decoration: boxDecoration(
                            radius: 15.0,
                            bgColor: AppColor().colorPrimaryDark()),
                        child: Center(
                          child: text(
                            "Next",
                            textColor: Color(0xffffffff),
                            fontSize: 14.sp,
                            fontFamily: fontRegular,
                          ),
                        ),
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  setRefer() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: 10.0,
        start: 15.0,
        end: 15.0,
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        focusNode: referFocus,
        controller: referController,
        style: TextStyle(
            color: Theme.of(context).colorScheme.fontColor,
            fontWeight: FontWeight.normal),
        onSaved: (String? value) {
          friendCode = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.primary),
            borderRadius: BorderRadius.circular(7.0),
          ),
          prefixIcon: Icon(
            Icons.card_giftcard_outlined,
            color: Theme.of(context).colorScheme.fontColor,
            size: 17,
          ),
          hintText: getTranslated(context, 'REFER'),
          hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: Theme.of(context).colorScheme.fontColor,
              fontWeight: FontWeight.normal),
          // filled: true,
          // fillColor: Theme.of(context).colorScheme.lightWhite,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 25),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Theme.of(context).colorScheme.fontColor),
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.fontColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      if (referCode != null) getRegisterUser();
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

  Future<void> checkNetworkData() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      if (referCode != null) getRegisterUser();
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

  Future<GetSocityMOdel?> getSocityUser() async {
    var request = http.MultipartRequest('GET', getSocityApi);

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();

      print("socity:::::" + str.toString());
      return GetSocityMOdel.fromJson(json.decode(str));
      // print(await response.stream.bytesToString());
    } else {
      return null;
    }
  }

  Future<GetZipCodeModel?> getZipCodeUser(String id) async {
    var request = http.MultipartRequest('POST', getZipCode);
    request.fields.addAll({
      'id': '$id' //$id
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      print("zipcode:::::" + str.toString());
      return GetZipCodeModel.fromJson(json.decode(str));
      // print(await response.stream.bytesToString());
    } else {
      return null;
    }
  }

  Future<void> getRegisterUser() async {
    try {
      var data = {
        MOBILE: phoneController.text,
        NAME: "${firstNameController.text}  ${lastNameController.text}",
        EMAIL: emailController.text,
        SOCITYID: socitynameController.text,
        PINCODE: pincodeController.text,
        REFERCODE: referController.text,
        // PASSWORD: passwordController.text,
        COUNTRY_CODE: "91",
      };
      print("Register User Parameter=======" + data.toString());

      Response response =
          await post(getUserSignUpApi, body: data, headers: headers)
              .timeout(Duration(seconds: timeOut));
      print(response.body);
      print('_____SignUpApi_____${getUserSignUpApi}_________');
      print('_____SignUpApi_____${data}_________');
      var getdata = json.decode(response.body);
      bool error = getdata["error"];
      String? msg = getdata["message"];
      setState(() {
        status = false;
      });
      if (!error) {
        setSnackbar(getTranslated(context, 'REGISTER_SUCCESS_MSG')!);
        var i = getdata["data"][0];
        print(i);
        id = i[ID];
        name = i[FIRSTNAME + LASTNAME];
        email = i[EMAIL];
        mobile = i[MOBILE];
        //countrycode=i[COUNTRY_CODE];
        CUR_USERID = id;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpScreen(
                      mobileNumber: mobile!,
                      countryCode: countrycode,
                      otp: getdata["otp"].toString(),
                      title: getTranslated(context, 'SEND_OTP_TITLE'),
                      i: i,
                    )));
        // CUR_USERNAME = name;

        /*   UserProvider userProvider = context.read<UserProvider>();
        userProvider.setName(name ?? "");

        SettingProvider settingProvider = context.read<SettingProvider>();
        settingProvider.saveUserDetail(id!, name, email, mobile, city, area,
            address, pincode, latitude, longitude, "", context);

        Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);*/
      } else {
        setSnackbar(msg!);
      }
      if (mounted) setState(() {});
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, 'somethingMSg')!);
      setState(() {
        status = false;
      });
    }
  }

  Future<void> callApi() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      await getSocityUser();
      // if (widget.update!) {
      //   getArea(addressList[widget.index!].cityId, false);
      // }
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
      });
    }
  }

  Future<void> callzipApi(String id) async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      await getZipCodeUser(id);
      // if (widget.update!) {
      //   getArea(addressList[widget.index!].cityId, false);
      // }
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        if (mounted) {
          setState(() {
            _isNetworkAvail = false;
          });
        }
      });
    }
  }

  // Future<void> get() async {
  //   try {
  //     Response response = await post(getSocity, headers: headers)
  //         .timeout(Duration(seconds: timeOut));
  //
  //     var getdata = json.decode(response.body);
  //     bool error = getdata["error"];
  //     String? msg = getdata["message"];
  //     if (!error) {
  //       var data = getdata["data"];
  //
  //       print("resposne::::" + getdata.toString());
  //
  //       cityList =
  //           (data as List).map((data) => new User.fromJson(data)).toList();
  //
  //       citySearchLIst.addAll(cityList);
  //     } else {
  //       setSnackbar(msg!);
  //     }
  //     // cityLoading = false;
  //     // if (cityState != null) cityState!(() {});
  //     // if (mounted) setState(() {});
  //     //
  //     // if (widget.update!) {
  //     //   selCityPos = citySearchLIst
  //     //       .indexWhere((f) => f.id == addressList[widget.index!].cityId);
  //     //
  //     //   if (selCityPos == -1) selCityPos = null;
  //     // }
  //   } on TimeoutException catch (_) {
  //     setSnackbar(getTranslated(context, 'somethingMSg')!);
  //   }
  // }

//   final Uri getSocity = Uri.parse(baseUrl + 'get_society');
// // https://samadhaan.online/app/v1/api/get_zipcodes
//   final Uri getZipCode = Uri.parse(baseUrl + 'get_zipcodes');

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
      ),
      elevation: 1.0,
      backgroundColor: Theme.of(context).colorScheme.lightWhite,
    ));
  }
}
