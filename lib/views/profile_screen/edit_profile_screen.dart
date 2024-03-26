import 'dart:io';

import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/controllers/profile_controller.dart';
import 'package:apna_mart/widgets_common/bg_widget.dart';
import 'package:apna_mart/widgets_common/custom_textfield.dart';
import 'package:apna_mart/widgets_common/our_button.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  final dynamic data;

  EditProfileScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    return bgWidget(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            data['imageUrl'] == '' && controller.profileImgPath.isEmpty
                ? Image.asset(
                    imgProfile2,
                    width: 130,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make()
                : data['imageUrl'] != '' && controller.profileImgPath.isEmpty?
                Image.network(data['imageUrl'],
                  width: 100,
                  fit: BoxFit.cover,
                ).box.roundedFull.clip(Clip.antiAlias).make():
            Image.file(
                    File(controller.profileImgPath.value),
                    width: 100,
                    fit: BoxFit.cover,
                  ).box.roundedFull.clip(Clip.antiAlias).make(),
            10.heightBox,
            ourButton(
                color: redColor,
                onPress: () {
                  controller.changeImage(context);
                },
                textColor: whiteColor,
                title: "Change"),
            Divider(),
            20.heightBox,
            customTextField(controller: controller.nameController,hint: nameHint, title: name, isPass: false),
            10.heightBox,
            customTextField(controller: controller.oldPassController, hint: passwordHint, title: oldPass, isPass: true),
            10.heightBox,
            customTextField(controller: controller.newPassController, hint: passwordHint, title: newPass, isPass: true),
            20.heightBox,
            controller.isLoading.value? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(redColor),
            ):
            SizedBox(
                width: context.screenWidth - 40,
                child: ourButton(
                    color: redColor,
                    onPress: () async{
                      controller.isLoading(true);
                      //  if Image is not selelcted
                      if(controller.profileImgPath.value.isNotEmpty){
                        await controller.uploadProfileImage();
                      }else{
                        controller.profileImageLink = data['imageUrl'];
                      }
                      // if old password matches database
                      if(data['password'] == controller.oldPassController.text){
                        await controller.changeAuthPassword(email: data['email'], password: controller.oldPassController.text, newPassword: controller.newPassController.text);
                        await controller.updateProfile(
                          imgUrl: controller.profileImageLink,
                          name: controller.nameController.text,
                          password: controller.newPassController.text,
                        );
                        VxToast.show(context, msg: "Updated");
                      }else{
                        VxToast.show(context, msg: "Wrong old password");
                        controller.isLoading(false);
                      }
                    },
                    textColor: whiteColor,
                    title: "Save")),
          ],
        )
            .box
            .white
            .shadowSm
            .padding(EdgeInsets.all(16))
            .margin(EdgeInsets.only(top: 50, left: 12, right: 12))
            .rounded
            .make(),
      ),
    ));
  }
}
