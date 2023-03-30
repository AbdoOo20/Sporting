// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/models/store/store.dart';
import 'package:news/modules/play_store/show%20store.dart';
import 'package:provider/provider.dart';

import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class AddProduct extends StatefulWidget {
  StoreModel storeModel;
  int numberOfCategories;

  AddProduct(this.storeModel, this.numberOfCategories, {Key? key})
      : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController discount = TextEditingController();
  late StoreProvider storeProvider;

  List sizes = [
    'بدون حجم',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
  ];

  List colors = [
    'أبيض',
    'أسود',
    'أحمر',
    'أخضر',
    'أزرق',
    'أصفر',
    'بنفسجى',
    'وردى',
    'برتقالى',
    'كحلى',
    'رمادى',
    'بيج',
    'بنّي',
    'كستنائي',
    'ذهبي',
    'فضى',
  ];

  @override
  void initState() {
    Provider.of<StoreProvider>(context, listen: false)
        .getStoreCategories(widget.storeModel.id.toString(), false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    storeProvider = Provider.of(context);
    return Scaffold(
      backgroundColor: lightGrey1,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            storeProvider.productColors = [];
            storeProvider.productSize = [];
            storeProvider.productImage = [];
            storeProvider.selectedCategoryID = 0;
            navigateAndFinish(context, ShowStore(widget.storeModel));
          },
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(height: sizeFromHeight(context, 90)),
                  textFormField(
                    controller: name,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'يجب إدخال اسم المنتج';
                      }
                      return null;
                    },
                    hint: 'أدخل اسم المنتج',
                  ),
                  textFormField(
                    controller: description,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'يجب إدخال وصف المنتج';
                      }
                      return null;
                    },
                    hint: 'أدخل وصف المنتج',
                  ),
                  textFormField(
                    controller: price,
                    type: TextInputType.number,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'يجب إدخال سعر المنتج';
                      }
                      return null;
                    },
                    hint: 'أدخل سعر المنتج',
                  ),
                  textFormField(
                    controller: discount,
                    type: TextInputType.number,
                    validate: (value) {
                      return null;
                    },
                    hint: 'أدخل نسبة الخصم على المنتج إن وجد',
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        underline: const SizedBox(),
                        hint: Text(
                          storeProvider.productSize.isEmpty
                              ? 'أدخل أحجام المنتج'
                              : storeProvider.productSize.toString(),
                          style: TextStyle(
                            fontSize: sizeFromWidth(context, 25),
                            fontWeight: FontWeight.normal,
                            color: petroleum,
                          ),
                        ),
                        onChanged: (val) {
                          storeProvider.editProductSize(val.toString());
                        },
                        items: sizes.map((e) {
                          return DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: e,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              margin: const EdgeInsets.only(right: 0),
                              decoration: BoxDecoration(
                                color: storeProvider.productSize.contains(e)
                                    ? primaryColor
                                    : white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    e,
                                    style: TextStyle(
                                        color: storeProvider.productSize
                                                .contains(e)
                                            ? white
                                            : primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        underline: const SizedBox(),
                        hint: Text(
                          storeProvider.productColors.isEmpty
                              ? 'أدخل ألوان المنتج'
                              : storeProvider.productColors.toString(),
                          style: TextStyle(
                            fontSize: sizeFromWidth(context, 25),
                            fontWeight: FontWeight.normal,
                            color: petroleum,
                          ),
                        ),
                        onChanged: (val) {
                          storeProvider.editProductColors(val.toString());
                        },
                        items: colors.map((e) {
                          return DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: e,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              margin: const EdgeInsets.only(right: 0),
                              decoration: BoxDecoration(
                                color: storeProvider.productColors.contains(e)
                                    ? primaryColor
                                    : white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    e,
                                    style: TextStyle(
                                        color: storeProvider.productColors
                                                .contains(e)
                                            ? white
                                            : primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      border: Border.all(color: black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButton(
                        isExpanded: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        underline: const SizedBox(),
                        hint: Text(
                          storeProvider.selectedCategoryID == 0
                              ? 'اختر تصنيف المنتج'
                              : storeProvider.getCategoryID(),
                          style: TextStyle(
                            fontSize: sizeFromWidth(context, 25),
                            fontWeight: FontWeight.normal,
                            color: petroleum,
                          ),
                        ),
                        onChanged: (value) {
                          storeProvider.setCategoryID(value.toString());
                        },
                        items: storeProvider.categories.map((e) {
                          return DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: e.name,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              margin: const EdgeInsets.only(right: 0),
                              decoration: BoxDecoration(
                                color: e.id == storeProvider.selectedCategoryID
                                    ? primaryColor
                                    : white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    e.name,
                                    style: TextStyle(
                                        color: e.id ==
                                                storeProvider.selectedCategoryID
                                            ? white
                                            : primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: textButton(
                            context,
                            'اختر صور المنتج',
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                            () {
                              storeProvider.pickProductImages();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sizeFromHeight(context, 90)),
                  if (!storeProvider.isLoading)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: textButton(
                              context,
                              'إضافة المنتج',
                              primaryColor,
                              white,
                              sizeFromWidth(context, 20),
                              FontWeight.bold,
                              () {
                                if (widget.numberOfCategories == 40) {
                                  showToast(
                                      text: 'لا يمكن إضافة أكثر من 40 منتج',
                                      state: ToastStates.ERROR);
                                } else if (formKey.currentState!.validate()) {
                                  storeProvider
                                      .createProduct(
                                    widget.storeModel.id.toString(),
                                    name.text.trim(),
                                    description.text.trim(),
                                    price.text.trim(),
                                    discount.text.trim(),
                                    context,
                                  ).then((value) {
                                    storeProvider.productColors = [];
                                    storeProvider.productSize = [];
                                    storeProvider.productImage = [];
                                    storeProvider.selectedCategoryID = 0;
                                    navigateAndFinish(
                                        context, ShowStore(widget.storeModel));
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (storeProvider.isLoading)
                    Center(
                      child: circularProgressIndicator(
                          lightGrey, primaryColor, context),
                    ),
                  SizedBox(height: sizeFromHeight(context, 90)),
                ],
              ),
            ),
            bottomScaffoldWidget(context),
          ],
        ),
      ),
    );
  }
}
