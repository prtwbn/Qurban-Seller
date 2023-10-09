//import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/controllers/home_controller.dart';
import 'package:qurban_seller/views/auth_screen/forgot_password.dart';
import 'package:qurban_seller/views/auth_screen/login_screen.dart';

class AuthController extends GetxController {
  User? currentUser;

  var isloading = false.obs;
  //textcontrollers
  final RxBool showPassword = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  //login method

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      VxToast.show(context, msg: "Silahkan isi email dan password");
      return null;
    }
     QuerySnapshot users = await firestore
        .collection(vendorsCollection)
        .where('email', isEqualTo: emailController.text)
        .get();
    if (users.docs.isEmpty) {
      VxToast.show(context, msg: "Email tidak ditemukan dalam daftar penjual");
      return null;
    }
    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (userCredential != null) {
        Get.find<HomeController>().getUsername(); // perbarui nama pengguna setelah login berhasil
      }
      currentUser = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        VxToast.show(context, msg: "Email tidak terdaftar");
      } else if (e.code == 'invalid-email') {
        VxToast.show(context,
            msg: "Format email salah, silahkan masukkan email yang benar");
      } else if (e.code == 'wrong-password') {
        VxToast.show(context,
            msg: "Password salah, masukkan password yang benar");
      } else {
        VxToast.show(context, msg: e.toString());
      }
    }
    return userCredential;
}

  //signup method
  //signup method
  Future<UserCredential?> signupMethod(
      {required String email,
      required String password,
      required BuildContext context}) async {
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
  signoutMethod() async {
    try {
      await auth.signOut();
      emailController.clear();
      passwordController.clear();
      currentUser = null;
      await auth.userChanges().listen((user) {
        if (user == null) {
          Get.off(() => const LoginScreen());
        }
      });
    } catch (e) {
      VxToast.show(Get.context!, msg: e.toString());
    }
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim())
          .then((_) {
        VxToast.show(Get.overlayContext!,
            msg: "Password reset email terkirim. Silahkan periksa email anda.");
      });
    } catch (e) {
      VxToast.show(Get.overlayContext!,
          msg: "Gagal mengirim email reset password. Silahkan coba lagi.");
    }
  }

  void navigateToPasswordResetPage() {
    Get.to(() => PasswordResetScreen());
  }
}
