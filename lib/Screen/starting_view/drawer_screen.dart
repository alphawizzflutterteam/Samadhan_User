import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:samadhaan_user/Helper/ApiBaseHelper.dart';
import 'package:samadhaan_user/Helper/Color.dart';
import 'package:samadhaan_user/Helper/Constant.dart';
import 'package:samadhaan_user/Helper/Session.dart';
import 'package:samadhaan_user/Helper/String.dart';
import 'package:samadhaan_user/Helper/my_new_helper.dart';
import 'package:samadhaan_user/Provider/SettingProvider.dart';
import 'package:samadhaan_user/Provider/Theme.dart';
import 'package:samadhaan_user/Provider/UserProvider.dart';
import 'package:samadhaan_user/Screen/Customer_Support.dart';
import 'package:samadhaan_user/Screen/Faqs.dart';
import 'package:samadhaan_user/Screen/Login.dart';
import 'package:samadhaan_user/Screen/MyOrder.dart';
import 'package:samadhaan_user/Screen/MyTransactions.dart';
import 'package:samadhaan_user/Screen/My_Wallet.dart';
import 'package:samadhaan_user/Screen/Privacy_Policy.dart';
import 'package:samadhaan_user/Screen/ReferEarn.dart';
import 'package:samadhaan_user/Screen/RefundPolicy.dart';
import 'package:samadhaan_user/Screen/SendOtp.dart';
import 'package:samadhaan_user/Screen/starting_view/login_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../main.dart';
import '../Manage_Address.dart';
import 'package:http/http.dart' as http;

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  int selectedIndex = 0;
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final InAppReview _inAppReview = InAppReview.instance;
  var isDarkTheme;
  bool isDark = false;
  late ThemeNotifier themeNotifier;
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
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? currentPwd, newPwd, confirmPwd;
  FocusNode confirmPwdFocus = FocusNode();

  bool _isNetworkAvail = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    new Future.delayed(Duration.zero, () {
      languageList = [
        getTranslated(context, 'ENGLISH_LAN'),
        getTranslated(context, 'CHINESE_LAN'),
        getTranslated(context, 'SPANISH_LAN'),
        getTranslated(context, 'HINDI_LAN'),
        getTranslated(context, 'ARABIC_LAN'),
        getTranslated(context, 'RUSSIAN_LAN'),
        getTranslated(context, 'JAPANISE_LAN'),
        getTranslated(context, 'GERMAN_LAN')
      ];

      themeList = [
        getTranslated(context, 'SYSTEM_DEFAULT'),
        getTranslated(context, 'LIGHT_THEME'),
        getTranslated(context, 'DARK_THEME')
      ];

      _getSaved();
    });
    super.initState();
  }

  _getSaved() async {
    SettingProvider settingsProvider =
        Provider.of<SettingProvider>(this.context, listen: false);
    //String get = await settingsProvider.getPrefrence(APP_THEME) ?? '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? get = prefs.getString(APP_THEME);
    curTheme = themeList.indexOf(get == '' || get == DEFAULT_SYSTEM
        ? getTranslated(context, 'SYSTEM_DEFAULT')
        : get == LIGHT
            ? getTranslated(context, 'LIGHT_THEME')
            : getTranslated(context, 'DARK_THEME'));

    String getlng = await settingsProvider.getPrefrence(LAGUAGE_CODE) ?? '';
    selectLan = langCode.indexOf(getlng == '' ? "en" : getlng);
    if (mounted) setState(() {});
  }

  List<Widget> getLngList(BuildContext ctx, StateSetter setModalState) {
    return languageList
        .asMap()
        .map(
          (index, element) => MapEntry(
              index,
              InkWell(
                onTap: () {
                  if (mounted)
                    setState(() {
                      selectLan = index;
                      _changeLan(langCode[index], ctx);
                    });
                  setModalState(() {});
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 25.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selectLan == index
                                    ? colors.grad2Color
                                    : Theme.of(context).colorScheme.fontColor,
                                border: Border.all(color: colors.grad2Color)),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: selectLan == index
                                  ? Icon(
                                      Icons.check,
                                      size: 17.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor,
                                    )
                                  : Icon(
                                      Icons.check_box_outline_blank,
                                      size: 15.0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor,
                                    ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 15.0,
                              ),
                              child: Text(
                                languageList[index]!,
                                style: Theme.of(this.context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .lightBlack),
                              ))
                        ],
                      ),
                      // index == languageList.length - 1
                      //     ? Container(
                      //         margin: EdgeInsetsDirectional.only(
                      //           bottom: 10,
                      //         ),
                      //       )
                      //     : Divider(
                      //         color: Theme.of(context).colorScheme.lightBlack,
                      //       ),
                    ],
                  ),
                ),
              )),
        )
        .values
        .toList();
  }

  void _changeLan(String language, BuildContext ctx) async {
    Locale _locale = await setLocale(language);

    MyApp.setLocale(ctx, _locale);
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

  List<Widget> themeListView(BuildContext ctx) {
    return themeList
        .asMap()
        .map(
          (index, element) => MapEntry(
              index,
              InkWell(
                onTap: () {
                  _updateState(index, ctx);
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 25.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: curTheme == index
                                  ? colors.grad2Color
                                  : Theme.of(context).colorScheme.fontColor,
                              border: Border.all(color: colors.grad2Color),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: curTheme == index
                                    ? Icon(
                                        Icons.check,
                                        size: 17.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fontColor,
                                      )
                                    : Icon(
                                        Icons.check_box_outline_blank,
                                        size: 15.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fontColor,
                                      )),
                          ),
                          Padding(
                              padding: EdgeInsetsDirectional.only(
                                start: 15.0,
                              ),
                              child: Text(
                                themeList[index]!,
                                style: Theme.of(ctx)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .lightBlack),
                              ))
                        ],
                      ),
                      // index == themeList.length - 1
                      //     ? Container(
                      //         margin: EdgeInsetsDirectional.only(
                      //           bottom: 10,
                      //         ),
                      //       )
                      //     : Divider(
                      //         color: Theme.of(context).colorScheme.lightBlack,
                      //       )
                    ],
                  ),
                ),
              )),
        )
        .values
        .toList();
  }

  _updateState(int position, BuildContext ctx) {
    curTheme = position;

    onThemeChanged(themeList[position]!, ctx);
  }

  void onThemeChanged(
    String value,
    BuildContext ctx,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value == getTranslated(ctx, 'SYSTEM_DEFAULT')) {
      themeNotifier.setThemeMode(ThemeMode.system);
      prefs.setString(APP_THEME, DEFAULT_SYSTEM);

      var brightness = SchedulerBinding.instance!.window.platformBrightness;
      if (mounted)
        setState(() {
          isDark = brightness == Brightness.dark;
          if (isDark)
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
          else
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        });
    } else if (value == getTranslated(ctx, 'LIGHT_THEME')) {
      themeNotifier.setThemeMode(ThemeMode.light);
      prefs.setString(APP_THEME, LIGHT);
      if (mounted)
        setState(() {
          isDark = false;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        });
    } else if (value == getTranslated(ctx, 'DARK_THEME')) {
      themeNotifier.setThemeMode(ThemeMode.dark);
      prefs.setString(APP_THEME, DARK);
      if (mounted)
        setState(() {
          isDark = true;
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
        });
    }
    ISDARK = isDark.toString();

    //Provider.of<SettingProvider>(context,listen: false).setPrefrence(APP_THEME, value);
  }

  Future<void> _openStoreListing() => _inAppReview.openStoreListing(
        appStoreId: appStoreId,
        microsoftStoreId: 'microsoftStoreId',
      );

  logOutDailog() async {
    await dialogAnimate(context,
        StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          content: Text(
            getTranslated(context, 'LOGOUTTXT')!,
            style: Theme.of(this.context)
                .textTheme
                .subtitle1!
                .copyWith(color: Theme.of(context).colorScheme.fontColor),
          ),
          actions: <Widget>[
            new TextButton(
                child: Text(
                  getTranslated(context, 'NO')!,
                  style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                      color: Theme.of(context).colorScheme.lightBlack,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                }),
            new TextButton(
                child: Text(
                  getTranslated(context, 'YES')!,
                  style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                      color: Theme.of(context).colorScheme.fontColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  SettingProvider settingProvider =
                      Provider.of<SettingProvider>(context, listen: false);
                  settingProvider.clearUserSession(context);
                  //favList.clear();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/home', (Route<dynamic> route) => false);
                })
          ],
        );
      });
    }));
  }

  @override
  Widget build(BuildContext context) {
    languageList = [
      getTranslated(context, 'ENGLISH_LAN'),
      getTranslated(context, 'CHINESE_LAN'),
      getTranslated(context, 'SPANISH_LAN'),
      getTranslated(context, 'HINDI_LAN'),
      getTranslated(context, 'ARABIC_LAN'),
      getTranslated(context, 'RUSSIAN_LAN'),
      getTranslated(context, 'JAPANISE_LAN'),
      getTranslated(context, 'GERMAN_LAN')
    ];
    themeList = [
      getTranslated(context, 'SYSTEM_DEFAULT'),
      getTranslated(context, 'LIGHT_THEME'),
      getTranslated(context, 'DARK_THEME')
    ];

    themeNotifier = Provider.of<ThemeNotifier>(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Theme.of(context).colorScheme.black,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Color(0xffA3C940),
                      Color(0xff0BA84A),
                    ])),
                padding:
                    EdgeInsets.only(left: getWidth(60), right: getWidth(36)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getHeight(53.36),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          Selector<UserProvider, String>(
                              selector: (_, provider) => provider.profilePic,
                              builder: (context, profileImage, child) {
                                return getUserImage(profileImage,
                                    openChangeUserDetailsBottomSheet);
                              }),
                          SizedBox(
                            width: getWidth(19.36),
                          ),
                          Container(
                            width: getWidth(200),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Selector<UserProvider, String>(
                                    selector: (_, provider) =>
                                        provider.curUserName,
                                    builder: (context, userName, child) {
                                      nameController.text = userName;
                                      return Text(
                                        userName == ""
                                            ? getTranslated(context, 'GUEST')!
                                            : userName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .white,
                                            ),
                                      );
                                    }),
                                Selector<UserProvider, String>(
                                    selector: (_, provider) => provider.mob,
                                    builder: (context, userMobile, child) {
                                      return userMobile != ""
                                          ? Text(
                                              userMobile,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2!
                                                  .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .white,
                                                      fontWeight:
                                                          FontWeight.normal),
                                            )
                                          : Container(
                                              height: 0,
                                            );
                                    }),

                                /// show  email section here
                                // Selector<UserProvider, String>(
                                //     selector: (_, provider) => provider.email,
                                //     builder: (context, userEmail, child) {
                                //       emailController =
                                //           TextEditingController(text: userEmail);
                                //       return userEmail != ""
                                //           ? Text(
                                //         userEmail,
                                //         style: Theme.of(context)
                                //             .textTheme
                                //             .subtitle2!
                                //             .copyWith(
                                //             color: Theme.of(context).colorScheme.white,
                                //             fontWeight: FontWeight.normal),
                                //       )
                                //           : Container(
                                //         height: 0,
                                //       );
                                //     }),

                                /* Consumer<UserProvider>(builder: (context, userProvider, _) {
                    print("mobb**${userProvider.profilePic}");
                    return (userProvider.mob != "")
                        ? Text(
                              userProvider.mob,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(color: Theme.of(context).colorScheme.fontColor),
                            )
                        : Container(
                              height: 0,
                            );
                  }),*/
                                Consumer<UserProvider>(
                                    builder: (context, userProvider, _) {
                                  return userProvider.curUserName == ""
                                      ? Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  top: 7),
                                          child: InkWell(
                                            child: Text(
                                                getTranslated(context,
                                                    'LOGIN_REGISTER_LBL')!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption!
                                                    .copyWith(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .white,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    )),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Login(),
                                                  ));
                                            },
                                          ))
                                      : Container();
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: getHeight(53.36),
                    ),
                  ],
                ),
              ),
              Container(
                color: Theme.of(context).cardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boxHeight(20),
                    boxHeight(15),
                    Padding(
                      padding: EdgeInsets.only(left: getWidth(60)),
                      child: text("My Information",
                          fontSize: 12.sp,
                          fontFamily: fontRegular,
                          textColor: Theme.of(context)
                              .colorScheme
                              .black
                              .withOpacity(0.7)),
                    ),
                    boxHeight(25),
                    CUR_USERID == "" || CUR_USERID == null
                        ? Container()
                        : tabItem(context, 1, "assets/images/pro_myorder.svg",
                            getTranslated(context, 'MY_ORDERS_LBL')!),
                    CUR_USERID == "" || CUR_USERID == null
                        ? Container()
                        : tabItem(context, 2, "assets/images/pro_address.svg",
                            getTranslated(context, 'MANAGE_ADD_LBL')!),
                    CUR_USERID == "" || CUR_USERID == null
                        ? Container()
                        : tabItem(context, 3, "assets/images/pro_wh.svg",
                            getTranslated(context, 'MYWALLET')!),
                    CUR_USERID == "" || CUR_USERID == null
                        ? Container()
                        : tabItem(context, 4, "assets/images/pro_th.svg",
                            getTranslated(context, 'MYTRANSACTION')!),
                    tabItem(context, 5, "assets/images/pro_theme.svg",
                        getTranslated(context, 'CHANGE_THEME_LBL')!),
                    tabItem(context, 6, "assets/images/pro_language.svg",
                        getTranslated(context, 'CHANGE_LANGUAGE_LBL')!),
                    // CUR_USERID == "" || CUR_USERID == null
                    //     ? Container()
                    //     : tabItem(context, 7, "assets/images/pro_pass.svg",
                    //         getTranslated(context, 'CHANGE_PASS_LBL')!),
                    boxHeight(25),
                  ],
                ),
              ),
              Container(
                color: Theme.of(context).cardColor.withOpacity(0.9),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boxHeight(15),
                    Padding(
                      padding: EdgeInsets.only(left: getWidth(60)),
                      child: text("Other",
                          fontSize: 12.sp,
                          fontFamily: fontRegular,
                          textColor: Theme.of(context)
                              .colorScheme
                              .black
                              .withOpacity(0.7)),
                    ),
                    boxHeight(18),
                    tabItem(context, 8, "assets/images/pro_customersupport.svg",
                        getTranslated(context, 'CUSTOMER_SUPPORT')!),
                    tabItem(context, 9, "assets/images/pro_aboutus.svg",
                        getTranslated(context, 'ABOUT_LBL')!),
                    tabItem(context, 10, "assets/images/pro_aboutus.svg",
                        getTranslated(context, 'CONTACT_LBL')!),
                    tabItem(context, 11, "assets/images/pro_faq.svg",
                        getTranslated(context, 'FAQS')!),
                    tabItem(context, 12, "assets/images/pro_pp.svg",
                        getTranslated(context, 'PRIVACY')!),
                    tabItem(context, 13, "assets/images/pro_tc.svg",
                        getTranslated(context, 'TERM')!),
                    tabItem(context, 17, "assets/images/pro_tc.svg",
                        getTranslated(context, 'REFUND_POLICY')!),
                    tabItem(context, 19, "assets/images/refer.svg",
                        getTranslated(context, 'REFEREARN')!),
                    boxHeight(18),
                  ],
                ),
              ),
              Container(
                color: Theme.of(context).cardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tabItem(context, 14, "assets/images/pro_rateus.svg",
                        getTranslated(context, 'RATE_US')!),
                    tabItem(context, 15, "assets/images/pro_share.svg",
                        getTranslated(context, 'SHARE_APP')!),
                    CUR_USERID == "" || CUR_USERID == null
                        ? Container()
                        : tabItem(context, 16, "assets/images/delete.svg",
                            getTranslated(context, 'DELETE')!),
                    CUR_USERID == "" || CUR_USERID == null
                        ? Container()
                        : tabItem(context, 18, "assets/images/pro_logout.svg",
                            getTranslated(context, 'LOGOUT')!),
                    boxHeight(35),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tabItem(BuildContext context, var pos, var icon, String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = pos;
        });
        if (pos == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyOrder(),
            ),
          );
        }
        if (pos == 2) {
          CUR_USERID == null
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ))
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageAddress(
                      home: true,
                    ),
                  ));
        }
        if (pos == 3) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyWallet(),
              ));
        }
        if (pos == 4) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionHistory(),
              ));
        }
        if (pos == 5) {
          openChangeThemeBottomSheet();
        }
        if (pos == 6) {
          openChangeLanguageBottomSheet();
        }
        if (pos == 7) {
          openChangePasswordBottomSheet();
        }
        if (pos == 8) {
          CUR_USERID == null
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ))
              : Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CustomerSupport()));
        }
        if (pos == 9) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrivacyPolicy(
                  title: getTranslated(context, 'ABOUT_LBL'),
                ),
              ));
        }
        if (pos == 10) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrivacyPolicy(
                  title: getTranslated(context, 'CONTACT_LBL'),
                ),
              ));
        }

        if (pos == 11) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Faqs(
                  title: getTranslated(context, 'FAQS'),
                ),
              ));
        }
        if (pos == 12) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrivacyPolicy(
                  title: getTranslated(context, 'PRIVACY'),
                ),
              ));
        }
        if (pos == 13) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PrivacyPolicy(
                  title: getTranslated(context, 'TERM'),
                ),
              ));
        }
        if (pos == 14) {
          _openStoreListing();
        }
        if (pos == 15) {
          var str =
              "$appName\n\n${getTranslated(context, 'APPFIND')}$androidLink$packageName\n\n ${getTranslated(context, 'IOSLBL')}\n$iosLink";

          Share.share(str);
        }
        if (pos == 16) {
          deleteAccountDailog();
        }

        if (pos == 18) {
          logOutDailog();
        }
        if (pos == 17) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RefundPolicy(
                        title: getTranslated(context, 'REFUND_POLICY'),
                      )));
        }
        if (pos == 19) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ReferEarn()));
        }
      },
      child: Container(
        padding: EdgeInsets.only(
            left: getWidth(60),
            right: getWidth(36),
            top: getHeight(18),
            bottom: getHeight(18)),
        color: selectedIndex != pos
            ? Colors.transparent
            : Color(0xffF4B71E).withOpacity(0.2),
        alignment: Alignment.center,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: getHeight(32.5),
              height: getHeight(32.5),
              fit: BoxFit.fill,
              color: Color(0xffF4B71E),
            ),
            SizedBox(
              width: getWidth(32.36),
            ),
            text(title,
                fontFamily: fontSemibold,
                fontSize: 10.5.sp,
                textColor: Theme.of(context).colorScheme.black),
          ],
        ),
      ),
    );
  }

  deleteAccountDailog() async {
    await dialogAnimate(context,
        StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          content: Text(
            getTranslated(context, 'DELETE_ACCOUNT')!,
            style: Theme.of(this.context)
                .textTheme
                .subtitle1!
                .copyWith(color: Theme.of(context).colorScheme.fontColor),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(
                  getTranslated(context, 'NO')!,
                  style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                      color: Theme.of(context).colorScheme.lightBlack,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop(false);
                }),
            TextButton(
                child: Text(
                  getTranslated(context, 'YES')!,
                  style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
                      color: Theme.of(context).colorScheme.fontColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  deleteAccount();
                  // SettingProvider settingProvider =
                  // Provider.of<SettingProvider>(context, listen: false);
                  // settingProvider.clearUserSession(context);
                  // //favList.clear();
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //     '/home', (Route<dynamic> route) => false);
                })
          ],
        );
      });
    }));
  }

  deleteAccount() async {
    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/delete_users'));
    request.fields.addAll({'user_id': CUR_USERID.toString()});
    print('-----------${request.fields}___${Uri.parse}______');
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      Fluttertoast.showToast(msg: "${finalResult['message']}");
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      print(response.reasonPhrase);
    }
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
            margin: EdgeInsetsDirectional.only(end: 20),
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 1.0,
                    color: Theme.of(context).colorScheme.fontColor)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child:
                  Consumer<UserProvider>(builder: (context, userProvider, _) {
                return userProvider.profilePic != ''
                    ? new FadeInImage(
                        fadeInDuration: Duration(milliseconds: 150),
                        image:
                            CachedNetworkImageProvider(userProvider.profilePic),
                        height: 64.0,
                        width: 64.0,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            erroWidget(64),
                        placeholder: placeHolder(64),
                      )
                    : imagePlaceHolder(62, context);
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
                          emailController.text = userEmail;
                          return setEmailField(userEmail);
                        }),
                    saveButton(getTranslated(context, "SAVE_LBL")!, () {
                      validateAndSave(_changeUserDetailsKey);
                    }),
                    SizedBox(
                      height: 50,
                    )
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

  Widget getHeading(String title) {
    return Text(
      getTranslated(context, title)!,
      style: Theme.of(context).textTheme.headline6!.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.fontColor),
    );
  }

  void openChangePasswordBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _changePwdKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      bottomSheetHandle(),
                      bottomsheetLabel("CHANGE_PASS_LBL"),
                      setCurrentPasswordField(),
                      setForgotPwdLable(),
                      newPwdField(),
                      confirmPwdField(),
                      saveButton(getTranslated(context, "SAVE_LBL")!, () {
                        validateAndSave(_changePwdKey);
                      }),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  void openChangeLanguageBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _changePwdKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      bottomSheetHandle(),
                      bottomsheetLabel("CHOOSE_LANGUAGE_LBL"),
                      StatefulBuilder(
                        builder:
                            (BuildContext context, StateSetter setModalState) {
                          return SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: getLngList(context, setModalState)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  void openChangeThemeBottomSheet() {
    themeList = [
      getTranslated(context, 'SYSTEM_DEFAULT'),
      getTranslated(context, 'LIGHT_THEME'),
      getTranslated(context, 'DARK_THEME')
    ];

    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0))),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Form(
                  key: _changePwdKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      bottomSheetHandle(),
                      bottomsheetLabel("CHOOSE_THEME_LBL"),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: themeListView(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget setCurrentPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: TextFormField(
            controller: passwordController,
            obscureText: true,
            obscuringCharacter: "*",
            style: TextStyle(
              color: Theme.of(context).colorScheme.fontColor,
            ),
            decoration: InputDecoration(
                label: Text(getTranslated(context, "CUR_PASS_LBL")!),
                fillColor: Theme.of(context).colorScheme.fontColor,
                border: InputBorder.none),
            onSaved: (String? value) {
              currentPwd = value;
            },
            validator: (val) => validatePass(
                val!,
                getTranslated(context, 'PWD_REQUIRED'),
                getTranslated(context, 'PWD_LENGTH')),
          ),
        ),
      ),
    );
  }

  Widget setForgotPwdLable() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: InkWell(
          child: Text(getTranslated(context, "FORGOT_PASSWORD_LBL")!),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SendOtp(
                      title: getTranslated(context, 'FORGOT_PASS_TITLE')
                          .toString(),
                    )));
          },
        ),
      ),
    );
  }

  Widget newPwdField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: TextFormField(
            controller: newpassController,
            obscureText: true,
            obscuringCharacter: "*",
            style: TextStyle(
              color: Theme.of(context).colorScheme.fontColor,
            ),
            decoration: InputDecoration(
                label: Text(getTranslated(context, "NEW_PASS_LBL")!),
                fillColor: Theme.of(context).colorScheme.fontColor,
                border: InputBorder.none),
            onSaved: (String? value) {
              newPwd = value;
            },
            validator: (val) => validatePass(
                val!,
                getTranslated(context, 'PWD_REQUIRED'),
                getTranslated(context, 'PWD_LENGTH')),
          ),
        ),
      ),
    );
  }

  Widget confirmPwdField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
          child: TextFormField(
            controller: confirmpassController,
            focusNode: confirmPwdFocus,
            obscureText: true,
            obscuringCharacter: "*",
            style: TextStyle(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.bold),
            decoration: InputDecoration(
                label: Text(getTranslated(context, "CONFIRMPASSHINT_LBL")!),
                fillColor: Theme.of(context).colorScheme.fontColor,
                border: InputBorder.none),
            validator: (value) {
              if (value!.isEmpty) {
                return getTranslated(context, 'CON_PASS_REQUIRED_MSG');
              }
              if (value != newPwd) {
                confirmpassController.text = "";
                confirmPwdFocus.requestFocus();
                return getTranslated(context, 'CON_PASS_NOT_MATCH_MSG');
              } else {
                return null;
              }
            },
          ),
        ),
      ),
    );
  }
}
