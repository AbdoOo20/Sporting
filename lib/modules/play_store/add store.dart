import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/play_store/play%20store.dart';
import 'package:news/providers/other%20provider.dart';
import 'package:provider/provider.dart';

import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class AddStore extends StatefulWidget {
  const AddStore({Key? key}) : super(key: key);

  @override
  State<AddStore> createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController link = TextEditingController();
  late StoreProvider storeProvider;
  late OtherProvider otherProvider;

  @override
  Widget build(BuildContext context) {
    storeProvider = Provider.of(context);
    otherProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF7f0e14),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'IFMIS',
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: sizeFromWidth(context, 23),
                color: white,
              ),
            ),
            Container(
              height: sizeFromHeight(context, 15, hasAppBar: true),
              width: sizeFromWidth(context, 5),
              decoration: const BoxDecoration(
                color: Color(0xFFbdbdbd),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/logo 2.jpeg'),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, const PlayStore());
          },
          icon: Icon(
            Icons.arrow_back,
            color: white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: sizeFromWidth(context, 1),
          height: sizeFromHeight(context, 1, hasAppBar: true),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: sizeFromHeight(context, 5)),
                textFormField(
                  controller: name,
                  type: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'يجب إدخال اسم المتجر';
                    }
                    return null;
                  },
                  hint: 'أدخل اسم المتجر',
                ),
                textFormField(
                  controller: link,
                  type: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'يجب إدخال وصف المتجر';
                    }
                    return null;
                  },
                  hint: 'أدخل وصف المتجر',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: textButton(
                          context,
                          'اختر صورة المتجر',
                          primaryColor,
                          white,
                          sizeFromWidth(context, 20),
                          FontWeight.bold,
                              () {
                            storeProvider.pickImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sizeFromHeight(context, 10)),
                if (!storeProvider.isLoading)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: textButton(
                            context,
                            'إنشاء المتجر',
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                                () {
                              if (formKey.currentState!.validate()) {
                                // storeProvider
                                //     .createChampionItem(
                                //     name.text.trim(), link.text.trim())
                                //     .then((value) {
                                //   name.clear();
                                //   link.clear();
                                // });
                                // otherProvider.sendNotification('يوجد شخص جديد يريد إنشاء متجر إلكترونى');
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                if (storeProvider.isLoading)
                  Center(
                    child: circularProgressIndicator(lightGrey, primaryColor),
                  ),
                const Spacer(),
                Container(
                  color: primaryColor,
                  height: sizeFromHeight(context, 10),
                  width: sizeFromWidth(context, 1),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: CarouselSlider(
                      items: downBanners.map((e) {
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(e.image),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      options: CarouselOptions(
                        height: 250,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        viewportFraction: 1,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(seconds: 1),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
