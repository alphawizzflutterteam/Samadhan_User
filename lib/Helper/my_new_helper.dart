/*fonts*/
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

const fontRegular = 'Regular';
const fontMedium = 'Medium';
const fontSemibold = 'Semibold';
const fontBold = 'Bold';
/* font sizes*/
const textSizeSmall = 12.0;
const textSizeSMedium = 14.0;
const textSizeMedium = 16.0;
const textSizeLargeMedium = 18.0;
const textSizeNormal = 20.0;
const textSizeLarge = 24.0;
const textSizeXLarge = 34.0;

/* margin */

const spacing_control_half = 2.0;
const spacing_control = 4.0;
const spacing_standard = 8.0;
const spacing_middle = 10.0;
const spacing_standard_new = 16.0;
const spacing_large = 24.0;
const spacing_xlarge = 32.0;
const spacing_xxLarge = 40.0;
Widget text(String text,
    {var fontSize = textSizeMedium,
      textColor = const Color(0xffffffff),
      var fontFamily = fontRegular,
      var fontWeight = FontWeight.w500,
      var isCentered = false,
      var isEnd = false,
      var maxLine = 2,
      var latterSpacing = 0.25,
      var textAllCaps = false,
      var isLongText = false,
      var overFlow = false,
      var decoration=false,}) {
  return Text(
    textAllCaps ? text.toUpperCase() : text,
    textAlign: isCentered ? TextAlign.center : isEnd ? TextAlign.end : TextAlign.start,
    maxLines: isLongText ? null : maxLine,
    softWrap: true,
    overflow: overFlow ? TextOverflow.ellipsis : TextOverflow.clip,
    style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
        height: 1.5,
        letterSpacing: latterSpacing,
        decoration: decoration?TextDecoration.lineThrough:TextDecoration.none
    ),
  );
}
BoxDecoration boxDecoration(
    {double radius = spacing_middle,
      Color color = Colors.transparent,
      Color bgColor = Colors.white,
      double width = 1.0,
      var showShadow = false}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow
        ? [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 4, spreadRadius: 1)]
        : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color,width: width),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}
double getHeight(double height){
  double tempHeight = 0.0;
  tempHeight = ((height * 100)/1280).h;
  return tempHeight;
}
double getWidth(double width){
  double tempWidth = 0.0;
  tempWidth = ((width * 100)/720).w;
  return tempWidth;
}
Widget boxWidth(double width){
  return SizedBox(width: getWidth(width),);
}

Widget boxHeight(double height){
  return SizedBox(height: getHeight(height),);
}
navigateScreen(BuildContext context,Widget widget){
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=>widget,
      ));
}
navigateBackScreen(BuildContext context,Widget widget){
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context)=>widget,
      ));
}
back(BuildContext context){
  Navigator.pop(context);
}