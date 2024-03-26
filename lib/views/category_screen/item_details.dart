import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/consts/lists.dart';
import 'package:apna_mart/controllers/product_controller.dart';
import 'package:apna_mart/views/chat_screen/chat_screen.dart';
import 'package:apna_mart/widgets_common/our_button.dart';
import 'package:get/get.dart';

class ItemDetails extends StatelessWidget {
  final String? title;
  final dynamic data;
  const ItemDetails({super.key, required this.title, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return WillPopScope(
      onWillPop: () async{
        controller.resetValue();
        return true;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            controller.resetValue();
            Get.back();
            },
            icon: Icon(Icons.arrow_back),),
          title: title!.text.color(darkFontGrey).fontFamily(bold).make(),
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                )),
            Obx(() =>
              IconButton(
                  onPressed: () {
                    if(controller.isFav.value){
                      controller.removeFromWishList(data.id, context);
                      controller.isFav(false);
                    }else{
                      controller.addToWishList(data.id, context);
                      controller.isFav(true);
                    }
                  },
                  icon: Icon(
                     Icons.favorite_outlined,
                    color: controller.isFav.value?redColor:darkFontGrey,
                  )),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VxSwiper.builder(
                          autoPlay: true,
                          height: 350,
                          itemCount: data['p_imgs'].length,
                          aspectRatio: 16 / 9,
                          viewportFraction: 1.0,
                          itemBuilder: (context, index) {
                            return Image.network(
                              data["p_imgs"][index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          }),
                      10.heightBox,
                      "${data['p_price']}".numCurrency.text
                          .size(16)
                          .color(darkFontGrey)
                          .fontFamily(semibold)
                          .make(),
                      10.heightBox,
                      VxRating(
                        isSelectable: false,
                        value: double.parse(data['p_rating']),
                        onRatingUpdate: (value) {},
                        normalColor: textfieldGrey,
                        selectionColor: golden,
                        count: 5,
                        size: 25,
                        stepInt: false,
                        maxRating: 5,
                      ),
                      10.heightBox,
                      "\$30,000"
                          .text
                          .color(redColor)
                          .fontFamily(bold)
                          .size(18)
                          .make(),
                      10.heightBox,
                      Row(
                        children: [
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Seller".text.white.fontFamily(semibold).make(),
                              5.heightBox,
                              "${data['p_seller']}"
                                  .text
                                  .fontFamily(semibold)
                                  .color(darkFontGrey)
                                  .size(16)
                                  .make(),
                            ],
                          )),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.message_rounded,
                              color: darkFontGrey,
                            ),
                          ).onTap(() {
                            Get.to(() => ChatScreen(),
                            arguments: [data['p_seller'], data['vendor_id']],
                            );
                          })
                        ],
                      )
                          .box
                          .height(60)
                          .padding(EdgeInsets.symmetric(horizontal: 16))
                          .color(textfieldGrey)
                          .make(),
                      20.heightBox,
                      Obx(() =>
                        Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Color: ".text.color(textfieldGrey).make(),
                                ),
                                Row(
                                  children: List.generate(
                                      data['p_colors'].length,
                                          (index) => Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          VxBox()
                                              .size(40, 40)
                                              .roundedFull
                                              .color(Color(data['p_colors'][index]).withOpacity(1.0))
                                              .margin(
                                              EdgeInsets.symmetric(horizontal: 6))
                                              .make()
                                              .onTap(() {
                                            controller.changeColorIndex(index);
                                          }),
                                          Visibility(
                                            visible: index == controller.colorIndex.value,
                                            child: Icon(Icons.done, color: Colors.white,),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Quantity: ".text.color(textfieldGrey).make(),
                                ),
                                Obx(() => Row(
                                    children: [
                                      IconButton(onPressed: (){
                                        controller.decreaseQuantity();
                                        controller.calculateTotalPrice(int.parse(data['p_price']));
                                      }, icon: Icon(Icons.remove)),
                                      controller.quantity.value.text.size(16).color(darkFontGrey).fontFamily(bold).make(),
                                      IconButton(onPressed: (){
                                        controller.increaseQuantity(int.parse(data['p_quantity']));
                                        controller.calculateTotalPrice(int.parse(data['p_price']));
                                      }, icon: Icon(Icons.add)),
                                      10.widthBox,
                                      "(${data['p_quantity']} available)".text.color(textfieldGrey).make()
                                    ]
                                ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: "Total".text.color(textfieldGrey).make(),
                                ),
                                "${controller.totalPrice.value}".numCurrency.text.color(redColor).size(16).fontFamily(bold).make()
                              ],
                            ).box.padding(EdgeInsets.all(8)).make(),
                          ],
                        ).box.white.shadowSm.make(),
                      ),
                      10.heightBox,
                      "Description".text.color(darkFontGrey).fontFamily(semibold).make(),
                      "${data['p_desc']}".text.color(darkFontGrey).make(),

                      10.heightBox,

                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: List.generate(
                            itemDetailsButtonList.length, (index) => ListTile(
                          title: "${itemDetailsButtonList[index]}".text.fontFamily(semibold).color(darkFontGrey).make(),
                          trailing: Icon(Icons.arrow_forward),
                        )),
                      ),
                      20.heightBox,
                      productsYouMayLike.text.fontFamily(bold).size(16).color(darkFontGrey).make(),
                      10.heightBox,
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              6,
                                  (index) => Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    imgP1,
                                    width: 150,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  "Laptop 4GB/64GB"
                                      .text
                                      .fontFamily(semibold)
                                      .color(darkFontGrey)
                                      .make(),
                                  "\$600"
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
                                  .make()),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ourButton(
                color: redColor,
                onPress: () {
                  if(controller.quantity.value > 0){
                    controller.addToCart(
                      title: data['p_name'],
                      color: data['p_colors'][controller.colorIndex.value],
                      img: data['p_imgs'][0],
                      vendorID: data['vendor_id'],
                      context: context,
                      qty: controller.quantity.value,
                      sellername: data['p_seller'],
                      tprice: controller.totalPrice.value,
                    );
                    VxToast.show(context, msg: "Added to cart");
                  }else{
                    VxToast.show(context, msg: "Minimum 1 product is required");
                  }
                },
                textColor: whiteColor,
                title: "Add to Cart",
              ),
            )
          ],
        ),
      ),
    );
  }
}
