import 'package:cached_network_image/cached_network_image.dart';
import 'package:samadhaan_user/Helper/Color.dart';
import 'package:samadhaan_user/Helper/String.dart';
import 'package:samadhaan_user/Provider/CategoryProvider.dart';
import 'package:samadhaan_user/Provider/HomeProvider.dart';
import 'package:samadhaan_user/Screen/SubCategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../Helper/Session.dart';
import '../Model/Section_Model.dart';
import 'HomePage.dart';
import 'ProductList.dart';

class AllCategory extends StatefulWidget {
  final bool isFromCart;

  const AllCategory({super.key, required this.isFromCart});
  @override
  State<AllCategory> createState() => _AllCategoryState();
}

class _AllCategoryState extends State<AllCategory> {
  @override
  void initState() {
    super.initState();
    // getCat();
  }

  Future<void> getCat() async {
    await Future.delayed(Duration.zero);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          widget.isFromCart ? getSimpleAppBar('All Categories', context) : null,
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, _) {
          if (homeProvider.catLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return catList.length > 0
              ? Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: Selector<CategoryProvider, List<Product>>(
                        builder: (context, data, child) {
                          return data.length > 0
                              ? GridView.count(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  children: List.generate(
                                    data.length,
                                    (index) {
                                      return subCatItem(data, index, context);
                                    },
                                  ))
                              : Center(
                                  child:
                                      Text(getTranslated(context, 'noItem')!));
                        },
                        selector: (_, categoryProvider) =>
                            categoryProvider.subList,
                      ),
                    ),
                  ],
                )
              : Container();
        },
      ),
    );
  }

  Widget catItem(int index, BuildContext context1) {
    return Selector<CategoryProvider, int>(
      builder: (context, data, child) {
        if (index == 0 && (popularList.length > 0)) {
          return GestureDetector(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: data == index
                      ? Theme.of(context).colorScheme.white
                      : Colors.transparent,
                  border: data == index
                      ? Border(
                          left: BorderSide(width: 5.0, color: colors.primary),
                        )
                      : null
                  // borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25.0),
                      child: SvgPicture.asset(
                        data == index
                            ? imagePath + "popular_sel.svg"
                            : imagePath + "popular.svg",
                        color: colors.primary,
                      ),
                    ),
                  ),
                  Text(
                    catList[index].name! + "\n",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context1).textTheme.caption!.copyWith(
                        color: data == index
                            ? colors.primary
                            : Theme.of(context).colorScheme.fontColor),
                  )
                ],
              ),
            ),
            onTap: () {
              context1.read<CategoryProvider>().setCurSelected(index);
              context1.read<CategoryProvider>().setSubList(popularList);
            },
          );
        } else {
          return GestureDetector(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: data == index
                      ? Theme.of(context).colorScheme.white
                      : Colors.transparent,
                  border: data == index
                      ? Border(
                          left: BorderSide(width: 5.0, color: colors.primary),
                        )
                      : null),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: FadeInImage(
                            image: CachedNetworkImageProvider(
                                catList[index].image!),
                            fadeInDuration: Duration(milliseconds: 150),
                            fit: BoxFit.contain,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                erroWidget(50),
                            placeholder: placeHolder(50),
                          )),
                    ),
                  ),
                  Text(
                    catList[index].name! + "\n",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context1).textTheme.caption!.copyWith(
                        color: data == index
                            ? colors.primary
                            : Theme.of(context).colorScheme.fontColor),
                  )
                ],
              ),
            ),
            onTap: () {
              context1.read<CategoryProvider>().setCurSelected(index);
              if (catList[index].subList == null ||
                  catList[index].subList!.length == 0) {
                print("kjhasdashjkdkashjdksahdsahdk");
                context1.read<CategoryProvider>().setSubList([]);
                Navigator.push(
                    context1,
                    MaterialPageRoute(
                      builder: (context) => ProductList(
                        name: catList[index].name,
                        id: catList[index].id,
                        tag: false,
                        fromSeller: false,
                      ),
                    ));
              } else {
                context1
                    .read<CategoryProvider>()
                    .setSubList(catList[index].subList);
              }
            },
          );
        }
      },
      selector: (_, cat) => cat.curCat,
    );
  }

  subCatItem(List<Product> subList, int index, BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 10.0),
              child: new ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: new FadeInImage(
                  fadeInDuration: Duration(milliseconds: 150),
                  image: CachedNetworkImageProvider(
                    subList[index].image!,
                  ),
                  height: 15.h,
                  width: 100.w,
                  fit: BoxFit.fill,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(50),
                  placeholder: placeHolder(50),
                ),
              ),
            ),
            Container(
              child: Text(
                subList[index].name!,
                style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Theme.of(context).colorScheme.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              width: 80.w,
            ),
          ],
        ),
      ),
      onTap: () {
        if (context.read<CategoryProvider>().curCat == 0 &&
            popularList.length > 0) {
          if (popularList[index].subList == null ||
              popularList[index].subList!.length == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductList(
                    name: popularList[index].name,
                    id: popularList[index].id,
                    tag: false,
                    fromSeller: false,
                  ),
                ));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubCategory(
                    subList: popularList[index].subList,
                    image: popularList[index].image!,
                    title: popularList[index].name ?? "",
                  ),
                ));
          }
        } else if (subList[index].subList == null ||
            subList[index].subList!.length == 0) {
          print(StackTrace.current);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductList(
                  name: subList[index].name,
                  id: subList[index].id,
                  tag: false,
                  fromSeller: false,
                ),
              ));
        } else {
          print(StackTrace.current);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubCategory(
                  subList: subList[index].subList,
                  image: subList[index].image ?? "",
                  title: subList[index].name ?? "",
                ),
              ));
        }
      },
    );
  }
}
