
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/ApiBaseHelper.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Session.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/my_new_helper.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';


class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({Key? key}) : super(key: key);

  @override
  _ViewProfileScreenState createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController cPassController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController aadharController = new TextEditingController();
  TextEditingController addController = new TextEditingController();
  int selectedIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  var isDarkTheme;
  bool isDark = false;
  List<String> langCode = ["en", "zh", "es", "hi", "ar", "ru", "ja", "de"];
  List<String?> themeList = [];
  List<String?> languageList = [];
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  int? selectLan, curTheme;
  TextEditingController? curPassC, newPassC, confPassC;
  String? curPass, newPass, confPass, mobile;
  bool _showPassword = false, _showNPassword = false, _showCPassword = false;

  final GlobalKey<FormState> _changePwdKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _changeUserDetailsKey = GlobalKey<FormState>();
  final confirmpassController = TextEditingController();
  final newpassController = TextEditingController();
  final passwordController = TextEditingController();
  String? currentPwd, newPwd, confirmPwd;
  FocusNode confirmPwdFocus = FocusNode();

  bool _isNetworkAvail = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool status = false;
  bool selected = false, enabled = false, edit1 = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    changePage();
  }

  changePage() async {
    await Future.delayed(Duration(milliseconds: 2000));
    setState(() {
      status = true;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeInOut,
            width: 100.w,
            padding: MediaQuery.of(context).viewInsets,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: EdgeInsets.only(top: 18.h),
                  width: 99.33.w,
                  height:  72.05.h,
                  color: Colors.transparent,
                  child: firstSign(context),
                ),
                Container(
                  height: 17.89.h,
                  width: 100.w,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(top: 3.h),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/new_img/login_option.png"),
                        fit: BoxFit.fill,
                      )),
                  child:  Row(
                    children: [
                      Container(
                          width: 6.38.w,
                          height: 6.38.w,
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 7.91.w),
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
                        width: 2.08.h,
                      ),
                      Container(
                        width: 65.w,
                        child: text(
                            "My Profile",
                            textColor: Color(0xffffffff),
                            fontSize: 14.sp,
                            fontFamily: fontMedium,
                            isCentered: true
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10.49.h,
                  child:  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 14.66.h,
                        width: 14.66.h,
                        child: Selector<UserProvider, String>(
                            selector: (_, provider) => provider.profilePic,
                            builder: (context, profileImage, child) {
                              return getUserImage(
                                  profileImage, openChangeUserDetailsBottomSheet);
                            }),
                      ),
                      /*InkWell(
                        onTap: (){
                          openChangeUserDetailsBottomSheet();
                        },
                        child: Container(
                          height: 4.39.h,
                          width: 4.39.h,
                          margin: EdgeInsets.only(right: 5.w,bottom: 1.h),
                          decoration: boxDecoration(radius: 100,bgColor: Color(0xffF4B71E)),
                          child: Center(
                            child: Image.asset(
                              "assets/images/drawer/edit.png",
                              height: 2.26.h,
                              width: 2.26.h,
                            ),
                          ),
                        ),
                      ),*/
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 9.92.h,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: boxDecoration(radius: 10,bgColor: Theme.of(context).cardColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 1.02.h,
              ),
              /*Padding(
                padding:  EdgeInsets.symmetric(horizontal:getWidth(30)),
                child: text(
                  "Profile Details",
                  textColor: Theme.of(context).colorScheme.fontColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: fontBold,
                ),
              ),*/
              SizedBox(
                height: 2.02.h,
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 5.5.w, right: 5.5.w, bottom: 1.87.h),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        text(
                          "Name",
                          textColor:  Theme.of(context).colorScheme.fontColor,
                          fontSize: 10.sp,
                          fontFamily: fontRegular,
                        ),
                        SizedBox(
                          height: 1.02.h,
                        ),
                        text(
                          "Email",
                          textColor:  Theme.of(context).colorScheme.fontColor,
                          fontSize: 10.sp,
                          fontFamily: fontRegular,
                        ),
                        SizedBox(
                          height: 1.02.h,
                        ),
                        text(
                          "Mobile Number",
                          textColor:  Theme.of(context).colorScheme.fontColor,
                          fontSize: 10.sp,
                          fontFamily: fontRegular,
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector<UserProvider, String>(
                            selector: (_, provider) => provider.curUserName,
                            builder: (context, userName, child) {
                              nameController = TextEditingController(text: userName);
                              return  text(
                                userName == ""
                                    ? getTranslated(context, 'GUEST')!
                                    : userName,
                                textColor:  Theme.of(context).colorScheme.fontColor,
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                              );
                            }),
                        SizedBox(
                          height: 1.02.h,
                        ),
                        Selector<UserProvider, String>(
                            selector: (_, provider) => provider.email,
                            builder: (context, userEmail, child) {
                              emailController =
                                  TextEditingController(text: userEmail);
                              return userEmail != ""
                                  ?  Container(
                                    child: text(
                                userEmail,
                                textColor:  Theme.of(context).colorScheme.fontColor,
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                                maxLine: 2,
                              ),
                                  )
                                  : text(
                                "",
                                textColor:  Theme.of(context).colorScheme.fontColor,
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                              );
                            }),
                        SizedBox(
                          height: 1.02.h,
                        ),
                        Selector<UserProvider, String>(
                            selector: (_, provider) => provider.mob,
                            builder: (context, userMobile, child) {
                              return userMobile != ""
                                  ? text(
                                userMobile,
                                textColor:  Theme.of(context).colorScheme.fontColor,
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                              )
                                  : text(
                                "",
                                textColor:  Theme.of(context).colorScheme.fontColor,
                                fontSize: 10.sp,
                                fontFamily: fontBold,
                              );
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              /*Container(
                margin: EdgeInsets.only(
                    left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                      "User Name",
                      textColor:  Theme.of(context).colorScheme.fontColor,
                      fontSize: 10.sp,
                      fontFamily: fontRegular,
                    ),
                    Selector<UserProvider, String>(
                        selector: (_, provider) => provider.curUserName,
                        builder: (context, userName, child) {
                          nameController = TextEditingController(text: userName);
                          return  text(
                            userName == ""
                                ? getTranslated(context, 'GUEST')!
                                : userName,
                            textColor:  Theme.of(context).colorScheme.fontColor,
                            fontSize: 10.sp,
                            fontFamily: fontBold,
                          );
                        }),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                      "Email",
                      textColor:  Theme.of(context).colorScheme.fontColor,
                      fontSize: 10.sp,
                      fontFamily: fontRegular,
                    ),
                    Selector<UserProvider, String>(
                        selector: (_, provider) => provider.email,
                        builder: (context, userEmail, child) {
                          emailController =
                              TextEditingController(text: userEmail);
                          return userEmail != ""
                              ?  text(
                            userEmail,
                            textColor:  Theme.of(context).colorScheme.fontColor,
                            fontSize: 10.sp,
                            fontFamily: fontBold,
                          )
                              : text(
                            "",
                            textColor:  Theme.of(context).colorScheme.fontColor,
                            fontSize: 10.sp,
                            fontFamily: fontBold,
                          );
                        }),

                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 8.33.w, right: 8.33.w, bottom: 1.87.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    text(
                      "Mobile Number",
                      textColor:  Theme.of(context).colorScheme.fontColor,
                      fontSize: 10.sp,
                      fontFamily: fontRegular,
                    ),
                    Selector<UserProvider, String>(
                        selector: (_, provider) => provider.mob,
                        builder: (context, userMobile, child) {
                          return userMobile != ""
                              ? text(
                            userMobile,
                            textColor:  Theme.of(context).colorScheme.fontColor,
                            fontSize: 10.sp,
                            fontFamily: fontBold,
                          )
                              : text(
                            "",
                            textColor:  Theme.of(context).colorScheme.fontColor,
                            fontSize: 10.sp,
                            fontFamily: fontBold,
                          );
                        }),
                  ],
                ),
              ),*/
              SizedBox(
                height: 3.02.h,
              ),
            ],
          ),
        ),

        SizedBox(
          height: 3.02.h,
        ),
        Center(
          child: Container(
            child: InkWell(
              onTap: () async {
                openChangeUserDetailsBottomSheet();
                  },
              child: Container(
                width: 69.99.w,
                height: 6.46.h,
                decoration: boxDecoration(
                    radius: 15.0, bgColor: colors.primary),
                child: Center(
                  child: text(
                    "Edit Profile",
                    textColor: Color(0xffffffff),
                    fontSize: 14.sp,
                    fontFamily: fontRegular,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 1.46.h,
        ),

      ],
    );
  }
  Widget getUserImage(String profileImage, VoidCallback? onBtnSelected) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (mounted) {
              onBtnSelected!();
            }
          },
          child: Container(
            // margin: EdgeInsetsDirectional.only(end: 20),
            height: 14.66.h,
            width: 14.66.h,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 1.0, color: Theme.of(context).colorScheme.fontColor)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child:
              Consumer<UserProvider>(builder: (context, userProvider, _) {
                return userProvider.profilePic != ''
                    ? new FadeInImage(
                  fadeInDuration: Duration(milliseconds: 150),
                  image:
                  CachedNetworkImageProvider(userProvider.profilePic),
                  height: 14.66.h,
                  width: 14.66.h,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(64),
                  placeholder: placeHolder(10.66.h),
                )
                    : imagePlaceHolder(10.66.h, context);
              }),
            ),
          ),
        ),
        /*CircleAvatar(
      radius: 40,
      backgroundColor: colors.primary,
      child: profileImage != ""
          ? ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: FadeInImage(
                fadeInDuration: Duration(milliseconds: 150),
                image: NetworkImage(profileImage),
                height: 100.0,
                width: 100.0,
                fit: BoxFit.cover,
                placeholder: placeHolder(100),
                imageErrorBuilder: (context, error, stackTrace) =>
                    erroWidget(100),
              ))
          : Icon(
              Icons.account_circle,
              size: 80,
              color: Theme.of(context).colorScheme.fontColor,
            ),
    ),*/
        if (CUR_USERID != null)
          Positioned.directional(
              textDirection: Directionality.of(context),
              end: 20,
              bottom: 5,
              child: Container(
                height: 20,
                width: 20,
                child: InkWell(
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.fontColor,
                    size: 10,
                  ),
                  onTap: () {
                    if (mounted) {
                      onBtnSelected!();
                    }
                  },
                ),
                decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.all(color: colors.primary)),
              )),
      ],
    );
  }
  void openChangeUserDetailsBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _changeUserDetailsKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    bottomSheetHandle(),
                    bottomsheetLabel("EDIT_PROFILE_LBL"),
                    Selector<UserProvider, String>(
                        selector: (_, provider) => provider.profilePic,
                        builder: (context, profileImage, child) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: getUserImage(profileImage, _imgFromGallery),
                          );
                        }),
                    Selector<UserProvider, String>(
                        selector: (_, provider) => provider.curUserName,
                        builder: (context, userName, child) {
                          return setNameField(userName);
                        }),
                    Selector<UserProvider, String>(
                        selector: (_, provider) => provider.email,
                        builder: (context, userEmail, child) {
                          return setEmailField(userEmail);
                        }),
                    saveButton(getTranslated(context, "SAVE_LBL")!, () {
                      validateAndSave(_changeUserDetailsKey);
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget bottomSheetHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme.of(context).colorScheme.lightBlack),
        height: 5,
        width: MediaQuery.of(context).size.width * 0.3,
      ),
    );
  }

  Widget bottomsheetLabel(String labelName) => Padding(
    padding: const EdgeInsets.only(top: 30.0, bottom: 20),
    child: getHeading(labelName),
  );

  void _imgFromGallery() async {
    var result = await FilePicker.platform.pickFiles();
    if (result != null) {
      var image = File(result.files.single.path!);
      if (mounted) {
        await setProfilePic(image);
      }
    } else {
      // User canceled the picker
    }
  }

  Future<void> setProfilePic(File _image) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var image;
        var request = http.MultipartRequest("POST", (getUpdateUserApi));
        request.headers.addAll(headers);
        request.fields[USER_ID] = CUR_USERID!;
        var pic = await http.MultipartFile.fromPath(IMAGE, _image.path);
        request.files.add(pic);
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var getdata = json.decode(responseString);
        bool error = getdata["error"];
        String? msg = getdata['message'];
        print("msg :$msg");
        print(
            " detail : ${pic.field}, ${pic.length} , ${pic.filename} , ${pic.contentType} , ${pic.toString()}");
        if (!error) {
          var data = getdata["data"];
          for (var i in data) {
            image = i[IMAGE];
          }
          var settingProvider =
          Provider.of<SettingProvider>(context, listen: false);
          settingProvider.setPrefrence(IMAGE, image!);
          var userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setProfilePic(image!);
          setSnackbar(getTranslated(context, 'PROFILE_UPDATE_MSG')!);
        } else {
          setSnackbar(msg!);
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!);
      }
    } else {
      if (mounted) {
        setState(() {
          _isNetworkAvail = false;
        });
      }
    }
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
  Widget setNameField(String userName) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
    child: Container(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: TextFormField(
          //initialValue: nameController.text,
          style: TextStyle(
              color: Theme.of(context).colorScheme.fontColor,
              fontWeight: FontWeight.bold),
          controller: nameController,
          decoration: InputDecoration(
              label: Text(
                getTranslated(
                  context,
                  "NAME_LBL",
                )!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              fillColor: Theme.of(context).cardColor,
              border: InputBorder.none),
          validator: (val) => validateUserName(
              val!,
              getTranslated(context, 'USER_REQUIRED'),
              getTranslated(context, 'USER_LENGTH')),
        ),
      ),
    ),
  );

  Widget setEmailField(String email) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
    child: Container(
      padding:
      EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: TextFormField(
          style: TextStyle(
              color: Theme.of(context).colorScheme.fontColor,
              fontWeight: FontWeight.bold),
          controller: emailController,
          decoration: InputDecoration(
              label: Text(
                getTranslated(context, "EMAILHINT_LBL")!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              fillColor: Theme.of(context).cardColor,
              border: InputBorder.none),
          validator: (val) => validateEmail(
              val!,
              getTranslated(context, 'EMAIL_REQUIRED'),
              getTranslated(context, 'VALID_EMAIL')),
        ),
      ),
    ),
  );

  Widget saveButton(String title, VoidCallback? onBtnSelected) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: MaterialButton(
              height: 45.0,
              textColor: Theme.of(context).colorScheme.fontColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              onPressed: onBtnSelected,
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.fontColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              color: colors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> validateAndSave(GlobalKey<FormState> key) async {
    final form = key.currentState!;
    form.save();
    if (form.validate()) {
      if (key == _changePwdKey) {
        await setUpdateUser(CUR_USERID!, passwordController.text,
            newpassController.text, "", "");
        passwordController.clear();
        newpassController.clear();
        passwordController.clear();
        confirmpassController.clear();
      } else if (key == _changeUserDetailsKey) {
        setUpdateUser(
            CUR_USERID!, "", "", nameController.text, emailController.text);
      }
      return true;
    }
    return false;
  }

  Future<void> setUpdateUser(String userID,
      [oldPwd, newPwd, username, userEmail]) async {
    var apiBaseHelper = ApiBaseHelper();
    var data = {USER_ID: userID};
    if ((oldPwd != "") && (newPwd != "")) {
      data[OLDPASS] = oldPwd;
      data[NEWPASS] = newPwd;
    } else if ((username != "") && (userEmail != "")) {
      data[USERNAME] = username;
      data[EMAIL] = userEmail;
    }

    final result = await apiBaseHelper.postAPICall(getUpdateUserApi, data);

    bool error = result["error"];
    String? msg = result["message"];

    Navigator.of(context).pop();
    if (!error) {
      var settingProvider =
      Provider.of<SettingProvider>(context, listen: false);
      var userProvider = Provider.of<UserProvider>(context, listen: false);

      if ((username != "") && (userEmail != "")) {
        settingProvider.setPrefrence(USERNAME, username);
        userProvider.setName(username);
        settingProvider.setPrefrence(EMAIL, userEmail);
        userProvider.setEmail(userEmail);
      }

      setSnackbar(getTranslated(context, 'USER_UPDATE_MSG')!);
    } else {
      setSnackbar(msg!);
    }
  }
  Widget getHeading(String title) {
    return Text(
      getTranslated(context, title)!,
      style: Theme.of(context).textTheme.headline6!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.fontColor),
    );
  }
}
