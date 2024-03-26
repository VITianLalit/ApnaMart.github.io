import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/controllers/auth_controller.dart';
import 'package:apna_mart/views/home_screen/home.dart';
import 'package:apna_mart/widgets_common/applogo_widget.dart';
import 'package:apna_mart/widgets_common/bg_widget.dart';
import 'package:apna_mart/widgets_common/custom_textfield.dart';
import 'package:apna_mart/widgets_common/our_button.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  // text controller
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passworRetypeController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return bgWidget( child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (MediaQuery.of(context).size.height * 0.1).heightBox,
            applogoWidget(),
            const SizedBox(
              height: 10,
            ),
            "Joint the $appname".text.fontFamily(bold).white.size(18).make(),
            const SizedBox(
              height: 15,
            ),
            Obx(
              () => Column(
                children: [
                  customTextField(hint: nameHint, title: name, controller: nameController, isPass: false),
                  customTextField(hint: emailHint, title: email, controller: emailController, isPass: false),
                  customTextField(hint: passwordHint, title: password, controller: passwordController, isPass: true),
                  customTextField(hint: passwordHint, title: retypePassword, controller: passworRetypeController, isPass: true),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: forgetPass.text.make(),
                    ),
                  ),

                  Row(
                    children: [
                      Checkbox(
                          checkColor: whiteColor,
                          activeColor: redColor,
                          value: isCheck,
                          onChanged: (newValue) {
                            isCheck = newValue;
                            setState(() {

                            });
                          }),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: RichText(
                            text: const TextSpan(children: [
                          TextSpan(
                            text: "I agree to the ",
                            style: TextStyle(
                              fontFamily: bold,
                              color: fontGrey,
                            ),
                          ),
                          TextSpan(
                            text: termAndCond,
                            style: TextStyle(
                              fontFamily: bold,
                              color: redColor,
                            ),
                          ),
                          TextSpan(
                            text: " & ",
                            style: TextStyle(
                              fontFamily: bold,
                              color: fontGrey,
                            ),
                          ),
                          TextSpan(
                            text: privacyPolicy,
                            style: TextStyle(
                              fontFamily: bold,
                              color: redColor,
                            ),
                          ),
                        ])),
                      )
                    ],
                  ),
                  controller.isLoading.value? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(redColor),
                  ): ourButton(
                      color: isCheck == true? redColor: lightGrey,
                      title: signup,
                      textColor:isCheck == false? redColor: whiteColor,
                      onPress: () async{
                        if(isCheck != false){
                          controller.isLoading(true);
                          try{
                            await controller.signupMethod(context: context, email: emailController.text, password: passwordController.text).then((value){
                              return controller.storedUserData(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                              );
                            }).then((value){
                              VxToast.show(context, msg: loggedin);
                              Get.offAll(()=> Home());
                            });
                          }catch(e){
                            auth.signOut();
                            VxToast.show(context, msg: e.toString());
                            controller.isLoading(false);
                          }
                        }
                      })
                      .box
                      .width(MediaQuery.of(context).size.width - 50)
                      .make(),
                  10.heightBox,
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: alreadyHaveAccount,
                            style: TextStyle(
                              fontFamily: bold,
                              color: fontGrey,
                            )
                          ),
                          TextSpan(
                              text: login,
                              style: TextStyle(
                                fontFamily: bold,
                                color: redColor,
                              )
                          )
                        ]
                      ),
                    ),
                  )
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
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
