import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/ApiBaseHelper.dart';
import 'package:eshop_multivendor/Helper/AppBtn.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:eshop_multivendor/Helper/Constant.dart';
import 'package:eshop_multivendor/Helper/Session.dart';
import 'package:eshop_multivendor/Helper/SimBtn.dart';
import 'package:eshop_multivendor/Helper/String.dart';
import 'package:eshop_multivendor/Helper/app_assets.dart';
import 'package:eshop_multivendor/Helper/my_new_helper.dart';
import 'package:eshop_multivendor/Model/Model.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:eshop_multivendor/Provider/CartProvider.dart';
import 'package:eshop_multivendor/Provider/CategoryProvider.dart';
import 'package:eshop_multivendor/Provider/FavoriteProvider.dart';
import 'package:eshop_multivendor/Provider/HomeProvider.dart';
import 'package:eshop_multivendor/Provider/SettingProvider.dart';
import 'package:eshop_multivendor/Provider/UserProvider.dart';
import 'package:eshop_multivendor/Screen/Favorite.dart';
import 'package:eshop_multivendor/Screen/NotificationLIst.dart';
import 'package:eshop_multivendor/Screen/Search.dart';
import 'package:eshop_multivendor/Screen/SellerList.dart';
import 'package:eshop_multivendor/Screen/Seller_Details.dart';
import 'package:eshop_multivendor/Screen/SubCategory.dart';
import 'package:eshop_multivendor/Screen/starting_view/drawer_screen.dart';
import 'package:eshop_multivendor/Screen/starting_view/feature_product.dart';
import 'package:eshop_multivendor/Screen/starting_view/feature_view.dart';
import 'package:eshop_multivendor/Screen/starting_view/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:version/version.dart';

import 'ProductList.dart';
import 'Product_Detail.dart';
import 'SectionList.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
class HomePage extends StatefulWidget {
  ValueChanged onResult;
  HomePage(this.onResult);

  @override
  _HomePageState createState() => _HomePageState();
}

