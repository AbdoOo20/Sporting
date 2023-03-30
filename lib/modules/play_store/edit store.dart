// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/play_store/play%20store.dart';
import 'package:provider/provider.dart';

import '../../models/store/store.dart';
import '../../providers/store provider.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';

class EditStore extends StatefulWidget {
  StoreModel storeModel;

  EditStore(this.storeModel, {Key? key}) : super(key: key);

  @override
  State<EditStore> createState() => _EditStoreState();
}

class _EditStoreState extends State<EditStore> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController link = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController ownerPhone = TextEditingController();
  final TextEditingController storePhone = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  TimeOfDay time = TimeOfDay(
      hour: DateTime.now().hour.toInt(), minute: DateTime.now().minute.toInt());
  late StoreProvider storeProvider;

  List descriptionShop = [
    'متجر المعدات والكرات والأحذية والملابس الرياضية',
    'متجر المكملات الغذائيه الرياضية',
    'متجر المواد الغذائية الصحية الرياضية',
    'متجر المعدات الطبية الرياضية',
    'متجر السيارات والقطع الرياضية',
    'متجر الدراجات النارية والهاوية والقطع الرياضية',
    'متجر الادوات الرياضية المتنوعة',
    'متجر بناء الملاعب الرياضية والصالات',
    'متجر خدمات الأندية الرياضية ومراكز اللياقة البدنية',
    'متجر خدمات تأجير الملاعب الرياضية',
    'متجر بيع التحف الرياضية القديمة',
    'متجر بيع المنتجات والأجهزة البحرية',
    'متجر بيع منتجات الصيد والرحلات الرياضية',
    'متجر الماركات الرياضية العالمية المتنوعة',
  ];

  @override
  void initState() {
    name.text = widget.storeModel.name;
    link.text = widget.storeModel.latLangLink;
    description.text = widget.storeModel.description;
    address.text = widget.storeModel.storeAddress;
    ownerPhone.text = widget.storeModel.phoneStoreOwner;
    storePhone.text = widget.storeModel.phoneStore;
    startDate.text = widget.storeModel.startWorkHours;
    endDate.text = widget.storeModel.endWorkHours;
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
                        return 'يجب إدخال اسم المتجر';
                      }
                      return null;
                    },
                    hint: 'أدخل اسم المتجر',
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
                          description.text == ''
                              ? 'أدخل وصف المتجر'
                              : description.text,
                          style: TextStyle(
                            fontSize: sizeFromWidth(context, 25),
                            fontWeight: FontWeight.normal,
                            color: petroleum,
                          ),
                        ),
                        onChanged: (val) {
                          setState(() {
                            description.text = val.toString();
                          });
                        },
                        items: descriptionShop.map((e) {
                          return DropdownMenuItem(
                            alignment: AlignmentDirectional.center,
                            value: e,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 3),
                              margin: const EdgeInsets.only(right: 0),
                              decoration: BoxDecoration(
                                color: description.text == e
                                    ? primaryColor
                                    : white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(e,
                                    style: TextStyle(
                                        color: description.text == e
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
                  textFormField(
                    type: TextInputType.text,
                    controller: address,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'يجب إدخال العنوان : الدولة المدينة الحي';
                      }
                      return null;
                    },
                    hint: 'ادخل العنوان : الدولة المدينة الحي',
                  ),
                  textFormField(
                    type: TextInputType.text,
                    controller: link,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'يجب إدخال رابط احداثيات المتجر';
                      }
                      return null;
                    },
                    hint: 'أدخل رابط احداثيات المتجر',
                  ),
                  textFormField(
                    type: TextInputType.number,
                    controller: ownerPhone,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'يجب إدخال رقم جوال صاحب المتجر';
                      }
                      return null;
                    },
                    hint: 'أدخل رقم جوال صاحب المتجر',
                  ),
                  textFormField(
                    type: TextInputType.number,
                    controller: storePhone,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'يجب إدخال رقم جوال المتجر';
                      }
                      return null;
                    },
                    hint: 'أدخل رقم جوال المتجر',
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Expanded(
                        child: textFormField(
                            type: TextInputType.text,
                            controller: endDate,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'يجب إدخال وقت غلق المتجر';
                              }
                              return null;
                            },
                            hint: 'وقت غلق المتجر',
                            isExpanded: true,
                            onTap: () {
                              endDate.clear();
                              showTimePicker(
                                context: context,
                                initialTime: time,
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData(
                                      colorScheme: ColorScheme.light(
                                          primary: primaryColor),
                                    ),
                                    child: child!,
                                  );
                                },
                              ).then((value) {
                                if (value == null) {
                                  FocusScope.of(context).unfocus();
                                  return;
                                } else {
                                  endDate.text =
                                      value.format(context).toString().trim();
                                }
                              });
                            }),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: textFormField(
                            type: TextInputType.text,
                            controller: startDate,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'يجب إدخال وقت فتح المتجر';
                              }
                              return null;
                            },
                            hint: 'وقت فتح المتجر',
                            isExpanded: true,
                            onTap: () {
                              startDate.clear();
                              showTimePicker(
                                context: context,
                                initialTime: time,
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData(
                                      colorScheme: ColorScheme.light(
                                          primary: primaryColor),
                                    ),
                                    child: child!,
                                  );
                                },
                              ).then((value) {
                                if (value == null) {
                                  FocusScope.of(context).unfocus();
                                  return;
                                } else {
                                  startDate.text =
                                      value.format(context).toString().trim();
                                }
                              });
                            }),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: textButton(
                            context,
                            'تعديل صورة شعار المتجر',
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                            () {
                              storeProvider.pickStoreImage();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: sizeFromHeight(context, 90)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: textButton(
                            context,
                            'تعديل صور إعلانات المتجر إن وجدت',
                            primaryColor,
                            white,
                            sizeFromWidth(context, 20),
                            FontWeight.bold,
                            () {
                              storeProvider.pickStoreBannersImages();
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
                              'حفظ تعديلات المتجر',
                              primaryColor,
                              white,
                              sizeFromWidth(context, 20),
                              FontWeight.bold,
                              () {
                                if (description.text.isEmpty) {
                                  showToast(
                                      text: 'يجب اختيار وصف المتجر',
                                      state: ToastStates.ERROR);
                                } else if (formKey.currentState!.validate()) {
                                  storeProvider.updateStoreData(
                                    name.text.trim(),
                                    widget.storeModel.id.toString(),
                                    description.text.trim(),
                                    address.text.trim(),
                                    link.text.trim(),
                                    ownerPhone.text.trim(),
                                    storePhone.text.trim(),
                                    startDate.text.trim(),
                                    endDate.text.trim(),
                                    widget.storeModel.banners.length,
                                    context,
                                  );
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
