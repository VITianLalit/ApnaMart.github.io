import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/consts/lists.dart';
import 'package:apna_mart/controllers/cart_controller.dart';
import 'package:get/get.dart';

import '../../widgets_common/our_button.dart';
import '../home_screen/home.dart';

class PaymentsMethods extends StatelessWidget {
  const PaymentsMethods({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(redColor),),): ourButton(
            onPress: () async {
              await controller.placeMyOrder(orderPaymentMethod: paymentMethods[controller.paymentIndex.value], totalAmount: controller.totalP.value);
              await controller.clearCart();
              VxToast.show(context, msg: "Order Placed Successfully");
              Get.offAll(Home());
              },
            color: redColor,
            textColor: whiteColor,
            title: "Place my order",
          ),
        ),
        appBar: AppBar(
          elevation: 0,
          title: "Choose Payment Method"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(() =>
            Column(
                children: List.generate(paymentMethodsListImg.length, (index) {
              return GestureDetector(
                onTap: (){
                  controller.changePaymentIndex(index);
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        style: BorderStyle.solid,
                        color:controller.paymentIndex.value==index? redColor: Colors.transparent,
                        width: 3,
                      )),
                  margin: EdgeInsets.only(bottom: 8),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.asset(
                        paymentMethodsListImg[index],
                        width: double.infinity,
                        height: 120,
                        colorBlendMode:controller.paymentIndex.value == index?  BlendMode.darken: BlendMode.color,
                        color: controller.paymentIndex.value == index? Colors.black.withOpacity(0.5): Colors.transparent,
                        fit: BoxFit.cover,
                      ),
                      controller.paymentIndex.value == index? Transform.scale(
                        scale:1.3,
                        child: Checkbox(
                          activeColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                            value: true,
                            onChanged: (value) {}
                        ),
                      ):
                          Container(),
                      Positioned(
                        right: 10,
                        bottom: 0,
                          child: paymentMethods[index].text.white.fontFamily(semibold).size(16).make()
                      ),
                    ],
                  ),
                ),
              );
            })),
          ),
        ),
      ),
    );
  }
}
