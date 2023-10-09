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
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ProductsController extends GetxController {
  void setExistingImages(List<dynamic> images) {
  for (int i = 0; i < images.length; i++) {
    if (i < existingImages.length) {
      existingImages[i] = images[i];
    } else {
      // Anda bisa menambahkan logika di sini jika jumlah gambar melebihi kapasitas,
      // misalnya menambahkan gambar ke existingImages atau memberi peringatan.
      print("Warning: Image $i is out of range.");
    }
  }
}

  var existingImages = RxList<String>.generate(9, (index) => "");

  void resetImages() {
    for (int i = 0; i < 9; i++) {
      pImagesList[i] = null;
      existingImages[i] = "";
    }
  }

  Future countTime() async {}

  void init() {
    // Reset semua field yang diperlukan
    pnameController.clear();
    pdescController.clear();
    pumurController.clear();
    pjenishewanController.clear();
    pjeniskelaminController.clear();
    pberatController.clear();
    ppriceController.clear();
    pquantityController.clear();
    psksController.clear();
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
  var pImagesList = RxList<dynamic>.generate(9, (index) => null);

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

  bool isFileSizeAboveLimit(File file, int limitInMB) {
    int fileSizeInBytes = file.lengthSync();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    return fileSizeInMB > limitInMB;
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) {
        return;
      } else {
        var file = File(img.path);
        if (isFileSizeAboveLimit(file, 1)) {
          final imgCompressed = await ImagePicker()
              .pickImage(source: ImageSource.gallery, imageQuality: 80);
          var fileCompressed = File(imgCompressed!.path);
          if (isFileSizeAboveLimit(fileCompressed, 1)) {
            // Kompresi ulang gambar dengan kualitas lebih rendah
            final imgAgain = await ImagePicker()
                .pickImage(source: ImageSource.gallery, imageQuality: 50);
            var fileAgain = File(imgAgain!.path);
            if (isFileSizeAboveLimit(fileAgain, 1)) {
              VxToast.show(context,
                  msg:
                      "Ukuran gambar terlalu besar, silahkan unggah foto lain atau kompresi foto Anda hingga kurang dari 1MB.");
              return;
            } else {
              pImagesList[index] = fileAgain;
              existingImages[index] = "";
            }
          } else {
            pImagesList[index] = fileCompressed;
            existingImages[index] = "";
          }
        } else {
          pImagesList[index] = file;
          existingImages[index] = "";
        }
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  uploadImages() async {
    // Pengecekan jika tidak ada gambar untuk diunggah
    if (pImagesList.isEmpty && existingImages.every((img) => img.isEmpty)) {
      VxToast.show(context as BuildContext,
          msg: "Setidaknya Anda harus mengunggah 1 gambar!");
      return;
    }

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
      } else if (existingImages.length > i && existingImages[i].isNotEmpty) {
        pImagesLinks.add(existingImages[
            i]); // Tambahkan gambar yang sudah ada jika tidak diubah
      }
    }
  }

  updateProduct(docId, context) async {
    errorMessages.clear();

    // Check and add error messages for missing fields
    if (categoryvalue.isEmpty) {
      errorMessages.add("Pilih Category terlebih dahulu");
    }
    if (subcategoryvalue.isEmpty) {
      errorMessages.add("Pilih Subcategory terlebih dahulu");
    }
    if (pjenishewanController.text.trim().isEmpty) {
      errorMessages.add("Kolom jenis hewan harus diisi");
    }
    if (pdescController.text.trim().isEmpty) {
      errorMessages.add("Kolom deskripsi harus diisi");
    }
    if (pumurController.text.trim().isEmpty) {
      errorMessages.add("Kolom umur harus diisi");
    }
    if (pberatController.text.trim().isEmpty) {
      errorMessages.add("Kolom Berat harus diisi");
    }
    if (ppriceController.text.trim().isEmpty ||
        !validatePriceInput(ppriceController.text.trim())) {
      errorMessages.add("Kolom Harga harus diisi dengan angka tanpa titik!");
    }
    if (pquantityController.text.trim().isEmpty) {
      errorMessages.add("Kolom kuantitas harus diisi");
    }
    if (psksController.text.trim().isEmpty) {
      errorMessages.add("Kolom surat keterangan sehat harus diisi");
    }
    if (pImagesList.isEmpty && existingImages.every((img) => img.isEmpty)) {
      errorMessages.add("Gambar tidak boleh kosong");
    }
    if (pImagesLinks.isEmpty ||
        (pImagesLinks.length == 1 && pImagesLinks[0] == "")) {
      errorMessages.add("Anda harus mengunggah setidaknya 1 gambar!");
    }

    // If there are error messages, show them and don't proceed
    if (errorMessages.isNotEmpty) {
      showErrorDialog(context, errorMessages);
      isloading(false);
      return;
    }
    var store = firestore.collection(productsCollection).doc(docId);
    await uploadImages(); // Pastikan ini juga menangani gambar yang sudah ada
    await store.update({
      'timestamp': FieldValue.serverTimestamp(),
      'p_name': pnameController.text,
      'p_desc': pdescController.text,
      'p_umur': pumurController.text,
      'p_jenishewan': pjenishewanController.text,
      'p_jeniskelamin': selectedGender.value,
      'p_berat': pberatController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
      'p_sks': psksController.text,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_imgs':
          pImagesLinks, // Ini seharusnya termasuk gambar baru dan yang sudah ada
    });
    isloading(false);
    VxToast.show(context, msg: "Product updated");
    Get.back();
  }

  var selectedGender = 'Jantan'.obs;
  void showErrorDialog(BuildContext context, List<String> errorMessages) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Perhatian !"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: errorMessages.map((message) {
              return ListTile(
                title: Text(message),
              );
            }).toList(),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  List<String> errorMessages = [];

  uploadProduct(context) async {
    // Clear previous error messages
    errorMessages.clear();

    // Check and add error messages for missing fields
    if (categoryvalue.isEmpty) {
      errorMessages.add("Pilih Category terlebih dahulu");
    }
    if (subcategoryvalue.isEmpty) {
      errorMessages.add("Pilih Subcategory terlebih dahulu");
    }
    if (pjenishewanController.text.trim().isEmpty) {
      errorMessages.add("Kolom jenis hewan harus diisi");
    }
    if (pdescController.text.trim().isEmpty) {
      errorMessages.add("Kolom deskripsi harus diisi");
    }
    if (pumurController.text.trim().isEmpty) {
      errorMessages.add("Kolom umur harus diisi");
    }
    if (pberatController.text.trim().isEmpty) {
      errorMessages.add("Kolom Berat harus diisi");
    }
    if (ppriceController.text.trim().isEmpty ||
        !validatePriceInput(ppriceController.text.trim())) {
      errorMessages.add("Kolom Harga harus diisi dengan angka tanpa titik!");
    }
    if (pquantityController.text.trim().isEmpty) {
      errorMessages.add("Kolom kuantitas harus diisi");
    }
    if (psksController.text.trim().isEmpty) {
      errorMessages.add("Kolom surat keterangan sehat harus diisi");
    }
    if (pImagesList.isEmpty && existingImages.every((img) => img.isEmpty)) {
      errorMessages.add("Gambar tidak boleh kosong");
    }
    if (pImagesLinks.isEmpty ||
        (pImagesLinks.length == 1 && pImagesLinks[0] == "")) {
      errorMessages.add("Anda harus mengunggah setidaknya 1 gambar!");
    }

    // If there are error messages, show them and don't proceed
    if (errorMessages.isNotEmpty) {
      showErrorDialog(context, errorMessages);
      isloading(false);
      return;
    }

    // If there are no error messages, continue with uploading
    var store = firestore.collection(productsCollection).doc();
    String docId = store.id;
    await uploadImages();
    await store.set({
      'timestamp': FieldValue.serverTimestamp(),
      'product_id': docId,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_wishlist': FieldValue.arrayUnion([]),
      //'p_name' : pnameController.text,
      'p_desc': pdescController.text,
      'p_umur': pumurController.text,
      'p_jenishewan': pjenishewanController.text,
      'p_jeniskelamin': selectedGender.value,
      'p_berat': pberatController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
      'p_sks': psksController.text,
      'p_seller': await Get.find<HomeController>().username,
      'p_rating': "5.0",

      'vendor_id': currentUser!.uid,
      //'p_variations': variations.map((v) => v.toJson()).toList(),
    });
    isloading(false);
    VxToast.show(context, msg: "Product uploaded");
  }

  bool isValidForm(BuildContext context) {
    if (!validatePriceInput(ppriceController.text.trim())) {
      VxToast.show(context, msg: "Isi semua kolom, Harga hanya boleh berisi angka tanpa titik!");
      return false;
    }
    // Anda bisa menambahkan validasi lainnya di sini jika diperlukan
    return true;
  }

  bool validatePriceInput(String input) {
    final RegExp regExp = RegExp(r'^[0-9]+$'); // Hanya boleh berisi angka
    return regExp.hasMatch(input);
  }

  

  removeProduct(docId) async {
    await firestore.collection(productsCollection).doc(docId).delete();
  }
}
