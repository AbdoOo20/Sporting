import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/play_store/add%20store.dart';
import 'package:news/modules/play_store/edit%20store.dart';
import 'package:news/modules/play_store/favourites.dart';
import 'package:news/modules/play_store/show%20store.dart';
import 'package:news/providers/store%20provider.dart';
import 'package:provider/provider.dart';
import '../../network/cash_helper.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../home/home.dart';
import '../../shared/const.dart';

class PlayStore extends StatefulWidget {
  const PlayStore({Key? key}) : super(key: key);

  @override
  State<PlayStore> createState() => _PlayStoreState();
}

class _PlayStoreState extends State<PlayStore> {
  late StoreProvider storeProvider;

  @override
  void initState() {
    Provider.of<StoreProvider>(context, listen: false).getStores();
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
        leading: IconButton(
          onPressed: () {
            navigateAndFinish(context, const Home());
          },
          icon: Icon(
            Icons.home,
            color: white,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              navigateTo(context, const AddStore());
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
                'إنشاء متجر',
                null,
                null,
                primaryColor,
                sizeFromWidth(context, 30),
                FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: sizeFromWidth(context, 1),
            height: sizeFromHeight(context, 11, hasAppBar: true),
            color: primaryColor,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: textFormField(
                controller: storeProvider.search,
                type: TextInputType.text,
                validate: (value) {
                  return null;
                },
                onChange: (value) {
                  if (storeProvider.search.text.isEmpty) {
                    storeProvider.getStores();
                  }
                  storeProvider.searchAboutStore();
                },
                hint: 'ابحث هنا',
                isExpanded: true,
                textAlignVertical: TextAlignVertical.bottom,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_cart_rounded, color: white),
                const SizedBox(width: 5),
                textWidget(
                  'المتاجر الرياضية',
                  null,
                  null,
                  white,
                  sizeFromWidth(context, 28),
                  FontWeight.bold,
                ),
              ],
            ),
          ),
          if (storeProvider.stores.isNotEmpty)
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: storeProvider.stores.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () async {
                      navigateAndFinish(
                          context, ShowStore(storeProvider.stores[index]));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(5),
                      width: sizeFromWidth(context, 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                            color: lightGrey,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (storeProvider.stores[index].hasStar == 'yes')
                            const Icon(Icons.star, color: Colors.amber),
                          if (storeProvider.stores[index].userId ==
                              id.toString())
                            IconButton(
                                onPressed: () {
                                  navigateTo(context,
                                      EditStore(storeProvider.stores[index]));
                                },
                                icon: Icon(Icons.edit, color: primaryColor)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  storeProvider.stores[index].name,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: sizeFromWidth(context, 30),
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                    height: 1.2,
                                  ),
                                  maxLines: 1,
                                ),
                                Text(
                                  storeProvider.stores[index].description,
                                  textDirection: TextDirection.rtl,
                                  maxLines: 1,
                                  style: TextStyle(
                                    height: 1.2,
                                    fontSize: sizeFromWidth(context, 40),
                                    fontWeight: FontWeight.w700,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: sizeFromWidth(context, 7),
                            height:
                                sizeFromHeight(context, 12, hasAppBar: true),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(
                                    storeProvider.stores[index].storeImage),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          if (storeProvider.stores.isEmpty)
            Expanded(
              child: Center(
                child: textWidget(
                  'لا يوجد متاجر',
                  null,
                  null,
                  primaryColor,
                  sizeFromWidth(context, 20),
                  FontWeight.bold,
                ),
              ),
            ),
          bottomScaffoldWidget(context),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            backgroundColor: primaryColor,
            onPressed: () {
              navigateAndFinish(context, const Favourites());
            },
            label: textWidget(
              'المفضلة',
              null,
              null,
              white,
              sizeFromWidth(context, 20),
              FontWeight.bold,
            ),
            icon: Icon(
              Icons.star_border_sharp,
              color: white,
            ),
          ),
          SizedBox(height: sizeFromHeight(context, 10)),
        ],
      ),
    );
  }
}