List<SectionModel> sectionList = [];
List<Product> catList = [];
List<Product> popularList = [];
ApiBaseHelper apiBaseHelper = ApiBaseHelper();
List<String> tagList = [];
List<Product> sellerList = [];
int count = 1;
List<Model> homeSliderList = [];
List<Widget> pages = [];
List<Widget> pages1 = [];
List<Widget> pages2 = [];
List<Widget> pages3 = [];
List<Widget> pages4 = [];
List<Widget> pages5 = [];
var latitudeHome;
var longitudeHome;
class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage>, TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isNetworkAvail = true;

  final _controller = PageController();
  final _controller1 = PageController();
  final _controller2 = PageController();
  final _controller3 = PageController();
  final _controller4 = PageController();
  final _controller5 = PageController();

  late Animation buttonSqueezeanimation;
  late AnimationController buttonController;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  List<Model> offerImages = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  //String? curPin;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getCurrentLoc();
    callApi();
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = new Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: buttonController,
        curve:  Interval(
          0.0,
          0.150,
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _animateSlider(_controller);
      _animateSlider(_controller1);
      _animateSlider(_controller2);
      _animateSlider(_controller3);
      _animateSlider(_controller4);
      _animateSlider(_controller5);
    });
  }

  @override
  Widget build(BuildContext context) {
    var mysize = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: DrawerScreen(),
      ),
      body: _isNetworkAvail
          ? RefreshIndicator(
              color: colors.primary,
              key: _refreshIndicatorKey,
              onRefresh: _refresh,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _homeAppbar(),
                    // _deliverPincode(),
                    Container(
                      transform: Matrix4.translationValues(
                          0.0, -mysize.height / 60, 0.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),
                          pages.length>0?_slider(pages,0,_controller):SizedBox(),
                          SizedBox(height: 5,),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5),
                            child: Row(
                              children: [
                                Text(
                                  'Categories',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: (){
                                    widget.onResult("yes");
                                  },
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                        color: colors.primary,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                          ),
                          _catList(),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                    pages1.length>0?_slider(pages1,1,_controller1):SizedBox(),
                    Container(
                      height: 340,
                      child: FeatureView(
                        name: "Feature Product",
                        /*  tag: false,
                      fromSeller: false,*/
                      ),
                    ),
                    /*saveButton("Feature Products", () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FeatureProduct(
                              name: "Feature Product",
                              *//*  tag: false,
                    fromSeller: false,*//*
                            ),
                          ));
                    }),*/

                    saveButton("Feature Products", () {
                      if(CUR_USERID != null){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FeatureProduct(
                                name: "Feature Product",
                                /*  tag: false,
                    fromSeller: false,*/
                              ),
                            ));
                      } else {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            // title: const Text("Alert Dialog Box"),
                            content: const Text("Please Login first to Use This Features."),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ));
                                },
                                child: Container(
                                  color: Colors.green,
                                  padding: const EdgeInsets.all(10),
                                  child: const Text("okay",
                                    style: TextStyle(
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                    pages4.length>0?_slider(pages4,4,_controller4):SizedBox(),
                   _section(),
                    pages2.length>0?_slider(pages2,2,_controller2):SizedBox(),
                    // Text("section"),
                    _section(),
                    pages3.length>0?_slider(pages3,3,_controller3):SizedBox(),
                   _seller(),
                    SizedBox(height: 5,),
                    pages5.length>0?_slider(pages5,5,_controller5):SizedBox(),
                    SizedBox(height: 35,)
                  ],
                ),
              ),
            )
          : noInternet(context),
    );
  }
  Widget saveButton(String title, VoidCallback? onBtnSelected) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: MaterialButton(
              height: 45.0,
              textColor: Theme.of(context).colorScheme.white,
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
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Container _homeAppbar() => Container(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        boxHeight(20),
        Container(
          child: Row(
            children: [
              InkWell(
                onTap: (){
                  getLocation();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: "Delivery Location",
                          style:
                          TextStyle(fontSize: 12.0, color: Colors.white)),
                      WidgetSpan(
                          child: Container(
                            transform: Matrix4.translationValues(0.0, 5, 0.0),
                            child: Icon(
                              Icons.arrow_drop_up,
                              color: Colors.black,
                            ),
                          ))
                    ])),
                    Text(currentAddress.text.toString() ,
                        style: TextStyle(fontSize: 12.0, color: Colors.black))
                  ],
                ),
              ),
              Spacer(),
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
              SizedBox(width: 10,),
              // Text(
              //   'Delivery Location',
              //   style: TextStyle(color: Colors.white),
              // ),
              //new
              InkWell(
                onTap: (){
                  print("clicknoti");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationList(),
                      ));
                },
                child: Image.asset(
                  'assets/icons/notification_icon.png',
                  height: 24.0,
                ),
              )

            ],
          ),
        ),
        boxHeight(20),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              InkWell(
                 onTap: (){
                   scaffoldKey.currentState!.openDrawer();
                 } ,
                  child: Icon(Icons.sort,size: 32,color: Colors.white,)),
              boxWidth(10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: TextFormField(
                    readOnly: true,
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Search(),
                          ));
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,color:Color(0xff60db33),),
                        // Theme.of(context).colorScheme.black
                        hintStyle: TextStyle(color:Color(0xff60db33)),
                        hintText: "Search",
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        border: InputBorder.none),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 30.0,
        )
      ],
    ),
    decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/new_img/login_option.png'),
            fit: BoxFit.cover)),
  );
  var currentAddress = TextEditingController();
  var pinController = TextEditingController();

  Future<void> getCurrentLoc() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //  var loc = Provider.of<LocationProvider>(context, listen: false);
    latitudeHome = position.latitude.toString();
    longitudeHome = position.longitude.toString();
    List<Placemark> placemark = await placemarkFromCoordinates(
        double.parse(latitudeHome!), double.parse(longitudeHome!),
        localeIdentifier: "en");

    pinController.text = placemark[0].postalCode!;
    if (mounted) {
      setState(() {
        pinController.text = placemark[0].postalCode!;
        currentAddress.text =
        "${placemark[0].subLocality} , ${placemark[0].locality}";
        latitudeHome = position.latitude.toString();
        longitudeHome = position.longitude.toString();
        /*     loc.lng = position.longitudeHome.toString();
        loc.lat = position.latitudeHome.toString();*/
        callApi();
      });
    }
  }
  getLocation() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
          "AIzaSyCqQW9tN814NYD_MdsLIb35HRY65hHomco",
        )));

    setState(() {
      currentAddress.text =  "${result.subLocalityLevel1!.name} , ${result.city!.name}";
      latitudeHome = result.latLng!.latitude.toString();
      longitudeHome = result.latLng!.longitude.toString();
    });
  }
  Future<Null> _refresh() {
    context.read<HomeProvider>().setCatLoading(true);
    context.read<HomeProvider>().setSecLoading(true);
    context.read<HomeProvider>().setSliderLoading(true);
    return callApi();
  }
  int current = 0,current1=0,current2=0,current3=0,current4=0,current5=0;
  Widget _slider(pages,data,_controller) {
    double height = deviceWidth! / 2.2;
    return Stack(
      children: [
        Container(
          height: height,
          width: double.infinity,
          // margin: EdgeInsetsDirectional.only(top: 10),
          child: PageView.builder(
            itemCount: pages.length,
            scrollDirection: Axis.horizontal,
            // controller: _controller,
            physics: AlwaysScrollableScrollPhysics(),
            onPageChanged: (index) {
              if(data ==0){
                setState(() {
                  current =index;
                });
              }
              if(data ==1){
                setState(() {
                  current1 =index;
                });
              }
              if(data ==2){
                setState(() {
                  current2 =index;
                });
              }
              if(data ==3){
                setState(() {
                  current3 =index;
                });
              }
              if(data ==4){
                setState(() {
                  current4 =index;
                });
              }
              if(data ==5){
                setState(() {
                  current5 =index;
                });
              }
            },
            itemBuilder: (BuildContext context, int index) {
              return pages[index];
            },
          ),
        ),
        data==0?Positioned(
          bottom: 0,
          height: 40,
          left: 0,
          width: deviceWidth,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(
              pages,
                  (index, url) {
                return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current ==
                          index
                          ? Theme.of(context).colorScheme.fontColor
                          : Theme.of(context).colorScheme.primary,
                    ));
              },
            ),
          ),
        ):SizedBox(),
        data==1?Positioned(
          bottom: 0,
          height: 40,
          left: 0,
          width: deviceWidth,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(
              pages,
                  (index, url) {
                return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current1 ==
                          index
                          ? Theme.of(context).colorScheme.fontColor
                          : Theme.of(context).colorScheme.primary,
                    ));
              },
            ),
          ),
        ):SizedBox(),
        data==2?Positioned(
          bottom: 0,
          height: 40,
          left: 0,
          width: deviceWidth,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(
              pages,
                  (index, url) {
                return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current2 ==
                          index
                          ? Theme.of(context).colorScheme.fontColor
                          : Theme.of(context).colorScheme.primary,
                    ));
              },
            ),
          ),
        ):SizedBox(),
        data==3?Positioned(
          bottom: 0,
          height: 40,
          left: 0,
          width: deviceWidth,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(
              pages,
                  (index, url) {
                return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current3 ==
                          index
                          ? Theme.of(context).colorScheme.fontColor
                          : Theme.of(context).colorScheme.primary,
                    ));
              },
            ),
          ),
        ):SizedBox(),
        data==4?Positioned(
          bottom: 0,
          height: 40,
          left: 0,
          width: deviceWidth,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(
              pages,
                  (index, url) {
                return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current4 ==
                          index
                          ? Theme.of(context).colorScheme.fontColor
                          : Theme.of(context).colorScheme.primary,
                    ));
              },
            ),
          ),
        ):SizedBox(),
        data==5?Positioned(
          bottom: 0,
          height: 40,
          left: 0,
          width: deviceWidth,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: map<Widget>(
              pages,
                  (index, url) {
                return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: current5 ==
                          index
                          ? Theme.of(context).colorScheme.fontColor
                          : Theme.of(context).colorScheme.primary,
                    ));
              },
            ),
          ),
        ):SizedBox(),
      ],
    );
  }

  void _animateSlider(_controller) {
    Future.delayed(Duration(seconds: 5)).then(
      (_) {
        if (mounted) {
          int nextPage = _controller.hasClients
              ? _controller.page!.round() + 1
              : _controller.initialPage;

          if (nextPage == homeSliderList.length) {
            nextPage = 0;
          }
          if (_controller.hasClients)
            _controller
                .animateToPage(nextPage,
                    duration: Duration(milliseconds: 100), curve: Curves.linear)
                .then((_) => _animateSlider(_controller));
        }
      },
    );
  }
  _singleSection(int index) {
    Color back;
    int pos = index % 5;
    if (pos == 0)
      back = Theme.of(context).colorScheme.back1;
    else if (pos == 1)
      back = Theme.of(context).colorScheme.back2;
    else if (pos == 2)
      back = Theme.of(context).colorScheme.back3;
    else if (pos == 3)
      back = Theme.of(context).colorScheme.back4;
    else
      back = Theme.of(context).colorScheme.back5;
      print("section product length ${offerImages.length}");
    return sectionList[index].productList!.length > 0
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _getHeading(sectionList[index].title ?? "", index),
                    ListView.builder(
                      itemCount: sectionList[index].productList!.length>4?4:sectionList[index].productList!.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index1) {
                        print("product data here is ${sectionList[index].productList!.length}");
                        return productItem(index, index1, index1 % 2 == 0 ? true : false);
                      },
                    )
                    //_getSection(index),
                  ],
                ),
              ),
              offerImages.length > index ? _getOfferImage(index) : Container(),
            ],
          )
        : Container();
  }
  _getHeading(String title, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerRight,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: colors.yellow,
                ),
                padding: EdgeInsetsDirectional.only(
                    start: 10, bottom: 3, top: 3, end: 10),
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: colors.blackTemp),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              /*   Positioned(
                  // clipBehavior: Clip.hardEdge,
                  // margin: EdgeInsets.symmetric(horizontal: 20),
                  right: -14,
                  child: SvgPicture.asset("assets/images/eshop.svg"))*/
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(sectionList[index].shortDesc ?? "",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).colorScheme.fontColor)),
              ),
              TextButton(
                style: TextButton.styleFrom(
                    minimumSize: Size.zero, // <
                    backgroundColor: (Theme.of(context).colorScheme.white),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
                child: Text(
                  getTranslated(context, 'SHOP_NOW')!,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Theme.of(context).colorScheme.fontColor,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  SectionModel model = sectionList[index];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SectionList(
                        index: index,
                        section_model: model,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  _getOfferImage(index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 150),
              image: CachedNetworkImageProvider(offerImages[index].image!),
              width: double.maxFinite,
              imageErrorBuilder: (context, error, stackTrace) => erroWidget(50),

              // errorWidget: (context, url, e) => placeHolder(50),
              placeholder: AssetImage(MyAssets.slider_loding)),
        ),
        onTap: () {
          if (offerImages[index].type == "products") {
            Product? item = offerImages[index].list;

            Navigator.push(
              context,
              PageRouteBuilder(
                  //transitionDuration: Duration(seconds: 1),
                  pageBuilder: (_, __, ___) =>
                      ProductDetail(model: item, secPos: 0, index: 0, list: true
                          //  title: sectionList[secPos].title,
                          )),
            );
          } else if (offerImages[index].type == "categories") {
            Product item = offerImages[index].list;
            if (item.subList == null || item.subList!.length == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    name: item.name,
                    id: item.id,
                    tag: false,
                    fromSeller: false,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategory(
                    title: item.name!,
                    image: item.image!,
                    subList: item.subList,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  _getSection(int i) {
    var orient = MediaQuery.of(context).orientation;

    return sectionList[i].style == DEFAULT
        ? Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.count(
              // mainAxisSpacing: 12,
              // crossAxisSpacing: 12,
              padding: EdgeInsetsDirectional.only(top: 5),
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 0.750,

              //  childAspectRatio: 1.0,
              physics: NeverScrollableScrollPhysics(),
              children:
                  //  [
                  //   Container(height: 500, width: 1200, color: Colors.red),
                  //   Text("hello"),
                  //   Container(height: 10, width: 50, color: Colors.green),
                  // ]
                  List.generate(
                sectionList[i].productList!.length < 4
                    ? sectionList[i].productList!.length
                    : 4,
                (index) {
                  // return Container(
                  //   width: 600,
                  //   height: 50,
                  //   color: Colors.red,
                  // );

                  return productItem(i, index, index % 2 == 0 ? true : false);
                },
              ),
            ),
          )
        : sectionList[i].style == STYLE1
            ? sectionList[i].productList!.length > 0
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Flexible(
                            flex: 3,
                            fit: FlexFit.loose,
                            child: Container(
                                height: orient == Orientation.portrait
                                    ? deviceHeight! * 0.4
                                    : deviceHeight!,
                                child: productItem(i, 0, true))),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  height: orient == Orientation.portrait
                                      ? deviceHeight! * 0.2
                                      : deviceHeight! * 0.5,
                                  child: productItem(i, 1, false)),
                              Container(
                                  height: orient == Orientation.portrait
                                      ? deviceHeight! * 0.2
                                      : deviceHeight! * 0.5,
                                  child: productItem(i, 2, false)),
                            ],
                          ),
                        ),
                      ],
                    ))
                : Container()
            : sectionList[i].style == STYLE2
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          fit: FlexFit.loose,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  height: orient == Orientation.portrait
                                      ? deviceHeight! * 0.2
                                      : deviceHeight! * 0.5,
                                  child: productItem(i, 0, true)),
                              Container(
                                  height: orient == Orientation.portrait
                                      ? deviceHeight! * 0.2
                                      : deviceHeight! * 0.5,
                                  child: productItem(i, 1, true)),
                            ],
                          ),
                        ),
                        Flexible(
                            flex: 3,
                            fit: FlexFit.loose,
                            child: Container(
                                height: orient == Orientation.portrait
                                    ? deviceHeight! * 0.4
                                    : deviceHeight,
                                child: productItem(i, 2, false))),
                      ],
                    ))
                : sectionList[i].style == STYLE3
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                                flex: 1,
                                fit: FlexFit.loose,
                                child: Container(
                                    height: orient == Orientation.portrait
                                        ? deviceHeight! * 0.3
                                        : deviceHeight! * 0.6,
                                    child: productItem(i, 0, false))),
                            Container(
                              height: orient == Orientation.portrait
                                  ? deviceHeight! * 0.2
                                  : deviceHeight! * 0.5,
                              child: Row(
                                children: [
                                  Flexible(
                                      flex: 1,
                                      fit: FlexFit.loose,
                                      child: productItem(i, 1, true)),
                                  Flexible(
                                      flex: 1,
                                      fit: FlexFit.loose,
                                      child: productItem(i, 2, true)),
                                  Flexible(
                                      flex: 1,
                                      fit: FlexFit.loose,
                                      child: productItem(i, 3, false)),
                                ],
                              ),
                            ),
                          ],
                        ))
                    : sectionList[i].style == STYLE4
                        ? Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: Container(
                                        height: orient == Orientation.portrait
                                            ? deviceHeight! * 0.25
                                            : deviceHeight! * 0.5,
                                        child: productItem(i, 0, false))),
                                Container(
                                  height: orient == Orientation.portrait
                                      ? deviceHeight! * 0.2
                                      : deviceHeight! * 0.5,
                                  child: Row(
                                    children: [
                                      Flexible(
                                          flex: 1,
                                          fit: FlexFit.loose,
                                          child: productItem(i, 1, true)),
                                      Flexible(
                                          flex: 1,
                                          fit: FlexFit.loose,
                                          child: productItem(i, 2, false)),
                                    ],
                                  ),
                                ),
                              ],
                            ))
                        : Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: GridView.count(
                                padding: EdgeInsetsDirectional.only(top: 5),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                childAspectRatio: 1.2,
                                physics: NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 0,
                                children: List.generate(
                                  sectionList[i].productList!.length < 6
                                      ? sectionList[i].productList!.length
                                      : 6,
                                  (index) {
                                    return productItem(i, index,
                                        index % 2 == 0 ? true : false);
                                  },
                                )));
  }
  Widget productItem(int secPos, int index, bool pad) {
    if (sectionList[secPos].productList!.length > index) {
      Product model = sectionList[secPos].productList![index];
      String? offPer;
      double price = double.parse(
          sectionList[secPos].productList![index].prVarientList![0].disPrice!);
      if (price == 0) {
        price = double.parse(
            sectionList[secPos].productList![index].prVarientList![0].price!);
      } else {
        double off = double.parse(sectionList[secPos]
            .productList![index]
            .prVarientList![0]
            .price!) -
            price;
        offPer = ((off * 100) /
            double.parse(sectionList[secPos]
                .productList![index]
                .prVarientList![0]
                .price!))
            .toStringAsFixed(2);
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              elevation: 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                child: Stack(children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Hero(
                          tag: "ProList$index${model.id}",
                          child: Stack(
                            children: [
                              Padding(
                                padding:  EdgeInsets.only(top:10,bottom: 10,left: 8,right: 8),
                                child: Container(
                                  height: 120.0,
                                  width: 120.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      image: CachedNetworkImageProvider(model.image!),
                                      // height: 125.0,
                                      // width: 135.0,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) =>
                                          erroWidget(125),
                                      placeholder: placeHolder(125),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                model.name!,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .lightBlack),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Text(
                              //   parseString(model.desc!),
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .bodySmall!
                              //       .copyWith(
                              //       color: Theme.of(context)
                              //           .colorScheme
                              //           .lightBlack),
                              //   maxLines: 1,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                               SizedBox(height: 10,),
                              // Text(
                              //   "Samadhan Price" + " " + CUR_CURRENCY! + " " + price.toString(),
                              //   style: TextStyle(
                              //     color: Theme.of(context).colorScheme.fontColor,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              RichText(text: TextSpan(
                                text: "Samadhaan Price",
                                style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,),
                                children: [
                                  TextSpan(
                                    text: " "
                                  ),
                                  TextSpan(
                                    text: "${CUR_CURRENCY}",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.fontColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  ),
                                  TextSpan(
                                    text: " "
                                  ),
                                  TextSpan(
                                    text: "${price.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.fontColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  )
                                ]
                              )),
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 5.0, bottom: 5, top: 3),
                                child: double.parse(sectionList[secPos]
                                    .productList![index]
                                    .prVarientList![0]
                                    .disPrice!) !=
                                    0
                                    ? Row(
                                  children: <Widget>[
                                    Text(
                                      double.parse(sectionList[secPos]
                                          .productList![index]
                                          .prVarientList![0]
                                          .disPrice!) !=
                                          0
                                          ? "MRP" + " " + CUR_CURRENCY! +
                                          "" +
                                          "${double.parse(sectionList[secPos]
                                              .productList![index]
                                              .prVarientList![0]
                                              .price.toString()).toStringAsFixed(2)}"
                                          : "",
                                      style: Theme.of(context)
                                          .textTheme
                                          .overline!
                                          .copyWith(
                                          decoration: TextDecoration.lineThrough,
                                          letterSpacing: 0),
                                    ),
                                    Flexible(
                                      child: Text(" | " + "-$offPer%",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .overline!
                                              .copyWith(
                                              color: colors.primary,
                                              letterSpacing: 0)),
                                    ),
                                  ],
                                )
                                    : Container(
                                  height: 5,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if(CUR_USERID == null){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Login(),
                                      ),
                                    );
                                  }else{
                                    Product model = sectionList[secPos].productList![index];
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        // transitionDuration: Duration(milliseconds: 150),
                                        pageBuilder: (_, __, ___) => ProductDetail(
                                            model: model, secPos: secPos, index: index, list: false
                                          //  title: sectionList[secPos].title,
                                        ),
                                      ),
                                    );
                                  }

                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  width: MediaQuery.of(context).size.width/2.5,
                                  decoration: BoxDecoration(
                                    color: colors.primary,
                                    borderRadius: BorderRadius.circular(6)
                                  ),
                                  child: Text(
                                    "Add",

                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .white),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ]),
                onTap: () {
                  Product model = sectionList[secPos].productList![index];
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      // transitionDuration: Duration(milliseconds: 150),
                      pageBuilder: (_, __, ___) => ProductDetail(
                          model: model, secPos: secPos, index: index, list: false
                        //  title: sectionList[secPos].title,
                      ),
                    ),
                  );
                },
              ),
            ),
            // Positioned.directional(
            //   textDirection: Directionality.of(context),
            //   bottom: 5,
            //   end: 10,
            //   child:InkWell(
            //     onTap: () {
            //       if(CUR_USERID == null){
            //         Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => Login(),
            //           ),
            //         );
            //       }else{
            //         Product model = sectionList[secPos].productList![index];
            //         Navigator.push(
            //           context,
            //           PageRouteBuilder(
            //             // transitionDuration: Duration(milliseconds: 150),
            //             pageBuilder: (_, __, ___) => ProductDetail(
            //                 model: model, secPos: secPos, index: index, list: false
            //               //  title: sectionList[secPos].title,
            //             ),
            //           ),
            //         );
            //       }
            //
            //     },
            //     child: Card(
            //       elevation: 1,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       color: colors.primary,
            //       child: Padding(
            //         padding:  EdgeInsets.all(3.0),
            //         child: Text(
            //           "Add",
            //           style: Theme.of(context)
            //               .textTheme
            //               .subtitle1!
            //               .copyWith(
            //               color: Theme.of(context)
            //                   .colorScheme
            //                   .lightBlack),
            //           maxLines: 1,
            //           overflow: TextOverflow.ellipsis,
            //         ),
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
      );
    } else
      return Container();
  }
  Widget productItem1(int secPos, int index, bool pad) {
    if (sectionList[secPos].productList!.length > index) {
      String? offPer;
      double price = double.parse(
          sectionList[secPos].productList![index].prVarientList![0].disPrice!);
      if (price == 0) {
        price = double.parse(
            sectionList[secPos].productList![index].prVarientList![0].price!);
      } else {
        double off = double.parse(sectionList[secPos]
                .productList![index]
                .prVarientList![0]
                .price!) -
            price;
        offPer = ((off * 100) /
                double.parse(sectionList[secPos]
                    .productList![index]
                    .prVarientList![0]
                    .price!))
            .toStringAsFixed(2);
      }

      double width = deviceWidth! * 0.5;

      return Card(
        elevation: 0.0,
        margin: EdgeInsetsDirectional.only(bottom: 2, end: 2),
        //end: pad ? 5 : 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                   /*    child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child: Hero(
                      tag:
                      "${sectionList[secPos].productList![index].id}$secPos$index",
                      child: FadeInImage(
                        fadeInDuration: Duration(milliseconds: 150),
                        image: NetworkImage(
                            sectionList[secPos].productList![index].image!),
                        height: double.maxFinite,
                        width: double.maxFinite,
                        fit: extendImg ? BoxFit.fill : BoxFit.contain,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            erroWidget(width),

                        // errorWidget: (context, url, e) => placeHolder(width),
                        placeholder: placeHolder(width),
                      ),
                    )),*/
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5)),
                      child: Hero(
                        transitionOnUserGestures: true,
                        tag:
                            "${sectionList[secPos].productList![index].id}$secPos$index",
                        child: FadeInImage(
                          fadeInDuration: Duration(milliseconds: 150),
                          image: CachedNetworkImageProvider(
                              sectionList[secPos].productList![index].image!),
                          height: double.maxFinite,
                          width: double.maxFinite,
                          imageErrorBuilder: (context, error, stackTrace) =>
                              erroWidget(double.maxFinite),
                          fit: BoxFit.contain,
                          placeholder: placeHolder(width),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 5.0,
                  top: 3,
                ),
                child: Text(
                  sectionList[secPos].productList![index].name!,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Theme.of(context).colorScheme.lightBlack),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                " " + CUR_CURRENCY! + " " + price.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.fontColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 5.0, bottom: 5, top: 3),
                child: double.parse(sectionList[secPos]
                            .productList![index]
                            .prVarientList![0]
                            .disPrice!) !=
                        0
                    ? Row(
                        children: <Widget>[
                          Text(
                            double.parse(sectionList[secPos]
                                        .productList![index]
                                        .prVarientList![0]
                                        .disPrice!) !=
                                    0
                                ? CUR_CURRENCY! +
                                    "" +
                                    sectionList[secPos]
                                        .productList![index]
                                        .prVarientList![0]
                                        .price!
                                : "",
                            style: Theme.of(context)
                                .textTheme
                                .overline!
                                .copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    letterSpacing: 0),
                          ),
                          Flexible(
                            child: Text(" | " + "-$offPer%",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .overline!
                                    .copyWith(
                                        color: colors.primary,
                                        letterSpacing: 0)),
                          ),
                        ],
                      )
                    : Container(
                        height: 5,
                      ),
              ),
            ],
          ),
          onTap: () {
            Product model = sectionList[secPos].productList![index];
            Navigator.push(
              context,
              PageRouteBuilder(
                // transitionDuration: Duration(milliseconds: 150),
                pageBuilder: (_, __, ___) => ProductDetail(
                    model: model, secPos: secPos, index: index, list: false
                    //  title: sectionList[secPos].title,
                    ),
              ),
            );
          },
        ),
      );
    } else
      return Container();
  }

  _section() {
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        print("checking section data here ${data}");
        return data
            ? Container(
                width: double.infinity,
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).colorScheme.simmerBase,
                  highlightColor: Theme.of(context).colorScheme.simmerHigh,
                  child: sectionLoading(),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: sectionList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  print("here");
                  return _singleSection(index);
                },
              );
      },
      selector: (_, homeProvider) => homeProvider.secLoading,
    );
  }

  _catList() {
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        return data
            ? Container(
                width: double.infinity,
                child: Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.simmerBase,
                    highlightColor: Theme.of(context).colorScheme.simmerHigh,
                    child: catLoading()))
            : Container(
                height: 150,
                padding: const EdgeInsets.only(top: 10, left: 10),
                child: ListView.builder(
                  itemCount: catList.length < 10 ? catList.length : 10,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return Container();
                    else
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(end: 10),
                        child: GestureDetector(
                          onTap: () async {
                            if (catList[index].subList == null ||
                                catList[index].subList!.length == 0) {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductList(
                                      name: catList[index].name,
                                      id: catList[index].id,
                                      tag: false,
                                      fromSeller: false,
                                    ),
                                  ));
                            } else {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubCategory(
                                      title: catList[index].name!,
                                      image: catList[index].image!,
                                      subList: catList[index].subList,
                                    ),
                                  ));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(color:  Colors.grey,borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      bottom:10.0),
                                  child: new ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: new FadeInImage(
                                      fadeInDuration: Duration(milliseconds: 150),
                                      image: CachedNetworkImageProvider(
                                        catList[index].image!,
                                      ),
                                      height: 110,
                                      width: 13.h,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) =>
                                          erroWidget(50),
                                      placeholder: placeHolder(50),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    catList[index].name!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                  ),
                                  width: 100,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                  },
                ),
              );
      },
      selector: (_, homeProvider) => homeProvider.catLoading,
    );
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  Future<Null> callApi() async {
    UserProvider user = Provider.of<UserProvider>(context, listen: false);
    SettingProvider setting =
        Provider.of<SettingProvider>(context, listen: false);
        user.setUserId(setting.userId);
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      getSetting();
      getSlider();
      getSlider1();
      getSlider2();
      getSlider3();
      getSlider4();
      getSlider5();
      getCat();
      getSeller();
      getSection();
      getOfferImages();
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
    return null;
  }

  Future _getFav() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      if (CUR_USERID != null) {
        Map parameter = {
          USER_ID: CUR_USERID,
        };
        apiBaseHelper.postAPICall(getFavApi, parameter).then((getdata) {
          bool error = getdata["error"];
          String? msg = getdata["message"];
          if (!error) {
            var data = getdata["data"];

            List<Product> tempList = (data as List)
                .map((data) => new Product.fromJson(data))
                .toList();

            context.read<FavoriteProvider>().setFavlist(tempList);
          } else {
            if (msg != 'No Favourite(s) Product Are Added')
              setSnackbar(msg!, context);
          }

          context.read<FavoriteProvider>().setLoading(false);
        }, onError: (error) {
          setSnackbar(error.toString(), context);
          context.read<FavoriteProvider>().setLoading(false);
        });
      } else {
        context.read<FavoriteProvider>().setLoading(false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }

  void getOfferImages() {
    Map parameter = Map();

    apiBaseHelper.postAPICall(getOfferImageApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];
        offerImages.clear();
        offerImages =
            (data as List).map((data) => new Model.fromSlider(data)).toList();
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setOfferLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setOfferLoading(false);
    });
  }

  void getSection() {
    Map parameter = {PRODUCT_LIMIT: "6", PRODUCT_OFFSET: "0"};

    if (CUR_USERID != null) parameter[USER_ID] = CUR_USERID!;
    String curPin = context.read<UserProvider>().curPincode;
    if (curPin != '') parameter[ZIPCODE] = curPin;

    apiBaseHelper.postAPICall(getSectionApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      sectionList.clear();
      if (!error) {
        var data = getdata["data"];

        sectionList = (data as List)
            .map((data) => new SectionModel.fromJson(data))
            .toList();
      } else {
        if (curPin != '') context.read<UserProvider>().setPincode('');
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setSecLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSecLoading(false);
    });
  }

  void getSetting() {
    CUR_USERID = context.read<SettingProvider>().userId;
    //print("")
    Map parameter = Map();
    if (CUR_USERID != null) parameter = {USER_ID: CUR_USERID};

    apiBaseHelper.postAPICall(getSettingApi, parameter).then((getdata) async {
      bool error = getdata["error"];
      String? msg = getdata["message"];

      if (!error) {
        var data = getdata["data"]["system_settings"][0];
        cartBtnList = data["cart_btn_on_list"] == "1" ? true : false;
        refer = data["is_refer_earn_on"] == "1" ? true : false;
        CUR_CURRENCY = data["currency"];
        RETURN_DAYS = data['max_product_return_days'];
        MAX_ITEMS = data["max_items_cart"];
        MIN_AMT = data['min_amount'];
        CUR_DEL_CHR = data['delivery_charge'];
        String? isVerion = data['is_version_system_on'];
        extendImg = data["expand_product_images"] == "1" ? true : false;
        String? del = data["area_wise_delivery_charge"];
        MIN_ALLOW_CART_AMT = data[MIN_CART_AMT];

        if (del == "0")
          ISFLAT_DEL = true;
        else
          ISFLAT_DEL = false;

        if (CUR_USERID != null) {
          REFER_CODE = getdata['data']['user_data'][0]['referral_code'];

          context
              .read<UserProvider>()
              .setPincode(getdata["data"]["user_data"][0][PINCODE]);

          if (REFER_CODE == null || REFER_CODE == '' || REFER_CODE!.isEmpty)
            generateReferral();

          context.read<UserProvider>().setCartCount(
              getdata["data"]["user_data"][0]["cart_total_items"].toString());
          context
              .read<UserProvider>()
              .setBalance(getdata["data"]["user_data"][0]["balance"]);

          _getFav();
          _getCart("0");
        }

        UserProvider user = Provider.of<UserProvider>(context, listen: false);
        SettingProvider setting =
            Provider.of<SettingProvider>(context, listen: false);
        user.setMobile(setting.mobile);
        user.setName(setting.userName);
        user.setEmail(setting.email);
        user.setProfilePic(setting.profileUrl);

        Map<String, dynamic> tempData = getdata["data"];
        if (tempData.containsKey(TAG))
          tagList = List<String>.from(getdata["data"][TAG]);

        if (isVerion == "1") {
          String? verionAnd = data['current_version'];
          String? verionIOS = data['current_version_ios'];

          PackageInfo packageInfo = await PackageInfo.fromPlatform();

          String version = packageInfo.version;

          final Version currentVersion = Version.parse(version);
          final Version latestVersionAnd = Version.parse(verionAnd);
          final Version latestVersionIos = Version.parse(verionIOS);

          if ((Platform.isAndroid && latestVersionAnd > currentVersion) ||
              (Platform.isIOS && latestVersionIos > currentVersion))
            updateDailog();
        }
      } else {
        setSnackbar(msg!, context);
      }
    }, onError: (error) {
      setSnackbar(error.toString(), context);
    });
  }

  Future<void> _getCart(String save) async {
    _isNetworkAvail = await isNetworkAvailable();

    if (_isNetworkAvail) {
      try {
        var parameter = {USER_ID: CUR_USERID, SAVE_LATER: save};

        Response response =
            await post(getCartApi, body: parameter, headers: headers)
                .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          var data = getdata["data"];

          List<SectionModel> cartList = (data as List)
              .map((data) => new SectionModel.fromCart(data))
              .toList();
          context.read<CartProvider>().setCartlist(cartList);
        }
      } on TimeoutException catch (_) {}
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  Future<Null> generateReferral() async {
    String refer = getRandomString(8);

    //////

    Map parameter = {
      REFERCODE: refer,
    };

    apiBaseHelper.postAPICall(validateReferalApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        REFER_CODE = refer;

        Map parameter = {
          USER_ID: CUR_USERID,
          REFERCODE: refer,
        };

        apiBaseHelper.postAPICall(getUpdateUserApi, parameter);
      } else {
        if (count < 5) generateReferral();
        count++;
      }

      context.read<HomeProvider>().setSecLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSecLoading(false);
    });
  }

  updateDailog() async {
    await dialogAnimate(context,
        StatefulBuilder(builder: (BuildContext context, StateSetter setStater) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        title: Text(getTranslated(context, 'UPDATE_APP')!),
        content: Text(
          getTranslated(context, 'UPDATE_AVAIL')!,
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
              onPressed: () async {
                Navigator.of(context).pop(false);

                String _url = '';
                if (Platform.isAndroid) {
                  _url = androidLink + packageName;
                } else if (Platform.isIOS) {
                  _url = iosLink;
                }

                if (await canLaunch(_url)) {
                  await launch(_url);
                } else {
                  throw 'Could not launch $_url';
                }
              })
        ],
      );
    }));
  }

  Widget homeShimmer() {
    return Container(
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: SingleChildScrollView(
            child: Column(
          children: [
            catLoading(),
            sliderLoading(),
            sectionLoading(),
          ],
        )),
      ),
    );
  }

  Widget sliderLoading() {
    double width = deviceWidth!;
    double height = width / 2;
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          width: double.infinity,
          height: height,
          color: Theme.of(context).colorScheme.white,
        ));
  }

  Widget _buildImagePageItem(Model slider) {
    double height = deviceWidth! / 0.5;
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: FadeInImage(
              fadeInDuration: Duration(milliseconds: 150),
              image: CachedNetworkImageProvider(slider.image!),
              height: height,
              width: double.maxFinite,
              fit: BoxFit.fill,
              imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                    MyAssets.slider_loding,
                    fit: BoxFit.contain,
                    height: height,
                    color: colors.primary,
                  ),
              placeholderErrorBuilder: (context, error, stackTrace) => Image.asset(
                    MyAssets.slider_loding,
                    fit: BoxFit.contain,
                    height: height,
                    color: colors.primary,
                  ),
              placeholder: AssetImage(MyAssets.slider_loding)),
        ),
      ),
      onTap: () async {
        int curSlider = context.read<HomeProvider>().curSlider;

        if (homeSliderList[curSlider].type == "products") {
          Product? item = homeSliderList[curSlider].list;

          Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (_, __, ___) => ProductDetail(
                    model: item, secPos: 0, index: 0, list: true)),
          );
        } else if (homeSliderList[curSlider].type == "categories") {
          Product item = homeSliderList[curSlider].list;
          if (item.subList == null || item.subList!.length == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    name: item.name,
                    id: item.id,
                    tag: false,
                    fromSeller: false,
                  ),
                ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategory(
                    title: item.name!,
                    image: item.image!,
                    subList: item.subList,
                  ),
                ));
          }
        }
      },
    );
  }

  Widget deliverLoading() {
    return Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.simmerBase,
        highlightColor: Theme.of(context).colorScheme.simmerHigh,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: double.infinity,
          height: 18.0,
          color: Theme.of(context).colorScheme.white,
        ));
  }

  Widget catLoading() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                    .map((_) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.white,
                            shape: BoxShape.circle,
                          ),
                          width: 50.0,
                          height: 50.0,
                        ))
                    .toList()),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          width: double.infinity,
          height: 18.0,
          color: Theme.of(context).colorScheme.white,
        ),
      ],
    );
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: getTranslated(context, 'TRY_AGAIN_INT_LBL'),
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              context.read<HomeProvider>().setCatLoading(true);
              context.read<HomeProvider>().setSecLoading(true);
              context.read<HomeProvider>().setSliderLoading(true);
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  if (mounted)
                    setState(() {
                      _isNetworkAvail = true;
                    });
                  callApi();
                } else {
                  await buttonController.reverse();
                  if (mounted) setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  _deliverPincode() {
    // String curpin = context.read<UserProvider>().curPincode;
    return GestureDetector(
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 8),
        color: Theme.of(context).colorScheme.white,
        child: ListTile(
          dense: true,
          minLeadingWidth: 10,
          leading: Icon(
            Icons.location_pin,
          ),
          title: Selector<UserProvider, String>(
            builder: (context, data, child) {
              return Text(
                data == ''
                    ? getTranslated(context, 'SELOC')!
                    : getTranslated(context, 'DELIVERTO')! + data,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.fontColor),
              );
            },
            selector: (_, provider) => provider.curPincode,
          ),
          trailing: Icon(Icons.keyboard_arrow_right),
        ),
      ),
      onTap: _pincodeCheck,
    );
  }

  void _pincodeCheck() {
    showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (builder) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9),
              child: ListView(shrinkWrap: true, children: [
                Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, bottom: 40, top: 30),
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Form(
                          key: _formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.close),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                validator: (val) => validatePincode(val!,
                                    getTranslated(context, 'PIN_REQUIRED')),
                                onSaved: (String? value) {
                                  context
                                      .read<UserProvider>()
                                      .setPincode(value!);
                                },
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .fontColor),
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: Icon(Icons.location_on),
                                  hintText:
                                      getTranslated(context, 'PINCODEHINT_LBL'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsetsDirectional.only(start: 20),
                                      width: deviceWidth! * 0.35,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          context
                                              .read<UserProvider>()
                                              .setPincode('');

                                          context
                                              .read<HomeProvider>()
                                              .setSecLoading(true);
                                          getSection();
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                            getTranslated(context, 'All')!),
                                      ),
                                    ),
                                    Spacer(),
                                    SimBtn(
                                        size: 0.35,
                                        title: getTranslated(context, 'APPLY'),
                                        onBtnSelected: () async {
                                          if (validateAndSave()) {
                                            // validatePin(curPin);
                                            context
                                                .read<HomeProvider>()
                                                .setSecLoading(true);
                                            getSection();

                                            context
                                                .read<HomeProvider>()
                                                .setSellerLoading(true);
                                            getSeller();

                                            Navigator.pop(context);
                                          }
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ))
              ]),
            );
            //});
          });
        });
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;

    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController.forward();
    } on TickerCanceled {}
  }

  void getSlider() {
    Map map = Map();
    apiBaseHelper.postAPICall(getSliderApi, map).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];
        homeSliderList =
            (data as List).map((data) => new Model.fromSlider(data)).toList();
        setState(() {
          pages = homeSliderList.map((slider) {
            return _buildImagePageItem(slider);
          }).toList();
        });
      } else {
        setSnackbar(msg!, context);
      }
      context.read<HomeProvider>().setSliderLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSliderLoading(false);
    });
  }
  void getSlider1() {
    Map map = Map();
    apiBaseHelper.postAPICall(getSecondSliderApi, map).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];

        homeSliderList =
            (data as List).map((data) => new Model.fromSlider(data)).toList();

        setState(() {
          pages1 = homeSliderList.map((slider) {
            return _buildImagePageItem(slider);
          }).toList();
        });
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setSliderLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSliderLoading(false);
    });
  }
  void getSlider2() {
    Map map = Map();

    apiBaseHelper.postAPICall(getThirdSliderApi, map).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];

        homeSliderList =
            (data as List).map((data) => new Model.fromSlider(data)).toList();

        setState(() {
          pages2 = homeSliderList.map((slider) {
            return _buildImagePageItem(slider);
          }).toList();
        });
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setSliderLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSliderLoading(false);
    });
  }
  void getSlider3() {
    Map map = Map();

    apiBaseHelper.postAPICall(getFourthSliderApi, map).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];

        homeSliderList =
            (data as List).map((data) => new Model.fromSlider(data)).toList();

        setState(() {
          pages3 = homeSliderList.map((slider) {
            return _buildImagePageItem(slider);
          }).toList();
        });
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setSliderLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSliderLoading(false);
    });
  }
  void getSlider4() {
    Map map = Map();

    apiBaseHelper.postAPICall(getFifthSliderApi, map).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];

        homeSliderList =
            (data as List).map((data) => new Model.fromSlider(data)).toList();

        setState(() {
          pages4 = homeSliderList.map((slider) {
            return _buildImagePageItem(slider);
          }).toList();
        });
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setSliderLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSliderLoading(false);
    });
  }
  void getSlider5() {
    Map map = Map();

    apiBaseHelper.postAPICall(getSixthSliderApi, map).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];

        homeSliderList =
            (data as List).map((data) => new Model.fromSlider(data)).toList();
