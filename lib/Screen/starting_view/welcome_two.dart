import 'package:samadhaan_user/Helper/Session.dart';
import 'package:samadhaan_user/Helper/String.dart';
import 'package:samadhaan_user/Helper/app_assets.dart';
import 'package:samadhaan_user/Screen/SignInUpAcc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class WelcomeTwoView extends StatelessWidget {
  const WelcomeTwoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mysize = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: mysize.height / 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/images/titleicon.png",
                  scale: 5,
                ),
              ),
              SizedBox(
                height: mysize.height / 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/images/welcome_2_shop.png',
                  scale: 8,
                ),
              ),
              SizedBox(
                height: mysize.height / 20,
              ),
              Container(
                // margin: EdgeInsets.symmetric(horizontal: mysize.width / 10),
                child: Text(
                  "Welcome To Samadhaan Online",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: mysize.height / 40,
              ),
              Container(
                // margin: EdgeInsets.symmetric(horizontal: mysize.width / 10),
                child: Text(
                  "Register or login using your whatsapp number",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: mysize.height / 40,
              ),
              InkWell(
                onTap: () => onTapNevigtion(context),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/button.png',
                      height: mysize.height / 11,
                    ),
                    Positioned(
                      left: 10,
                      // right: 5,
                      child: Text(
                        'Get started',
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  onTapNevigtion(context) {
    setPrefrenceBool(ISFIRSTTIME, true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInUpAcc()),
    );
  }
}
