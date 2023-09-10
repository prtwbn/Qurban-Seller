import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/home_controller.dart';
import 'package:qurban_seller/models/category_model.dart';
import 'package:path/path.dart';
import 'package:qurban_seller/models/product_variation.dart';

class ProductsController extends GetxController {

  void setExistingImages(List<dynamic> images) {
  for (int i = 0; i < images.length; i++) {
    existingImages[i] = images[i];
  }
}

var existingImages = RxList<String>.generate(3, (index) => "");

void resetImages() {
  for (int i = 0; i < 3; i++) {
    pImagesList[i] = null;
    existingImages[i] = "";
  }
}

Future countTime()async{
   
}

void init() {
  // Reset semua field yang diperlukan
  pnameController.clear();
  pdescController.clear();
  ppriceController.clear();
  pquantityController.clear();
  resetImages();
  // Anda juga bisa melakukan set ulang nilai lain yang diperlukan
}

void deleteImage(int index) {
  pImagesList[index] = null; // Hapus gambar dari daftar lokal
  existingImages[index] = ""; // Hapus URL gambar yang ada
  update(); // Panggil ini jika Anda ingin perubahan diperbarui di UI
}
 
  var isloading = false.obs;
  //text field controllers

  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var pumurController = TextEditingController();
  var pjenishewanController = TextEditingController();
  var pjeniskelaminController = TextEditingController();
  var pberatController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();
  var psksController = TextEditingController();
  var categoryList = <String>[].obs;
  var subcategoryList = <String>[].obs;
  List<Category> category = [];
  var pImagesLinks = [];
  var pImagesList = RxList<dynamic>.generate(3, (index) => null);

  var categoryvalue = ''.obs;
  var subcategoryvalue = ''.obs;

  

  getCategories() async {
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var cat = categoryModelFromJson(data);
    category = cat.categories;
  }

  populateCategoryList() {
    categoryList.clear();

    for (var item in category) {
      categoryList.add(item.name);
    }
  }

  populateSubcategory(cat) {
    subcategoryList.clear();

    var data = category.where((element) => element.name == cat).toList();

    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  pickImage(index, context) async {
  try {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (img == null) {
      return;
    } else {
      var file = File(img.path);
      pImagesList[index] = file;
      existingImages[index] = ""; // Atur URL gambar yang ada menjadi kosong
    }
  } catch (e) {
    VxToast.show(context, msg: e.toString());
  }
}



  uploadImages() async {
  pImagesLinks.clear();
  for (int i = 0; i < pImagesList.length; i++) {
    var item = pImagesList[i];
    if (item != null) {
      var filename = basename(item.path);
      var destination = 'images/vendors/${currentUser!.uid}/$filename';
      Reference ref = FirebaseStorage.instance.ref().child(destination);
      await ref.putFile(item);
      var n = await ref.getDownloadURL();
      pImagesLinks.add(n);
    } else if (existingImages[i].isNotEmpty) {
      pImagesLinks.add(existingImages[i]); // Tambahkan gambar yang sudah ada jika tidak diubah
    }
  }
}


  updateProduct(docId, context) async {
  var store = firestore.collection(productsCollection).doc(docId);
  await uploadImages(); // Pastikan ini juga menangani gambar yang sudah ada
  await store.update({
    'p_name': pnameController.text,
    'p_desc': pdescController.text,
    'p_price': ppriceController.text,
    'p_quantity': pquantityController.text,
    'p_category': categoryvalue.value,
    'p_subcategory': subcategoryvalue.value,
    'p_imgs': pImagesLinks, // Ini seharusnya termasuk gambar baru dan yang sudah ada
  });
  isloading(false);
  VxToast.show(context, msg: "Product updated");
  Get.back();
}

  var selectedGender = 'Jantan'.obs;


  uploadProduct(context) async {
    var store = firestore.collection(productsCollection).doc();
    String docId = store.id;
    await uploadImages();
    await store.set({
      'product_id': docId,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_wishlist' : FieldValue.arrayUnion([]),
      //'p_name' : pnameController.text,
      'p_desc' : pdescController.text,
      'p_umur' : pumurController.text,
      'p_jenishewan' : pjenishewanController.text,
      'p_jeniskelamin': selectedGender.value,
      'p_berat' : pberatController.text,
      'p_price' : ppriceController.text,
      'p_quantity' : pquantityController.text,
      'p_sks' : psksController.text,
      'p_seller' : await Get.find<HomeController>().username,
      'p_rating' : "5.0",
      
      'vendor_id' : currentUser!.uid,
      //'p_variations': variations.map((v) => v.toJson()).toList(),
    });
    isloading(false);
    VxToast.show(context, msg: "Product uploaded");
  }
  

  removeProduct(docId) async {
    await firestore.collection(productsCollection).doc(docId).delete();
  }
}
