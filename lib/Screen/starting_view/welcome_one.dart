import 'dart:async';

import 'package:eshop_multivendor/Helper/app_assets.dart';
import 'package:eshop_multivendor/Helper/my_new_helper.dart';
import 'package:eshop_multivendor/Screen/starting_view/welcome_two.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WelcomeOneView extends StatefulWidget {
  const WelcomeOneView({Key? key}) : super(key: key);

  @override
  State<WelcomeOneView> createState() => _WelcomeOneViewState();
}

class _WelcomeOneViewState extends State<WelcomeOneView> {
  @override
  void initState() {
    super.initState();
    timar();
  }

  @override
  Widget build(BuildContext context) {
    var mysize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: mysize.height / 20,
              ),
              Image.asset(
                "assets/images/titleicon.png",
               scale: 5,

               // height: mysize.height / 8,
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.04,
                //height: mysize.height / 20,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/images/welcom_banner_img.png',
                  scale: 5,
                 // height: mysize.height / 5,
                //  fit: BoxFit.contain,
                  //width: mysize.width,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.06,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: mysize.width /20),
                child: Text(
                  "Welcome To Samadhaan  Online Shopping ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: mysize.height / 20,
              ),
              Image.asset(
                'assets/images/social_login.png',
                height: mysize.height / 10,
              )
            ],
          ),
          width: mysize.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/welcome_one_bg.png'),
                  fit: BoxFit.cover)),
        ),
      ),
    );
  }

  void timar() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Timer(Duration(seconds: 2), () async {
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeTwoView()));
      });
    });
  }
}
