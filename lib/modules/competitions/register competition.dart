// ignore_for_file: must_be_immutable
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/providers/competition%20provider.dart';
import 'package:provider/provider.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class RegisterCompetition extends StatefulWidget {
  int competitionID;

  RegisterCompetition(this.competitionID, {Key? key}) : super(key: key);

  @override
  State<RegisterCompetition> createState() => _RegisterCompetitionState();
}

class _RegisterCompetitionState extends State<RegisterCompetition> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController position = TextEditingController();
  final TextEditingController videoLink = TextEditingController();
  late CompetitionProvider competitionProvider;

  @override
  Widget build(BuildContext context) {
    competitionProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
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
                textFormField(
                  controller: name,
                  type: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'يجب إدخال اسم المتسابق الأول و الأخير';
                    }
                    return null;
                  },
                  hint: 'أدخل اسم المتسابق الأول و الأخير فقط',
                ),
                textFormField(
                  controller: position,
                  type: TextInputType.text,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'يجب إدخال هواية المتسابق من كلمتين فقط';
                    }
                    return null;
                  },
                  hint: 'أدخل هواية المتسابق من كلمتين فقط',
                ),
                textFormField(
                  controller: videoLink,
                  type: TextInputType.text,
                  validate: (value) {
                    return null;
                  },
                  hint: 'أدخل رابط فيديو يوتيوب فقط',
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: textButton(
                          context,
                          'اختر صورة الدولة',
                          primaryColor,
                          white,
                          sizeFromWidth(context, 20),
                          FontWeight.bold,
                          () {
                            competitionProvider.selectCountryImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: textButton(
                          context,
                          'اختر صورة المتسابق',
                          primaryColor,
                          white,
                          sizeFromWidth(context, 20),
                          FontWeight.bold,
                          () {
                            competitionProvider.selectCompetitorImage();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: textButton(
                          context,
                          'اختر فيديو لا يزيد عن 40 ثانيه',
                          primaryColor,
                          white,
                          sizeFromWidth(context, 20),
                          FontWeight.bold,
                              () {
                            competitionProvider.pickVideoCompetitor();
                              },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: sizeFromHeight(context, 10)),
                if (!competitionProvider.isLoading)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                    child: Row(
                      children: [
                        Expanded(
                          child: textButton(
                            context,
                            'شارك بالمسابقة',
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                            () async {
                              if (formKey.currentState!.validate()) {
                                competitionProvider.shareInCompetition(
                                  widget.competitionID.toString(),
                                  name.text.trim(),
                                  position.text.trim(),
                                  videoLink.text.trim(),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                if (competitionProvider.isLoading)
                  Center(
                    child: circularProgressIndicator(lightGrey, primaryColor, context),
                  ),
                const Spacer(),
                bottomScaffoldWidget(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
