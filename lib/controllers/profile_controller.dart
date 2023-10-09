import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:path/path.dart';

class ProfileController extends GetxController {
  late QueryDocumentSnapshot snapshotData;
  var profileImgPath = ''.obs;
  var profileImageLink = '';
  var isloading = false.obs;

  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  var shopNameController = TextEditingController();
  var shopAdressController = TextEditingController();
  var shopMobileController = TextEditingController();
  var shopDescController = TextEditingController();

  Future<File> compressImage(File file) async {
    int targetSize = 1024 * 1024; // 1MB
    var quality = 90;

    while (await file.length() > targetSize && quality > 10) {
      File? result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        file.path,
        quality: quality,
      ) as File?;

      if (result != null) {
        file = result;
        quality -= 5;
      } else {
        break; // Keluar dari loop jika hasil kompresi null
      }
    }

    return file;
  }

  changeImage(context) async {
    try {
      final XFile? xFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (xFile == null) return;

      File file = File(xFile.path); // Konversi XFile ke File di sini
      if (await file.length() > 1024 * 1024) {
        file = await compressImage(file);
        profileImgPath.value = file.path;
      } else {
        profileImgPath.value = xFile.path;
      }
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadProfileImage() async {
    var filename = basename(profileImgPath.value);
    var destination = 'images/${currentUser!.uid}/$filename';
    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImgPath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  updateProfile({name, imgUrl}) async {
    var store = firestore.collection(vendorsCollection).doc(currentUser!.uid);
    await store.set({'name': name, 'imageUrl': imgUrl},
        SetOptions(merge: true));
    isloading(false);
  }
  
  updatePw({password}) async {
    var store = firestore.collection(vendorsCollection).doc(currentUser!.uid);
    await store.set({'password': password},
        SetOptions(merge: true));
    isloading(false);
  }

  changeAuthPassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);

    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error) {
      print(error.toString());
    });
  }

  Future<LatLng> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    await Geolocator.requestPermission();

    return LatLng(position.latitude, position.longitude);
  }

  void saveVendorLocation(LatLng position) {
    final store = FirebaseFirestore.instance
        .collection(vendorsCollection)
        .doc(currentUser!.uid);
    store.set(
      {
        //'shop_name': shopNameController.text,
        //'shop_address': shopAdressController.text,
        //'shop_mobile': shopMobileController.text,
        //'shop_desc': shopDescController.text,
        'vendor_location': GeoPoint(position.latitude, position.longitude),
      },
      SetOptions(merge: true),
    );
    isloading(false);
  }

  updateShop({shopname, shopaddress, shopmobile, shopdesc}) async {
    var store = firestore.collection(vendorsCollection).doc(currentUser!.uid);
    await store.set({
      'shop_name': shopname,
      //'shop_address' : shopaddress,
      'shop_mobile': shopmobile,
      'shop_desc': shopdesc,
    }, SetOptions(merge: true));
    isloading(false);
  }
}
