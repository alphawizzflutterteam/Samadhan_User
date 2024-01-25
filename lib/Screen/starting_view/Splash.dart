import 'dart:async';
import 'package:eshop_multivendor/Helper/app_assets.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Screen/Intro_Slider.dart';
import 'package:eshop_multivendor/Screen/starting_view/welcome_one.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../Helper/Color.dart';
import '../../Helper/Session.dart';
import '../../Helper/String.dart';
import 'package:flutter_svg/flutter_svg.dart';

//splash screen of app
class Splash extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<Splash> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
   deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    var mysize = MediaQuery.of(context).size;
    //  SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: [
            Container(
              height: deviceHeight,
              width: deviceWidth,
              child: Image.asset(
                'assets/images/splash_bg.png',
                fit: BoxFit.fill,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Expanded(
                  child: Image.asset(
                    MyAssets.white_logo,
                    scale: 2,

                  ),
                ),
              ],
            )
          ],
          alignment: Alignment.center,
        ));
  }

  startTime() async {
    print("++++++++++++++++++++++++++");


    var _duration = Duration(milliseconds: 4);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    SettingProvider settingsProvider =
        Provider.of<SettingProvider>(this.context, listen: false);

    bool isFirstTime = await settingsProvider.getPrefrenceBool(ISFIRSTTIME);
    print('____Som______${isFirstTime}_________');
    if (isFirstTime) {
      print('++++++++++++home++++++++++++++');
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      print("++++++++++++Splash++++++++++++++");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeOneView(),
          ));
    }
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

  @override
  void dispose() {
    //  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
}
