import 'package:shared_preferences/shared_preferences.dart';

final String appName = 'Samadhan_Online';
final String packageName = 'com.samadhaan.user';
final String androidLink = 'https://play.google.com/store/apps/details?id=';

final String iosPackage = 'com.samadhaan.user';
final String iosLink = 'your ios link here';
final String appStoreId = '123456789';

final String deepLinkUrlPrefix = 'https://alpha.ecommerce.link';
final String deepLinkName = 'alpha.ecommerce.link';

final int timeOut = 50;
const int perPage = 10;

final String baseUrl = 'https://samadhaan.online/app/v1/api/';
final String jwtKey = "f78d95e500c7ef84ee99d69d9651ff7a229979a2";
String razorPayKey = "rzp_test_UUBtmcArqOLqIY";
String razorPaySecret = "NTW3MUbXOtcwUrz5a4YCshqk";

class App {
  static late SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}
