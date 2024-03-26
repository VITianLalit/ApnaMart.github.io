import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/consts/lists.dart';
import 'package:apna_mart/controllers/home_controller.dart';
import 'package:apna_mart/services/firestore_services.dart';
import 'package:apna_mart/views/category_screen/item_details.dart';
import 'package:apna_mart/views/home_screen/component/featured_button.dart';
import 'package:apna_mart/views/home_screen/search_screen.dart';
import 'package:apna_mart/widgets_common/home_buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              color: lightGrey,
              height: 60,
              child: TextFormField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if(controller.searchController.text.isNotEmptyAndNotNull){
                        Get.to(() => SearchScreen(title: controller.searchController.text));
                      }
                    },
                    child: Icon(Icons.search),
                  ),
                  filled: true,
                  fillColor: whiteColor,
                  hintText: searchAnything,
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: textfieldGrey),
                ),
              ),

            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    VxSwiper.builder(
                        // aspectRatio: 16/9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: slidersList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                slidersList[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          2,
                          (index) => homeButtons(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width / 2.5,
                                icon: index == 0 ? icTodaysDeal : icFlashDeal,
                                title: index == 0 ? todayDeal : flashSale,
                              )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    VxSwiper.builder(
                        // aspectRatio: 16/9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: secondSlidersList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                secondSlidersList[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        }),
                    10.heightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                          3,
                          (index) => homeButtons(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width / 3.5,
                                icon: index == 0
                                    ? icTopCategories
                                    : index == 1
                                        ? icBrands
                                        : icTopSeller,
                                title: index == 0
                                    ? topCategories
                                    : index == 1
                                        ? brand
                                        : topSeller,
                              )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: featuredCategories.text
                            .color(darkFontGrey)
                            .size(18)
                            .fontFamily(semibold)
                            .make()),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            3,
                            (index) => Column(
                                  children: [
                                    featureButton(
                                        icon: featuredImages1[index],
                                        title: featuredTitles1[index]),
                                    10.heightBox,
                                    featureButton(
                                        icon: featuredImages2[index],
                                        title: featuredTitles2[index]),
                                  ],
                                )),
                      ),
                    ),
                    20.heightBox,
                    Container(
                      padding: EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(color: redColor),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          featuredProduct.text.white
                              .size(18)
                              .fontFamily(bold)
                              .make(),
                          SizedBox(
                            height: 10,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                              future: FirestoreServices.getFeaturedProducts(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                                if(!snapshot.hasData){
                                  return Center(
                                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(redColor),),
                                  );
                                }
                                else if(snapshot.data!.docs.isEmpty){
                                  return "No featured products".text.white.makeCentered();
                                }
                                else{
                                  var featuredData = snapshot.data!.docs;
                                  return Row(
                                    children: List.generate(
                                        featuredData.length,
                                            (index) => Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Image.network(
                                              featuredData[index]['p_imgs'][0],
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.cover,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            "${featuredData[index]['p_name']}"
                                                .text
                                                .fontFamily(semibold)
                                                .color(darkFontGrey)
                                                .make(),
                                            "${featuredData[index]['p_price']}"
                                                .numCurrency
                                                .text
                                                .color(redColor)
                                                .fontFamily(bold)
                                                .size(16)
                                                .make(),
                                          ],
                                        )
                                            .box
                                            .white
                                            .margin(EdgeInsets.symmetric(
                                            horizontal: 4))
                                            .roundedSM
                                            .padding(EdgeInsets.all(8))
                                            .make().onTap(() {
                                              // controller.checkIfFav(featuredData[index]);
                                              Get.to(() => ItemDetails(
                                                title:
                                                "${featuredData[index]['p_name']}",
                                                data: featuredData[index],
                                              ));
                                            }))
                                  );
                                }
                              }
                            ),
                          )
                        ],
                      ),
                    ),
                    20.heightBox,
                    VxSwiper.builder(
                        // aspectRatio: 16/9,
                        autoPlay: true,
                        height: 150,
                        enlargeCenterPage: true,
                        itemCount: secondSlidersList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              clipBehavior: Clip.antiAlias,
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                secondSlidersList[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                          );
                        }),
                    20.heightBox,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(height: 20,
                        child: "ALL PRODUCTS".text.minFontSize(18).fontWeight(FontWeight.bold).make(),
                      ),
                    ),
                    20.heightBox,
                    StreamBuilder(
                        stream: FirestoreServices.allproducts(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(redColor),
                            );
                          } else {
                            var allproductsdata = snapshot.data!.docs;
                            return GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: allproductsdata.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  mainAxisExtent: 300,
                                ),
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        allproductsdata[index]['p_imgs'][0],
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      "${allproductsdata[index]['p_name']}"
                                          .text
                                          .fontFamily(semibold)
                                          .color(darkFontGrey)
                                          .make(),
                                      "${allproductsdata[index]['p_price']}]"
                                          .text
                                          .color(redColor)
                                          .fontFamily(bold)
                                          .size(16)
                                          .make(),
                                      10.heightBox,
                                    ],
                                  )
                                      .box
                                      .white
                                      .margin(
                                          EdgeInsets.symmetric(horizontal: 4))
                                      .roundedSM
                                      .padding(EdgeInsets.all(12))
                                      .make()
                                      .onTap(() {
                                    Get.to(() => ItemDetails(
                                          title:
                                              "${allproductsdata[index]['p_name']}",
                                          data: allproductsdata[index],
                                        ));
                                  });
                                });
                          }
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
