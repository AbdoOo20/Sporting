import 'package:flutter/material.dart';
import 'package:news/modules/programmer/programmer.dart';

import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';

class SelectProgrammer extends StatefulWidget {
  const SelectProgrammer({Key? key}) : super(key: key);

  @override
  State<SelectProgrammer> createState() => _SelectProgrammerState();
}

class _SelectProgrammerState extends State<SelectProgrammer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: sizeFromHeight(context, 4),
                  height: sizeFromHeight(context, 4),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(color: primaryColor, width: 2),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/photo.jpg"),
                        fit: BoxFit.fill,
                      )),
                ),
                Container(
                  width: sizeFromHeight(context, 4),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: primaryColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      textWidget(
                        'عبدالرحمن عماد',
                        TextDirection.rtl,
                        null,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                      ),
                      textWidget(
                          'مبرمج التطبيق',
                          TextDirection.rtl,
                          null,
                          white,
                          sizeFromWidth(context, 30),
                          FontWeight.bold,
                          null,
                          0.8),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                navigateAndFinish(context, Programmer('abdo'));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: textWidget(
                                  'اضغط هنا للمزيد',
                                  null,
                                  null,
                                  primaryColor,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              children: [
                Container(
                  width: sizeFromHeight(context, 4),
                  height: sizeFromHeight(context, 4),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(color: primaryColor, width: 2),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      image: const DecorationImage(
                        image: AssetImage("assets/images/mahm.jpeg"),
                        fit: BoxFit.fill,
                      )),
                ),
                Container(
                  width: sizeFromHeight(context, 4),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: primaryColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      textWidget(
                        'محمود إسماعيل',
                        TextDirection.rtl,
                        null,
                        white,
                        sizeFromWidth(context, 20),
                        FontWeight.bold,
                      ),
                      textWidget(
                          'مبرمج الواجهه الخلفية للتطبيق',
                          TextDirection.rtl,
                          null,
                          white,
                          sizeFromWidth(context, 30),
                          FontWeight.bold,
                          null,
                          0.8),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                navigateAndFinish(context, Programmer('mahmoud'));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: textWidget(
                                  'اضغط هنا للمزيد',
                                  null,
                                  null,
                                  primaryColor,
                                  sizeFromWidth(context, 25),
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
