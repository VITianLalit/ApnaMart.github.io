import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/consts/lists.dart';
import 'package:apna_mart/controllers/auth_controller.dart';
import 'package:apna_mart/controllers/profile_controller.dart';
import 'package:apna_mart/services/firestore_services.dart';
import 'package:apna_mart/views/auth_screen/login_screen.dart';
import 'package:apna_mart/views/chat_screen/messaging_screen.dart';
import 'package:apna_mart/views/orders_screen/orders_screen.dart';
import 'package:apna_mart/views/profile_screen/components/details_cart.dart';
import 'package:apna_mart/views/profile_screen/edit_profile_screen.dart';
import 'package:apna_mart/views/wishlist_screen/wishlist_screen.dart';
import 'package:apna_mart/widgets_common/bg_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return bgWidget(
        child: Scaffold(
      body: StreamBuilder(
        stream: FirestoreServices.getUser(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(redColor),
              ),
            );
          } else {
            var data = snapshot.data!.docs[0];
            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.edit,
                          color: whiteColor,
                        )).onTap(() {
                      controller.nameController.text = data['name'];
                      // controller.passController.text = data['password'];
                      Get.to(() => EditProfileScreen(
                            data: data,
                          ));
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        data['imageUrl'] == ''
                            ? Image.asset(
                                imgProfile2,
                                width: 130,
                                fit: BoxFit.cover,
                              ).box.roundedFull.clip(Clip.antiAlias).make()
                            : Image.network(
                                data['imageUrl'],
                                width: 100,
                                fit: BoxFit.cover,
                              ).box.roundedFull.clip(Clip.antiAlias).make(),
                        10.widthBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data['name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .white
                                  .make(),
                              "${data['email']}".text.white.make(),
                            ],
                          ),
                        ),
                        OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                side: BorderSide(
                              color: whiteColor,
                            )),
                            onPressed: () async {
                              await Get.put(AuthController())
                                  .signoutMethod(context);
                              Get.offAll(() => LoginScreen());
                            },
                            child: "Log Out"
                                .text
                                .fontFamily(semibold)
                                .white
                                .make()),
                      ],
                    ),
                  ),
                  20.heightBox,
                  FutureBuilder(
                    future: FirestoreServices.getCounts(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      print('Hello Wrod');
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(whiteColor),
                          ),
                        );
                      } else {
                        var countData = snapshot.data;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            detailsCard(
                                count: countData[0].toString(),
                                title: "in your cart",
                                width: context.screenWidth / 3.4),
                            detailsCard(
                                count: countData[1].toString(),
                                title: "in your wishlist",
                                width: context.screenWidth / 3.4),
                            detailsCard(
                                count: countData[2].toString(),
                                title: "your orders",
                                width: context.screenWidth / 3.4),
                          ],
                        );
                      }
                    },
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   children: [
                  //     detailsCard(
                  //         count: data['cart_count'],
                  //         title: "in your cart",
                  //         width: context.screenWidth / 3.4),
                  //     detailsCard(
                  //         count: data['wishlist_count'],
                  //         title: "in your wishlist",
                  //         width: context.screenWidth / 3.4),
                  //     detailsCard(
                  //         count: data['order_count'],
                  //         title: "your orders",
                  //         width: context.screenWidth / 3.4),
                  //   ],
                  // ),
                  ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: lightGrey,
                      );
                    },
                    itemCount: profileButtonList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Get.to(() => OrdersScreen());
                              break;
                            case 1:
                              Get.to(() => WishlistScreen());
                              break;
                            case 2:
                              Get.to(() => MessagesScreen());
                              break;
                          }
                        },
                        leading: Image.asset(
                          profileButtonsIcon[index],
                          width: 22,
                        ),
                        title: profileButtonList[index]
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                      );
                    },
                  )
                      .box
                      .white
                      .rounded
                      .margin(EdgeInsets.all(12))
                      .padding(EdgeInsets.symmetric(horizontal: 16))
                      .shadowSm
                      .make()
                      .box
                      .color(redColor)
                      .make(),
                ],
              ),
            );
          }
        },
      ),
    ));
  }
}
