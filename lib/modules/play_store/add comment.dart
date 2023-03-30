// ignore_for_file: must_be_immutable, import_of_legacy_library_into_null_safe

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/models/store/product.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';
import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class AddProductComment extends StatefulWidget {
  ProductModel productModel;

  AddProductComment(this.productModel, {Key? key}) : super(key: key);

  @override
  State<AddProductComment> createState() => _AddProductCommentState();
}

class _AddProductCommentState extends State<AddProductComment> {
  final TextEditingController comment = TextEditingController();
  late StoreProvider storeProvider;

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
      ),
      body: Column(
        children: [
          textFormField(
            controller: comment,
            type: TextInputType.text,
            validate: (value) {
              if (value!.isEmpty) {
                return 'يجب إدخال تعليق';
              }
              return null;
            },
            hint: 'أدخل التعليق',
          ),
          RatingBar(
            onRatingChanged: (value) {
              storeProvider.changeRating(value);
            },
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            halfFilledIcon: Icons.star_half_rounded,
            initialRating: 0.0,
            emptyColor: darkGrey,
            filledColor: amber,
            halfFilledColor: amber,
            isHalfAllowed: true,
            size: sizeFromWidth(context, 10),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: textButton(
                    context,
                    'إضافة التعليق',
                    primaryColor,
                    white,
                    sizeFromWidth(context, 20),
                    FontWeight.bold,
                    () {
                      if (comment.text.isEmpty) {
                        showToast(
                            text: 'أدخل التعليق', state: ToastStates.ERROR);
                      } else {
                        storeProvider
                            .addProductComment(widget.productModel.id.toString(), comment.text.trim())
                            .then((value) {
                          comment.clear();
                          storeProvider.ratingBar = 0.0;
                          storeProvider.getProductComments(widget.productModel.id.toString());
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
