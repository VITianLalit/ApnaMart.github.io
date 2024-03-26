import 'dart:async';
import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/views/auth_screen/login_screen.dart';
import 'package:apna_mart/views/home_screen/home.dart';
import 'package:apna_mart/widgets_common/applogo_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(const Duration(seconds: 3),() {
      auth.authStateChanges().listen((User? user) {
        if(user == null && mounted){
          Get.to(()=> LoginScreen());
        }else{
          Get.to(() => Home());
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: applogoWidget()),
                10.heightBox,
                appname.text.size(22).fontFamily(bold).white.make(),
                const SizedBox(
                  height: 5,
                ),
                appversion.text.white.make(),
              ],
            ),
          ),
          credits.text.white.fontFamily(semibold).make(),
          30.heightBox,
        ],
      ),
    );
  }
}
