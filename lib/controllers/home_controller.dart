import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getUsername();
  }

  var navIndex = 0.obs;
  var username = '';

  getUsername() async {
    var n = await firestore
        .collection(vendorsCollection)
        .where('id', isEqualTo: currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.single['name'];
      }
      return '';
    });

    username = n ;
    update();
  }
}
