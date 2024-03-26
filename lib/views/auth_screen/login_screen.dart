import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/consts/lists.dart';
import 'package:apna_mart/controllers/auth_controller.dart';
import 'package:apna_mart/views/auth_screen/signup_screen.dart';
import 'package:apna_mart/views/home_screen/home.dart';
import 'package:apna_mart/widgets_common/applogo_widget.dart';
import 'package:apna_mart/widgets_common/bg_widget.dart';
import 'package:apna_mart/widgets_common/custom_textfield.dart';
import 'package:apna_mart/widgets_common/our_button.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (MediaQuery.of(context).size.height * 0.1).heightBox,
            applogoWidget(),
            SizedBox(
              height: 10,
            ),
            "Log in to $appname".text.fontFamily(bold).white.size(18).make(),
            SizedBox(
              height: 15,
            ),
            Obx(
              () => Column(
                children: [
                  customTextField(
                      hint: emailHint,
                      title: email,
                      isPass: false,
                      controller: controller.emailController),
                  customTextField(
                      hint: passwordHint,
                      title: password,
                      isPass: true,
                      controller: controller.passwordController),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: forgetPass.text.make(),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  controller.isLoading.value
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(redColor),
                        )
                      : ourButton(
                              color: redColor,
                              title: login,
                              textColor: whiteColor,
                              onPress: () async {
                                controller.isLoading(true);
                                await controller
                                    .loginMethod(context: context)
                                    .then((value) {
                                  if (value != null) {
                                    VxToast.show(context, msg: loggedin);
                                    Get.offAll(() => Home());
                                  } else {
                                    controller.isLoading(false);
                                  }
                                });
                              })
                          .box
                          .width(MediaQuery.of(context).size.width - 50)
                          .make(),
                  SizedBox(
                    height: 5,
                  ),
                  createNewAccount.text.color(fontGrey).make(),
                  SizedBox(
                    height: 5,
                  ),
                  ourButton(
                          color: lightGolden,
                          title: signup,
                          textColor: redColor,
                          onPress: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()));
                          })
                      .box
                      .width(MediaQuery.of(context).size.width - 50)
                      .make(),
                  SizedBox(
                    height: 10,
                  ),
                  loginWith.text.color(fontGrey).make(),
                  5.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        3,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: lightGrey,
                                radius: 25,
                                child: Image.asset(
                                  socialIconList[index],
                                  width: 30,
                                ),
                              ),
                            )),
                  )
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(EdgeInsets.all(16))
                  .width(MediaQuery.of(context).size.width - 70)
                  .shadowSm
                  .make(),
            ),
          ],
        ),
      ),
    ));
  }
}
