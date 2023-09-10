//import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/controllers/home_controller.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
  //textcontrollers
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //login method

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (userCredential != null) {
        Get.find<HomeController>().getUsername(); // perbarui nama pengguna setelah login berhasil
      }
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
}


  //signup method
   //signup method
  Future<UserCredential?> signupMethod(
      {required String email, required String password, required BuildContext context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
          currentUser = userCredential.user;
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }


  //storing data method
  storeUserData({name, password, email}) async {
    DocumentReference store =
        firestore.collection(vendorsCollection).doc(currentUser!.uid);
    store.set({
      'name': name,
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid,
    });
  }

  //signout method
  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(Get.context!, msg: e.toString());
    }
  }
}
