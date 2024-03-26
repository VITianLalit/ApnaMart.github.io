import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/controllers/home_controller.dart';
import 'package:apna_mart/views/cart_screen/cart_screen.dart';
import 'package:apna_mart/views/category_screen/category_screen.dart';
import 'package:apna_mart/views/home_screen/home_screen.dart';
import 'package:apna_mart/views/profile_screen/profile_screen.dart';
import 'package:apna_mart/widgets_common/exit_dialog.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var controller = Get.put(HomeController());

  var navbarItem = [
    BottomNavigationBarItem(icon: Image.asset(icHome, width: 26,), label: home),
    BottomNavigationBarItem(icon: Image.asset(icCategories, width: 26,), label: categories),
    BottomNavigationBarItem(icon: Image.asset(icCart, width: 26,), label: cart),
    BottomNavigationBarItem(icon: Image.asset(icProfile, width: 26,), label: account),
  ];

  var navBody = [
    const HomeScreen(),
    const CategoryScreen(),
    const CartScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:() async{
        showDialog(barrierDismissible: false ,context: context, builder: (context) => exitDialog(context));
        return false;
      },
      child: Scaffold(
        body: Column(
          children: [
            Obx(() => Expanded(child: navBody.elementAt(controller.currentNavIndex.value),)),
          ],
        ),
        bottomNavigationBar: Obx(
            () => BottomNavigationBar(
              currentIndex: controller.currentNavIndex.value,
              selectedItemColor: redColor,
              selectedLabelStyle: const TextStyle(fontFamily: semibold),
              type: BottomNavigationBarType.fixed,
              backgroundColor: whiteColor,
              items: navbarItem,
              onTap: (value){
                controller.currentNavIndex.value = value;
              },
            ),
        ),
      ),
    );
  }
}
