import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../home/home.dart';

class IntellectualProperty extends StatefulWidget {
  const IntellectualProperty({Key? key}) : super(key: key);

  @override
  State<IntellectualProperty> createState() => _IntellectualPropertyState();
}

class _IntellectualPropertyState extends State<IntellectualProperty> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: white),
        backgroundColor: primaryColor,
        elevation: 0,
        title: appBarWidget(context),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
          icon: Icon(Icons.home, color: white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: sizeFromHeight(context, 50)),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Container(
                  padding: EdgeInsets.all(sizeFromWidth(context, 6)),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/logo 2.jpeg'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  width: sizeFromWidth(context, 1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          settingModel.intellectualProperty,
                          textDirection: settingModel.intellectualProperty
                              .toString()
                              .contains(arabic[18])
                              ? TextDirection.rtl
                              : TextDirection.ltr,
                          style: TextStyle(
                            fontSize: sizeFromWidth(context, 30),
                            fontWeight: FontWeight.bold,
                            color: black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomScaffoldWidget(context),
        ],
      ),
    );
  }
}
