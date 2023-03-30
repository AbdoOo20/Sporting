import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/modules/sport%20services/show%20news%20sport.dart';
import 'package:news/providers/sport%20services%20provider.dart';
import 'package:provider/provider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import '../../shared/Components.dart';
import '../../shared/Style.dart';
import '../../shared/const.dart';
import '../home/home.dart';

class SportServices extends StatefulWidget {
  const SportServices({Key? key}) : super(key: key);

  @override
  State<SportServices> createState() => _SportServicesState();
}

class _SportServicesState extends State<SportServices> {
  late SportServicesProvider servicesProvider;

  @override
  void initState() {
    Provider.of<SportServicesProvider>(context, listen: false)
        .getSportServicesCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    servicesProvider = Provider.of(context);
    return Scaffold(
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
      body: ConditionalBuilder(
        condition: !servicesProvider.isLoading,
        builder: (context) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount:
                      servicesProvider.sportServicesCategoriesModel.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        navigateAndFinish(
                            context,
                            ShowsNewsSport(servicesProvider
                                .sportServicesCategoriesModel[index].id
                                .toString()));
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: textWidget(
                                  servicesProvider
                                      .sportServicesCategoriesModel[index].name,
                                  null,
                                  null,
                                  white,
                                  sizeFromWidth(context, 30),
                                  FontWeight.bold,
                                )),
                            Container(
                              width: sizeFromWidth(context, 8),
                              height: sizeFromWidth(context, 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    servicesProvider
                                        .sportServicesCategoriesModel[index]
                                        .image,
                                  ),
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
              bottomScaffoldWidget(context),
            ],
          );
        },
        fallback: (context) {
          return Center(
            child: circularProgressIndicator(lightGrey, primaryColor, context),
          );
        },
      ),
    );
  }
}
