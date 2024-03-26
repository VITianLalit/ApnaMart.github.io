import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/controllers/product_controller.dart';
import 'package:apna_mart/services/firestore_services.dart';
import 'package:apna_mart/views/category_screen/item_details.dart';

import 'package:apna_mart/widgets_common/bg_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CategoryDetails extends StatefulWidget {
  final String? title;
  const CategoryDetails({super.key,required this.title});

  @override
  State<CategoryDetails> createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    switchCategory(widget.title);
  }

  switchCategory(title){
    if(controller.subcat.contains(title)){
      productMethod = FirestoreServices.getSubCategoryProducts(title);
    }else{
      productMethod = FirestoreServices.getProducts(title);
    }
  }

  var controller = Get.find<ProductController>();
  dynamic productMethod;

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
          appBar: AppBar(
            title: widget.title!.text.fontFamily(bold).make(),
            elevation: 0,
          ),
          body:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                      controller.subcat.length,
                          (index) => "${controller.subcat[index]}"
                          .text
                          .size(12)
                          .fontFamily(semibold)
                          .color(darkFontGrey)
                          .makeCentered()
                          .box
                          .white
                          .rounded
                          .size(120, 60)
                          .margin(const EdgeInsets.symmetric(horizontal: 4))
                          .make().onTap(() {
                            switchCategory("${controller.subcat[index]}");
                            setState(() {});
                          })),
                ),
              ),
              20.heightBox,
              StreamBuilder(
                stream: productMethod,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData){
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        ),
                      ),
                    );
                  }else if(snapshot.data!.docs.isEmpty){
                    return Expanded(
                      child: "No Products found!".text.color(darkFontGrey).white.makeCentered(),
                    );
                  }
                  else{
                    var data = snapshot.data!.docs;
                    return  Expanded(
                      child:  GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, mainAxisExtent: 250, mainAxisSpacing: 8, crossAxisSpacing: 8),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  data[index]['p_imgs'][0],
                                  width: 200,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                "${data[index]['p_name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                "${data[index]['p_price']}".numCurrency
                                    .text
                                    .color(redColor)
                                    .fontFamily(bold)
                                    .size(16)
                                    .make(),
                              ],
                            )
                                .box
                                .white
                                .outerShadowSm
                                .margin(const EdgeInsets.symmetric(horizontal: 4))
                                .roundedSM
                                .padding(const EdgeInsets.all(12))
                                .make().onTap(() {
                              controller.checkIfFav(data[index]);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetails(title: "${data[index]['p_name']}", data: data[index],)));
                            });
                          }),
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }
}

