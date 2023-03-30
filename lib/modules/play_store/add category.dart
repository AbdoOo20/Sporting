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

class AddCategory extends StatefulWidget {
  StoreModel storeModel;

  AddCategory(this.storeModel, {Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController name = TextEditingController();
  late StoreProvider storeProvider;

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
            navigateAndFinish(context, ShowStore(widget.storeModel));
          },
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
      ),
      body: Column(
        children: [
          textFormField(
            controller: name,
            type: TextInputType.text,
            validate: (value) {
              if (value!.isEmpty) {
                return 'يجب إدخال اسم التصنيف';
              }
              return null;
            },
            hint: 'أدخل اسم التصنيف',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: textButton(
                    context,
                    'إنشاء التصنيف',
                    primaryColor,
                    white,
                    sizeFromWidth(context, 20),
                    FontWeight.bold,
                    () {
                      if (name.text.isEmpty) {
                        showToast(
                            text: 'أدخل التصنيف', state: ToastStates.ERROR);
                      } else {
                        storeProvider
                            .addCategoriesInStore(name.text.trim(),
                                widget.storeModel.id.toString())
                            .then((value) {
                          storeProvider.getStoreCategories(
                              widget.storeModel.id.toString(), false);
                        });
                        name.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: storeProvider.categories.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: sizeFromWidth(context, 1),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            storeProvider
                                .deleteCategory(storeProvider
                                .categories[index].id
                                .toString())
                                .then((value) {
                              storeProvider.getStoreCategories(
                                  widget.storeModel.id.toString(), false);
                            });
                          },
                          icon: Icon(Icons.delete, color: white)),
                      textWidget(
                        storeProvider.categories[index].name,
                        null,
                        null,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
