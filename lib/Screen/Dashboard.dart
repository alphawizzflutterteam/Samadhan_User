import 'dart:async';
import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/PushNotificationService.dart';
import 'package:eshop_multivendor/Helper/Session.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/app_assets.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Screen/Favorite.dart';
import 'package:eshop_multivendor/Screen/Product_Detail.dart';
import 'package:eshop_multivendor/Screen/starting_view/clipper_path.dart';
import 'package:eshop_multivendor/Screen/starting_view/login_screen.dart';
import 'package:eshop_multivendor/Screen/starting_view/notch_shape.dart';
import 'package:eshop_multivendor/Screen/starting_view/view_profile.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'All_Category.dart';
import 'Cart.dart';
import 'HomePage.dart';
import 'NotificationLIst.dart';
import 'Sale.dart';
import 'Search.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Dashboard> with TickerProviderStateMixin {
  int _selBottom = 0;
  late TabController _tabController;
  bool _isNetworkAvail = true;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    super.initState();
    initDynamicLinks();
    _tabController = TabController(
      length: 5,
      vsync: this,
    );

    final pushNotificationService = PushNotificationService(
        context: context, tabController: _tabController);
    pushNotificationService.initialise();

    _tabController.addListener(
      () {
        Future.delayed(Duration(seconds: 0)).then(
          (value) {
            if (_tabController.index == 3) {
              if (CUR_USERID == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
                _tabController.animateTo(0);
              }
            }
            if (_tabController.index == 4) {
              _tabController.animateTo(0);
              if (CUR_USERID == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
                _tabController.animateTo(0);
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewProfileScreen(),
                  ),
                );

              }
            }
          },
        );

        setState(
          () {
            _selBottom = _tabController.index;
          },
        );
      },
    );
  }

  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.length > 0) {
          int index = int.parse(deepLink.queryParameters['index']!);

          int secPos = int.parse(deepLink.queryParameters['secPos']!);

          String? id = deepLink.queryParameters['id'];

          String? list = deepLink.queryParameters['list'];

          getProduct(id!, index, secPos, list == "true" ? true : false);
        }
      }
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      if (deepLink.queryParameters.length > 0) {
        int index = int.parse(deepLink.queryParameters['index']!);

        int secPos = int.parse(deepLink.queryParameters['secPos']!);

        String? id = deepLink.queryParameters['id'];

        // String list = deepLink.queryParameters['list'];

        getProduct(id!, index, secPos, true);
      }
    }
  }

  Future<void> getProduct(String id, int index, int secPos, bool list) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var parameter = {
          ID: id,
        };

        // if (CUR_USERID != null) parameter[USER_ID] = CUR_USERID;
        Response response =
            await post(getProductApi, headers: headers, body: parameter)
                .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String msg = getdata["message"];
        if (!error) {
          var data = getdata["data"];

          List<Product> items = [];

          items =
              (data as List).map((data) => new Product.fromJson(data)).toList();

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ProductDetail(
                    index: list ? int.parse(id) : index,
                    model: list
                        ? items[0]
                        : sectionList[secPos].productList![index],
                    secPos: secPos,
                    list: list,
                  )));
        } else {
          if (msg != "Products Not Found !") setSnackbar(msg, context);
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      {
        if (mounted)
          setState(() {
            _isNetworkAvail = false;
          });
      }
    }
  }
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget check(context){
    return PhysicalShape(
      elevation: 8,
      color: Colors.transparent,
      clipper: CircularNotchedAndCorneredRectangleClipper(
        shape: CircularNotchedAndCorneredRectangle(
          notchSmoothness: NotchSmoothness.defaultEdge,
          leftCornerRadius:  0,
          rightCornerRadius:  0,
        ),
        geometry: Scaffold.geometryOf(context),
        notchMargin: 8,
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color:  Theme.of(context).cardColor,
        child: SafeArea(
          child: Container(
            height: 76,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: (){
                    _tabController.animateTo(0);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        imagePath + "sel_home.svg",
                        color: colors.primary,
                        width: 32,
                        height: 32,
                      ),
                      Text( getTranslated(context, 'HOME_LBL')!,style:TextStyle(color: Theme.of(context).colorScheme.fontColor,fontSize:10.0),),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    _tabController.animateTo(1);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        imagePath + "category01.svg",
                        color: colors.primary,
                        width: 32,
                        height: 32,
                      ),
                      Text( getTranslated(context, 'category')!,style:TextStyle(color: Theme.of(context).colorScheme.fontColor,fontSize:10.0),),
                    ],
                  ),
                ),
                SizedBox(width: 40,),
                InkWell(
                  onTap: (){
                    _tabController.animateTo(2);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        imagePath + "sale02.svg",
                        color: colors.primary,
                        width: 32,
                        height: 32,
                      ),
                      Text(getTranslated(context, 'SALE')!,style:TextStyle(color: Theme.of(context).colorScheme.fontColor,fontSize:10.0),),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    _tabController.animateTo(4);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        imagePath + "profile01.svg",
                        color: colors.primary,
                        width: 32,
                        height: 32,
                      ),
                      Text( getTranslated(context, 'ACCOUNT')!,style:TextStyle(color: Theme.of(context).colorScheme.fontColor,fontSize:10.0),),
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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_tabController.index != 0) {
          _tabController.animateTo(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Builder(
            builder: (context) {
              return Scaffold(
                key: scaffoldKey,
                backgroundColor: Theme.of(context).colorScheme.lightWhite,
                appBar: _selBottom == 0 ? null : _getAppBar(),
                body: SafeArea(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      HomePage((result){
                        if(result !=null){
                          _tabController.animateTo(1);
                        }
                      }),
                      AllCategory(),
                      Sale(),
                      Cart(
                        fromBottom: true,
                      ),
                      HomePage((result){
                        if(result !=null){
                          _tabController.animateTo(1);
                        }
                      }),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: (){
                    _tabController.animateTo(3);
                  },
                  backgroundColor: colors.primary,
                  child: Selector<UserProvider, String>(
                    builder: (context, data, child) {
                      return Stack(
                        children: [
                          Center(
                            child: _selBottom == 3
                                ? SvgPicture.asset(
                              imagePath + "cart01.svg",
                              color: Colors.white,
                            )
                                : SvgPicture.asset(
                              imagePath + "cart.svg",
                              color: Colors.white,
                            ),
                          ),
                          (data != null && data.isNotEmpty && data != "0")
                              ? new Positioned.directional(
                            bottom: _selBottom == 3 ? 6 : 20,
                            textDirection: Directionality.of(context),
                            end: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors.primary),
                              child: new Center(
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: new Text(
                                    data,
                                    style: TextStyle(
                                        fontSize: 7,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .white),
                                  ),
                                ),
                              ),
                            ),
                          )
                              : Container()
                        ],
                      );
                    },
                    selector: (_, homeProvider) => homeProvider.curCartCount,
                  ),
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: Builder(
                    builder: (context) {
                      return check(context);
                    }
                ),
                //fragments[_selBottom],
                //bottomNavigationBar: _getBottomBar(),
              );
            }
        ),
      ),
    );
  }

  AppBar _getAppBar() {
    String? title;
    if (_selBottom == 1)
      title = getTranslated(context, 'CATEGORY');
    else if (_selBottom == 2)
      title = getTranslated(context, 'OFFER');
    else if (_selBottom == 3)
      title = getTranslated(context, 'MYBAG');
    else if (_selBottom == 4) title = getTranslated(context, 'PROFILE');

    return AppBar(
      centerTitle: _selBottom == 0 ? true : false,
      title: _selBottom == 0
          ? Image.asset(
              MyAssets.normal_logo,
              height: 40,
            )
          : Text(
              title!,
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.normal),
            ),
      flexibleSpace: Image.asset("assets/images/login_option_bg.png",width: 100.w,fit: BoxFit.fill,),
      leading: _selBottom == 0
          ? InkWell(
              child: Center(
                  child: SvgPicture.asset(
                imagePath + "search.svg",
                height: 20,
                color: Colors.white,
              )),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Search(),
                    ));
              },
            )
          : SizedBox(),
      iconTheme: new IconThemeData(color: colors.primary),
      // centerTitle:_curSelected == 0? false:true,
      actions: <Widget>[
        _selBottom == 0
            ? Container()
            : IconButton(
                icon: SvgPicture.asset(
                  imagePath + "search.svg",
                  height: 20,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Search(),
                      ));
                }),
        IconButton(
          icon: SvgPicture.asset(
            imagePath + "desel_notification.svg",
            color: Colors.white,
          ),
          onPressed: () {
            CUR_USERID != null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationList(),
                    ))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ));
          },
        ),
        IconButton(
          padding: EdgeInsets.all(0),
          icon: SvgPicture.asset(
            imagePath + "desel_fav.svg",
            color: Colors.white,
          ),
          onPressed: () {
            CUR_USERID != null
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Favorite(),
                    ))
                : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ));
          },
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.white,
    );
  }






  Widget _getBottomBar() {
    return Material(
        color: Theme.of(context).colorScheme.white,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.white,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).colorScheme.black26, blurRadius: 10)
            ],
          ),
          child: TabBar(
            onTap: (_) {
              if (_tabController.index == 3) {
                if (CUR_USERID == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                  _tabController.animateTo(0);
                }
              }
              if (_tabController.index == 4) {
                if (CUR_USERID == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewProfileScreen(),
                    ),
                  );
                  _tabController.animateTo(0);
                }
              }
            },
            controller: _tabController,
            tabs: [
              Tab(
                icon: _selBottom == 0
                    ? SvgPicture.asset(
                        imagePath + "sel_home.svg",
                        color: colors.primary,
                      )
                    : SvgPicture.asset(
                        imagePath + "desel_home.svg",
                        color: colors.primary,
                      ),
                text:
                    _selBottom == 0 ? getTranslated(context, 'HOME_LBL') : null,
              ),
              Tab(
                icon: _selBottom == 1
                    ? SvgPicture.asset(
                        imagePath + "category01.svg",
                        color: colors.primary,
                      )
                    : SvgPicture.asset(
                        imagePath + "category.svg",
                        color: colors.primary,
                      ),
                text:
                    _selBottom == 1 ? getTranslated(context, 'category') : null,
              ),
              Tab(
                icon: _selBottom == 2
                    ? SvgPicture.asset(
                        imagePath + "sale02.svg",
                        color: colors.primary,
                      )
                    : SvgPicture.asset(
                        imagePath + "sale.svg",
                        color: colors.primary,
                      ),
                text: _selBottom == 2 ? getTranslated(context, 'SALE') : null,
              ),
              Tab(
                icon: Selector<UserProvider, String>(
                  builder: (context, data, child) {
                    return Stack(
                      children: [
                        Center(
                          child: _selBottom == 3
                              ? SvgPicture.asset(
                                  imagePath + "cart01.svg",
                                  color: colors.primary,
                                )
                              : SvgPicture.asset(
                                  imagePath + "cart.svg",
                                  color: colors.primary,
                                ),
                        ),
                        (data != null && data.isNotEmpty && data != "0")
                            ? new Positioned.directional(
                                bottom: _selBottom == 3 ? 6 : 20,
                                textDirection: Directionality.of(context),
                                end: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colors.primary),
                                  child: new Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(3),
                                      child: new Text(
                                        data,
                                        style: TextStyle(
                                            fontSize: 7,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .white),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    );
                  },
                  selector: (_, homeProvider) => homeProvider.curCartCount,
                ),
                text: _selBottom == 3 ? getTranslated(context, 'CART') : null,
              ),
              Tab(
                icon: _selBottom == 4
                    ? SvgPicture.asset(
                        imagePath + "profile01.svg",
                        color: colors.primary,
                      )
                    : SvgPicture.asset(
                        imagePath + "profile.svg",
                        color: colors.primary,
                      ),
                text:
                    _selBottom == 4 ? getTranslated(context, 'ACCOUNT') : null,
              ),
            ],
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: colors.primary, width: 5.0),
              insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 70.0),
            ),
            labelColor: colors.primary,
            labelStyle: TextStyle(fontSize: 8, fontWeight: FontWeight.w600),
          ),
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
