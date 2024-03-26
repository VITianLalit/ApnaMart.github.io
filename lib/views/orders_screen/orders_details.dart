import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/views/orders_screen/components/order_place_details.dart';
import 'package:apna_mart/views/orders_screen/components/order_status.dart';
import 'package:intl/intl.dart' as intl;

class OrdersDetails extends StatelessWidget {
  final dynamic data;
  const OrdersDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Order Details".text.fontFamily(semibold).color(darkFontGrey).make(),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              orderStatus(
                color: redColor, icon: Icons.done, title: "Placed", showDone: data['order_placed'],
              ),
              orderStatus(
                color: Colors.blue, icon: Icons.thumb_up, title: "Confirmed", showDone: data['order_confirmed'],
              ),
              orderStatus(
                color: Colors.yellow, icon: Icons.car_crash, title: "On Delivery", showDone: data['order_on_delivey'],
              ),
              orderStatus(
                color: Colors.purple, icon: Icons.done_all_rounded, title: "Delivered", showDone: data['order_delivered'],
              ),

              Divider(),
              10.heightBox,
              Column(
                children: [
                  orderPlaceDetails(
                    d1: data['order_code'],
                    d2: data['shipping_method'],
                    title1: "Order Code",
                    title2: "Shipping Method",
                  ),
                  orderPlaceDetails(
                    d1: intl.DateFormat().add_yMd().format(data['order_date'].toDate()),
                    d2: data['payment_method'],
                    title1: "Order Date",
                    title2: "Payment Method",
                  ),
                  orderPlaceDetails(
                    d1: "Unpaid",
                    d2: "Order Placed",
                    title1: "Payment Status",
                    title2: "Delivery Status",
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Shipping Address".text.fontWeight(FontWeight.bold).make(),
                            "${data['order_by_name']}".text.make(),
                            "${data['order_by_email']}".text.make(),
                            "${data['order_by_address']}".text.make(),
                            "${data['order_by_city']}".text.make(),
                            "${data['order_by_state']}".text.make(),
                            "${data['order_by_phone']}".text.make(),
                            "${data['order_by_postalcode']}".text.make(),
                          ],
                        ),
                        SizedBox(
                          width: 125,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Total Amount".text.fontWeight(FontWeight.bold).make(),
                              "${data['total_amount']}".text.color(redColor).make(),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ).box.outerShadowMd.white.make(),
              Divider(),
              10.heightBox,
              "Ordered Product".text.size(16).color(darkFontGrey).fontWeight(FontWeight.bold).makeCentered(),
              10.heightBox,
              ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: List.generate(data['orders'].length, (index){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      orderPlaceDetails(
                        title1: data['orders'][index]['title'],
                        title2: data['orders'][index]['tprice'],
                        d1: "${data['orders'][index]['qty']}",
                        d2: "Refundable"
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Container(
                          width: 30,
                          height: 20,
                          color: Color(data['orders'][index]['color']),
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }).toList(),
              ).box.outerShadowMd.white.margin(EdgeInsets.only(bottom: 4)).make(),
              20.heightBox,

            ],
          ),
        ),
      ),
    );
  }
}
