import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop_multivendor/Helper/Session.dart';
import 'package:eshop_multivendor/Helper/my_new_helper.dart';
import 'package:eshop_multivendor/Model/Section_Model.dart';
import 'package:flutter/material.dart';
import 'package:eshop_multivendor/Helper/Color.dart';
import 'package:sizer/sizer.dart';
import 'ProductList.dart';

class SubCategory extends StatelessWidget {
  final List<Product>? subList;
  final String title;
  final String image;
  const SubCategory({Key? key, this.subList, required this.title,required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(title, context),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(image,width: 100.w,height: 20.h,fit: BoxFit.fill,),
            boxHeight(20),
            Container(
                padding: EdgeInsets.symmetric(horizontal: getWidth(20)),
                child: text("Sub Categories in $title",fontFamily: fontBold,fontSize: 14.sp,textColor: Theme.of(context).colorScheme.fontColor)),
            //boxHeight(20),
            Container(
              height: MediaQuery.of(context).size.height/2,
              margin: EdgeInsets.all(getWidth(25)),
              decoration: boxDecoration(radius: 21,bgColor: Color(0xff0BA84A).withOpacity(0.1)),
              padding: EdgeInsets.all(getWidth(30)),
              child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  childAspectRatio: 0.60,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 10,
                  children: List.generate(
                    subList!.length,
                    (index) {
                      return subCatItem(index, context);
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  subCatItem(int index, BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Container(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                  image: CachedNetworkImageProvider(subList![index].image!),
                  fadeInDuration: Duration(milliseconds: 150),
                  height: getWidth(200),
                  width:  getWidth(200),
                  fit: BoxFit.fill,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      erroWidget(50),
                  placeholder: placeHolder(50),
                )),
          ),
          boxHeight(10),
          Text(
            subList![index].name!,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Theme.of(context).colorScheme.fontColor,fontWeight: FontWeight.w600),
          )
        ],
      ),
      onTap: () {
        if (subList![index].subList == null ||
            subList![index].subList!.length == 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductList(
                  name: subList![index].name,
                  id: subList![index].id,
                  tag: false,
                  fromSeller: false,
                ),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubCategory(
                  subList: subList![index].subList,
                  title: subList![index].name ?? "",
                  image: subList![index].image ?? "",
                ),
              ));
        }
      },
    );
  }
}
