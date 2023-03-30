// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:news/modules/play_store/add%20category.dart';
import 'package:news/modules/play_store/add%20product.dart';
import 'package:news/modules/play_store/delete%20Banner.dart';
import 'package:news/modules/play_store/delete%20product.dart';
import 'package:news/modules/play_store/play%20store.dart';
import 'package:news/modules/play_store/show%20product.dart';
import 'package:news/providers/store%20provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/store/store.dart';
import '../../network/cash_helper.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../shared/const.dart';

class ShowStore extends StatefulWidget {
  StoreModel storeModel;

  ShowStore(this.storeModel, {Key? key}) : super(key: key);

  @override
  State<ShowStore> createState() => _ShowStoreState();
}

class _ShowStoreState extends State<ShowStore> {
  late StoreProvider storeProvider;

  sheet() {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 500),
      barrierLabel: MaterialLocalizations.of(context).dialogLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (context, _, __) {
        return Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                  width: sizeFromWidth(context, 1),
                  padding: EdgeInsets.only(top: sizeFromHeight(context, 20)),
                  color: white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                navigatePop(context);
                              },
                              icon: Icon(Icons.keyboard_return_rounded,
                                  color: primaryColor)),
                          Expanded(
                            child: Text(
                              widget.storeModel.name,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: sizeFromWidth(context, 20),
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                height: 1.2,
                              ),
                            ),
                          ),
                          Container(
                            width: sizeFromWidth(context, 5),
                            height:
                                sizeFromHeight(context, 10, hasAppBar: true),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    NetworkImage(widget.storeModel.storeImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 5),
                      divider(1, 1, lightGrey),
                      const SizedBox(height: 5),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'ساعات العمل:',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: sizeFromWidth(context, 25),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              'من ${widget.storeModel.startWorkHours}',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: sizeFromWidth(context, 25),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                height: 1.2,
                              ),
                            ),
                            Text(
                              'إلى ${widget.storeModel.endWorkHours}',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: sizeFromWidth(context, 25),
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                var url = Uri.parse(
                                    'whatsapp://send?phone=${widget.storeModel.phoneStore}');
                                await launchUrl(url);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: textWidget(
                                  'اضغط هنا للتواصل',
                                  null,
                                  null,
                                  primaryColor,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: textWidget(
                                'رقم التواصل مع المتجر: ${widget.storeModel.phoneStore}',
                                TextDirection.rtl,
                                null,
                                white,
                                sizeFromWidth(context, 28),
                                FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            Expanded(
                              child: textWidget(
                                'عنوان المتجر: ${widget.storeModel.storeAddress}',
                                TextDirection.rtl,
                                null,
                                white,
                                sizeFromWidth(context, 28),
                                FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.storeModel.latLangLink != '')
                        InkWell(
                          onTap: () async {
                            var url = Uri.parse(widget.storeModel.latLangLink);
                            try {
                              await launchUrl(url);
                            } catch (e) {
                              showToast(
                                  text: 'يوجد خطأ بالرابط',
                                  state: ToastStates.ERROR);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.centerRight,
                            child: Row(
                              children: [
                                Expanded(
                                  child: textWidget(
                                    'اضغط للحصول على عنوان المتجر عبر الاحداثيات',
                                    TextDirection.rtl,
                                    null,
                                    white,
                                    sizeFromWidth(context, 28),
                                    FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: sizeFromHeight(context, 90)),
                    ],
                  )),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ).drive(Tween<Offset>(
            begin: const Offset(0, -1.0),
            end: Offset.zero,
          )),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    Provider.of<StoreProvider>(context, listen: false)
        .getStoreCategories(widget.storeModel.id.toString(), true);
    Provider.of<StoreProvider>(context, listen: false)
        .getProducts(widget.storeModel.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    storeProvider = Provider.of(context);
    var id = CacheHelper.getData(key: 'id');
    return Scaffold(
      backgroundColor: lightGrey1,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              sheet();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: textWidget(
                'التواصل مع المتجر',
                null,
                null,
                primaryColor,
                sizeFromWidth(context, 30),
                FontWeight.bold,
              ),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            storeProvider.selectedCategoryID = 0;
            navigateAndFinish(context, const PlayStore());
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
              if (id.toString() == widget.storeModel.userId)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          navigateAndFinish(
                              context, AddCategory(widget.storeModel));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: textWidget(
                            'إضافة تصنيف',
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 25),
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          if (storeProvider.categories.length == 1) {
                            showToast(
                                text: 'يجب إضافة تصنيف قبل إضافة منتج',
                                state: ToastStates.ERROR);
                          } else {
                            navigateAndFinish(
                                context,
                                AddProduct(widget.storeModel,
                                    storeProvider.products.length));
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: textWidget(
                            'إضافة منتج',
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 25),
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (id.toString() == widget.storeModel.userId)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          navigateAndFinish(
                              context, DeleteProduct(widget.storeModel));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: textWidget(
                            'حذف منتج',
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 25),
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          navigateAndFinish(
                              context, DeleteBanner(widget.storeModel));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: textWidget(
                            'حذف صورة إعلان',
                            null,
                            null,
                            white,
                            sizeFromWidth(context, 25),
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (id.toString() != widget.storeModel.userId)
                SizedBox(height: sizeFromHeight(context, 70)),
              if (widget.storeModel.banners.isNotEmpty)
                SizedBox(
                  height: sizeFromHeight(context, 5),
                  width: sizeFromWidth(context, 1),
                  child: Card(
                    elevation: 5,
                    color: white,
                    child: Marquee(
                      direction: Axis.horizontal,
                      textDirection: TextDirection.rtl,
                      animationDuration: const Duration(seconds: 1),
                      backDuration: const Duration(milliseconds: 1000),
                      pauseDuration: const Duration(milliseconds: 1000),
                      directionMarguee: DirectionMarguee.TwoDirection,
                      child: Row(
                        children: widget.storeModel.banners.map((data) {
                          return Container(
                            margin: const EdgeInsets.all(5),
                            width: sizeFromWidth(context, 3.3),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(data.fileName),
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              SizedBox(
                height: sizeFromHeight(context, 20),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          if (storeProvider.categories[index].name == 'الكل') {
                            setState(() {
                              storeProvider.selectedCategoryID = 0;
                            });
                          } else {
                            storeProvider.getProductsByCategoryID(
                                storeProvider.categories[index].id);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 15),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: storeProvider.selectedCategoryID ==
                                    storeProvider.categories[index].id
                                ? primaryColor
                                : lightGrey1,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            storeProvider.categories[index].name,
                            textDirection: TextDirection.rtl,
                            maxLines: 2,
                            style: TextStyle(
                              height: 1.2,
                              fontSize: sizeFromWidth(context, 27),
                              color: storeProvider.selectedCategoryID ==
                                      storeProvider.categories[index].id
                                  ? white
                                  : primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: storeProvider.categories.length,
                  ),
                ),
              ),
              SizedBox(height: sizeFromHeight(context, 40)),
              if (storeProvider.selectedCategoryID == 0)
                Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.bottomLeft,
                                clipBehavior: Clip.none,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      navigateTo(
                                          context,
                                          ShowProduct(
                                              storeProvider.products[index]));
                                    },
                                    child: Container(
                                      height: sizeFromHeight(context, 3.5,
                                          hasAppBar: true),
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(storeProvider
                                              .products[index]
                                              .media[0]
                                              .fileName),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (storeProvider.products[index].discount !=
                                      '')
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(10)),
                                      ),
                                      child: textWidget(
                                        'خصم ${storeProvider.products[index].discount} %',
                                        TextDirection.rtl,
                                        null,
                                        white,
                                        sizeFromWidth(context, 30),
                                        FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Container(
                                margin: const EdgeInsets.only(right: 3),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${storeProvider.products[index].price} ر.س',
                                      textDirection: TextDirection.rtl,
                                      maxLines: 2,
                                      style: TextStyle(
                                        height: 1.2,
                                        fontSize: sizeFromWidth(context, 30),
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        storeProvider.products[index].name,
                                        textDirection: TextDirection.rtl,
                                        maxLines: 2,
                                        style: TextStyle(
                                          height: 1.2,
                                          fontSize: sizeFromWidth(context, 30),
                                          color: black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: storeProvider.products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1 / 1.4,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: sizeFromHeight(context, 50, hasAppBar: true))
                  ],
                ),
              if (storeProvider.selectedCategoryID != 0)
                Column(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 5, left: 10, right: 10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) {
                          return InkWell(
                            onTap: () {
                              navigateTo(
                                  context,
                                  ShowProduct(
                                      storeProvider.categoriesProducts[index]));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: Alignment.bottomLeft,
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      height: sizeFromHeight(context, 3.5,
                                          hasAppBar: true),
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                          image: NetworkImage(storeProvider
                                              .categoriesProducts[index]
                                              .media[0]
                                              .fileName),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    if (storeProvider.categoriesProducts[index]
                                            .discount !=
                                        '')
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 5),
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft: Radius.circular(10)),
                                        ),
                                        child: textWidget(
                                          'خصم ${storeProvider.categoriesProducts[index].discount} %',
                                          TextDirection.rtl,
                                          null,
                                          white,
                                          sizeFromWidth(context, 30),
                                          FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  margin: const EdgeInsets.only(right: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${storeProvider.categoriesProducts[index].price} ر.س',
                                        textDirection: TextDirection.rtl,
                                        maxLines: 2,
                                        style: TextStyle(
                                          height: 1.2,
                                          fontSize: sizeFromWidth(context, 30),
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          storeProvider
                                              .categoriesProducts[index].name,
                                          textDirection: TextDirection.rtl,
                                          maxLines: 2,
                                          style: TextStyle(
                                            height: 1.2,
                                            fontSize:
                                                sizeFromWidth(context, 30),
                                            color: black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: storeProvider.categoriesProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 5,
                          childAspectRatio: 1 / 1.4,
                        ),
                      ),
                    ),
                    SizedBox(
                        height: sizeFromHeight(context, 50, hasAppBar: true))
                  ],
                ),
            ],
          )),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
