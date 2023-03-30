// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/providers/sport%20services%20provider.dart';
import 'package:provider/provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class AddNewsSport extends StatefulWidget {
  String id;

  AddNewsSport(this.id, {Key? key}) : super(key: key);

  @override
  State<AddNewsSport> createState() => _AddNewsSportState();
}

class _AddNewsSportState extends State<AddNewsSport> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController link = TextEditingController();
  final TextEditingController tellAboutYourSelf = TextEditingController();
  final TextEditingController publisherName = TextEditingController();
  final TextEditingController publisherCountry = TextEditingController();
  late SportServicesProvider sportServicesProvider;

  @override
  Widget build(BuildContext context) {
    sportServicesProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
      ),
      body: SizedBox(
        width: sizeFromWidth(context, 1),
        height: sizeFromHeight(context, 1, hasAppBar: true),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    textFormField(
                      controller: name,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'يجب إدخال العنوان';
                        }
                        return null;
                      },
                      hint: 'أدخل العنوان',
                    ),
                    textFormField(
                      controller: description,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'يجب إدخال الخبر أو الطلب أو الوصف';
                        }
                        return null;
                      },
                      hint: 'أدخل الخبر أو الطلب أو الوصف',
                      maxLines: 4,
                      textAlignVertical: TextAlignVertical.bottom,
                    ),
                    textFormField(
                      controller: link,
                      type: TextInputType.text,
                      validate: (value) {
                        return null;
                      },
                      hint: 'أدخل رابط فيديو يوتيوب',
                    ),
                    textFormField(
                      controller: tellAboutYourSelf,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'يجب أن تكتب مصدر الخبر';
                        }
                        return null;
                      },
                      hint: 'اكتب مصدر الخبر',
                    ),
                    textFormField(
                      controller: publisherName,
                      type: TextInputType.text,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'يجب إدخال اسم النشر';
                        }
                        return null;
                      },
                      hint: 'أدخل اسم النشر',
                    ),
                    textFormField(
                      controller: publisherCountry,
                      type: TextInputType.text,
                      validate: (value) {
                        return null;
                      },
                      hint: 'أدخل دولة الناشر',
                    ),
                    if (!sportServicesProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: textButton(
                                context,
                                'اختر صورة دولة الناشر',
                                primaryColor,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                                () {
                                  sportServicesProvider.pickImagePublisher();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!sportServicesProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: textButton(
                                context,
                                'اختر صور الخبر',
                                primaryColor,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                                () {
                                  sportServicesProvider.pickImagesNews();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!sportServicesProvider.isLoading)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: textButton(
                                context,
                                'قم بإنشاء الخبر',
                                primaryColor,
                                white,
                                sizeFromWidth(context, 20),
                                FontWeight.bold,
                                () async {
                                  if (formKey.currentState!.validate()) {
                                    sportServicesProvider
                                        .addNews(
                                      name.text.trim(),
                                      description.text.trim(),
                                      link.text.trim(),
                                      widget.id,
                                      tellAboutYourSelf.text.trim(),
                                      publisherName.text.trim(),
                                      publisherCountry.text.trim(),
                                    ).then((value) {
                                      navigatePop(context);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (sportServicesProvider.isLoading)
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
      ),
    );
  }
}