setState(() {
  pages5 = homeSliderList.map((slider) {
    return _buildImagePageItem(slider);
  }).toList();
});

      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setSliderLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSliderLoading(false);
    });
  }
  void getCat() {
    Map parameter = {
      CAT_FILTER: "false",
    };
    apiBaseHelper.postAPICall(getCatApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];

        catList =
            (data as List).map((data) => new Product.fromCat(data)).toList();

        if (getdata.containsKey("popular_categories")) {
          var data = getdata["popular_categories"];
          popularList =
              (data as List).map((data) => new Product.fromCat(data)).toList();

          if (popularList.length > 0) {
            Product pop =
                new Product.popular("Popular", imagePath + "popular.svg");
            catList.insert(0, pop);
            context.read<CategoryProvider>().setSubList(popularList);
          }
        }
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setCatLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setCatLoading(false);
    });
  }
  sectionLoading() {
    return Column(
        children: [0, 1, 2, 3, 4]
            .map((_) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 40),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                width: double.infinity,
                                height: 18.0,
                                color: Theme.of(context).colorScheme.white,
                              ),
                              GridView.count(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                childAspectRatio: 1.0,
                                physics: NeverScrollableScrollPhysics(),
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                                children: List.generate(
                                  4,
                                  (index) {
                                    return Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color:
                                          Theme.of(context).colorScheme.white,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    sliderLoading()
                    //offerImages.length > index ? _getOfferImage(index) : Container(),
                  ],
                ))
            .toList());
  }
  void getSeller() {
    String pin = context.read<UserProvider>().curPincode;
    Map parameter = {};
    if (pin != '') {
      parameter = {
        ZIPCODE: pin,
      };
    }
    apiBaseHelper.postAPICall(getSellerApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];

        sellerList =
            (data as List).map((data) => new Product.fromSeller(data)).toList();
      } else {
        setSnackbar(msg!, context);
      }

      context.read<HomeProvider>().setSellerLoading(false);
    }, onError: (error) {
      setSnackbar(error.toString(), context);
      context.read<HomeProvider>().setSellerLoading(false);
    });
  }
  _seller() {
    return Selector<HomeProvider, bool>(
      builder: (context, data, child) {
        return data
            ? Container(
                width: double.infinity,

                child: Shimmer.fromColors(
                    baseColor: Theme.of(context).colorScheme.simmerBase,
                    highlightColor: Theme.of(context).colorScheme.simmerHigh,
                    child: catLoading())
        )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(getTranslated(context, 'SHOP_BY_SELLER')!,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.fontColor,
                                fontWeight: FontWeight.bold)),
                        GestureDetector(
                          child: Text(getTranslated(context, 'VIEW_ALL')!),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SellerList()));
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 190,
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: ListView.builder(
                      itemCount: sellerList.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(end: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SellerProfile(
                                            sellerStoreName:
                                                sellerList[index].store_name ??
                                                    "",
                                            sellerRating: sellerList[index]
                                                    .seller_rating ??
                                                "",
                                            sellerImage: sellerList[index]
                                                    .seller_profile ??
                                                "",
                                            sellerName:
                                                sellerList[index].seller_name ??
                                                    "",
                                            sellerID:
                                                sellerList[index].seller_id,
                                            storeDesc: sellerList[index]
                                                .store_description,
                                          )));
                            },
                            child: Stack(
                              children: [
                                Container(
                                   // padding: EdgeInsets.all(8.0),
                                alignment: Alignment.bottomRight,
                                width: 150,
                                // height: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colors.lightGreen,
                                      image: DecorationImage(
                                          image: NetworkImage(sellerList[index].seller_profile!,
                                          // scale: 5,
                                          ),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      )
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 5,),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20.0),
                                        bottomRight: Radius.circular(20.0),
                                      ),
                                      color: Colors.lightGreen.shade300,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                                      children: [
                                        Container(
                                          width: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 10),
                                            child: Text(
                                              sellerList[index].seller_name!,
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15),
                                              overflow: TextOverflow.ellipsis,
                                              // textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Text(sellerList[index].seller_rating!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15),
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,),
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              ],
                            )

                            // Column(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   mainAxisSize: MainAxisSize.min,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: <Widget>[g
                            //     new ClipRRect(
                            //       borderRadius: BorderRadius.circular(10),
                            //       child: new FadeInImage(
                            //         fadeInDuration:
                            //             Duration(milliseconds: 150),
                            //         image: CachedNetworkImageProvider(
                            //           sellerList[index].seller_profile!,
                            //         ),
                            //         height: 250.0,
                            //         width: 200.0,
                            //         fit: BoxFit.contain,
                            //         imageErrorBuilder:
                            //             (context, error, stackTrace) =>
                            //                 erroWidget(50),
                            //         placeholder: placeHolder(50),
                            //       ),
                            //
                            //     ),
                            //     Container(
                            //       child: Text(
                            //         sellerList[index].seller_name!,
                            //         style: Theme.of(context)
                            //             .textTheme
                            //             .caption!
                            //             .copyWith(
                            //                 color: Theme.of(context)
                            //                     .colorScheme
                            //                     .fontColor,
                            //                 fontWeight: FontWeight.w600,
                            //                 fontSize: 10),
                            //         overflow: TextOverflow.ellipsis,
                            //         textAlign: TextAlign.center,
                            //       ),
                            //       width: 50,
                            //     ),
                            ),

                        );},
                    ),
                  ),

                ],
              );
      },
      selector: (_, homeProvider) => homeProvider.sellerLoading,
    );
  }
}
