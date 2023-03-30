// ignore_for_file: must_be_immutable, iterable_contains_unrelated_type

import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/play_store/add%20comment.dart';
import 'package:news/providers/store%20provider.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import '../../models/store/product.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class ShowProduct extends StatefulWidget {
  ProductModel productModel;

  ShowProduct(this.productModel, {Key? key}) : super(key: key);

  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  late StoreProvider storeProvider;

  @override
  void initState() {
    Provider.of<StoreProvider>(context, listen: false).getProductFavourite();
    Provider.of<StoreProvider>(context, listen: false)
        .getProductComments(widget.productModel.id.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    storeProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              storeProvider
                  .addProductToFavourite(widget.productModel.id.toString())
                  .then((value) {
                storeProvider.getProductFavourite();
              });
            },
            icon: Icon(
              storeProvider.favourites.any((element) {
                return element.product.id == widget.productModel.id;
              })
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: white,
            ),
          ),
          IconButton(
            onPressed: () {
              if (Platform.isIOS) {
                WcFlutterShare.share(
                  sharePopupTitle: 'مشاركة',
                  mimeType: 'text/plain',
                  text:
                      'https://apps.apple.com/app/%D8%A7%D9%84%D8%A7%D8%AA%D8%AD%D8%A7%D8%AF-%D8%A7%D9%84%D8%AF%D9%88%D9%84%D9%8A-ifmis/id1670802361',
                );
              } else {
                WcFlutterShare.share(
                  sharePopupTitle: 'مشاركة',
                  mimeType: 'text/plain',
                  text:
                      'https://play.google.com/store/apps/details?id=dev.ifmis.news',
                );
              }
            },
            icon: Icon(
              Icons.share,
              color: white,
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            navigatePop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                SizedBox(
                  height: sizeFromHeight(context, 2.5),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Container(
                          height: sizeFromHeight(context, 2.5),
                          width: sizeFromWidth(context, 1.05),
                          margin:
                              const EdgeInsets.only(top: 5, left: 5, right: 5),
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: lightGrey),
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              image: NetworkImage(
                                  widget.productModel.media[index].fileName),
                            ),
                          ),
                        );
                      },
                      itemCount: widget.productModel.media.length,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${widget.productModel.price} ر.س',
                      textDirection: TextDirection.rtl,
                      maxLines: 2,
                      style: TextStyle(
                        height: 1.2,
                        fontSize: sizeFromWidth(context, 20),
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      width: sizeFromWidth(context, 1.5),
                      child: Text(
                        widget.productModel.name,
                        textDirection: TextDirection.rtl,
                        maxLines: 2,
                        style: TextStyle(
                          height: 1.2,
                          fontSize: sizeFromWidth(context, 25),
                          color: black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (widget.productModel.sizes.any((element) {
                  if (element.name == 'بدون حجم') {
                    return false;
                  }
                  return true;
                }))
                  SizedBox(height: sizeFromHeight(context, 40)),
                if (widget.productModel.sizes.any((element) {
                  if (element.name == 'بدون حجم') {
                    return false;
                  }
                  return true;
                }))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Size',
                                textDirection: TextDirection.rtl,
                                maxLines: 2,
                                style: TextStyle(
                                  height: 1.2,
                                  fontSize: sizeFromWidth(context, 20),
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: sizeFromHeight(context, 15),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 5),
                                        margin: const EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(color: lightGrey),
                                        ),
                                        child: Text(
                                          widget.productModel.sizes[index].name,
                                          textDirection: TextDirection.rtl,
                                          maxLines: 2,
                                          style: TextStyle(
                                            height: 1.2,
                                            fontSize:
                                                sizeFromWidth(context, 25),
                                            color: black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: widget.productModel.sizes.length,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                SizedBox(height: sizeFromHeight(context, 40)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Color',
                              textDirection: TextDirection.rtl,
                              maxLines: 2,
                              style: TextStyle(
                                height: 1.2,
                                fontSize: sizeFromWidth(context, 20),
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: sizeFromHeight(context, 15),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      margin: const EdgeInsets.all(5),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: lightGrey),
                                      ),
                                      child: Text(
                                        widget.productModel.colors[index].name,
                                        textDirection: TextDirection.rtl,
                                        maxLines: 2,
                                        style: TextStyle(
                                          height: 1.2,
                                          fontSize: sizeFromWidth(context, 25),
                                          color: black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  },
                                  itemCount: widget.productModel.colors.length,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
                SizedBox(height: sizeFromHeight(context, 40)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'حول المنتج',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                height: 1.2,
                                fontSize: sizeFromWidth(context, 20),
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.productModel.description,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                height: 1.2,
                                fontSize: sizeFromWidth(context, 25),
                                color: black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
                SizedBox(height: sizeFromHeight(context, 90)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: textButton(
                          context,
                          'تعليق',
                          primaryColor,
                          white,
                          sizeFromWidth(context, 20),
                          FontWeight.bold,
                          () {
                            navigateTo(context,
                                AddProductComment(widget.productModel));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sizeFromHeight(context, 90)),
                for (int i = 0; i < storeProvider.productComment.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: materialWidget(
                            context,
                            null,
                            sizeFromWidth(context, 1),
                            15,
                            null,
                            BoxFit.fill,
                            [
                              textWidget(
                                storeProvider.productComment[i].user.name,
                                TextDirection.rtl,
                                null,
                                black,
                                sizeFromWidth(context, 25),
                                FontWeight.bold,
                              ),
                              textWidget(
                                storeProvider.productComment[i].comment,
                                TextDirection.rtl,
                                null,
                                black,
                                sizeFromWidth(context, 30),
                                FontWeight.bold,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RatingBar(
                                    onRatingChanged: (value) {},
                                    filledIcon: Icons.star,
                                    emptyIcon: Icons.star_border,
                                    halfFilledIcon: Icons.star_half_rounded,
                                    initialRating:
                                    storeProvider.productComment[i].rate,
                                    emptyColor: darkGrey,
                                    filledColor: amber,
                                    halfFilledColor: amber,
                                    isHalfAllowed: true,
                                    size: sizeFromWidth(context, 25),
                                  ),
                                ],
                              ),
                            ],
                            MainAxisAlignment.start,
                            false,
                            10,
                            lightGrey,
                            () {},
                            CrossAxisAlignment.end,
                          ),
                        ),
                        const SizedBox(width: 5),
                        storyShape(
                          context,
                          lightGrey,
                          storeProvider.productComment[i].user.image != ''
                              ? NetworkImage(
                                  storeProvider.productComment[i].user.image)
                              : null,
                          30,
                          33,
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: sizeFromHeight(context, 90)),
              ],
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
