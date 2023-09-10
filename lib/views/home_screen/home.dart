//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/home_controller.dart';
import 'package:qurban_seller/views/home_screen/home_screen.dart';
import 'package:qurban_seller/views/messages_screen/messages_screen.dart';
import 'package:qurban_seller/views/orders_screen/orders_screen.dart';
import 'package:qurban_seller/views/products_screen/products_screen.dart';
import 'package:qurban_seller/views/profile_screen/profile_screen.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var navScreens = [
      const OrdersScreen(),
      const ProductsScreen(),
      const MessagesScreen(),
      const ProfileScreen(),
    ];
    var bottomNavbar = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: dashboard),
      BottomNavigationBarItem(
          icon: Image.asset(
            icProducts,
            color: darkGrey,
            width: 24,
          ),
          label: products),
      BottomNavigationBarItem(
          icon: Icon(Icons.message_outlined),
          label: meesages),
      BottomNavigationBarItem(
          icon: Image.asset(icGeneralSettings, color: darkGrey, width: 24),
          label: settings),
    ];

    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (index) {
            controller.navIndex.value = index;
          },
          currentIndex: controller.navIndex.value,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: purpleColor,
          unselectedItemColor: darkGrey,
          items: bottomNavbar,
        ),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(child: navScreens.elementAt(controller.navIndex.value)),
          ],
        ),
      ),
    );
  }
}
