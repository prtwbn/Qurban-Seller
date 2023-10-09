//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/products_controller.dart';
import 'package:qurban_seller/views/products_screen/components/product_dropdown.dart';
import 'package:qurban_seller/views/products_screen/components/product_images.dart';
import 'package:qurban_seller/views/widgets/custom_textfield.dart';
import 'package:qurban_seller/views/widgets/loading_indicator.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

class EditProduct extends StatelessWidget {
  final DocumentSnapshot data;

  const EditProduct({Key? key, required this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());
    controller.resetImages();
    controller.setExistingImages(data['p_imgs']);
    controller.pjenishewanController.text = data['p_jenishewan'];
    controller.pdescController.text = data['p_desc'];
    controller.pumurController.text = data['p_umur'];
    controller.pberatController.text = data['p_berat'];
    controller.psksController.text = data['p_sks'];
    controller.ppriceController.text = data['p_price'];
    controller.pquantityController.text = data['p_quantity'].toString();
    controller.selectedGender.value = data['p_jeniskelamin'];
    controller.categoryvalue.value = data['p_category'];
    controller.subcategoryvalue.value = data['p_subcategory'];
    controller.getCategories();
    controller.populateCategoryList();
    return Obx(
      () => Scaffold(
        backgroundColor: Color.fromRGBO(239, 239, 239, 1),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),color: black),
          title: boldText(text: "Ubah Produk", size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      if (controller.isValidForm(context)) {
                        controller.isloading(true);
                        await controller.uploadImages();
                        await controller.updateProduct(data.id, context);
                      }
                    },
                    child: boldText(text: "Simpan", color: black),
                  )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productDropDown("Category", controller.categoryList,
                    controller.categoryvalue, controller),
                10.heightBox,
                 Obx(() => productDropDown("Subcategory", controller.subcategoryList, controller.subcategoryvalue, controller)),
                10.heightBox,
                Obx(
                  () => DropdownButton<String>(
                    value: controller.selectedGender.value,
                    onChanged: (String? newValue) {
                      controller.selectedGender.value = newValue!;
                    },
                    items: <String>['Jantan', 'Betina']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                10.heightBox,
                customtTextField(
                    hint: "eg. Kambing Etawa",
                    label: "Jenis hewan",
                    controller: controller.pjenishewanController),
                10.heightBox,
                customtTextField(
                    hint: "eg. Nice Product",
                    label: "Deskripsi",
                    isDesc: true,
                    controller: controller.pdescController),
                10.heightBox,
                customtTextField(
                    hint: "eg. 1 tahun 2 bulan",
                    label: "Umur hewan",
                    controller: controller.pumurController),
                10.heightBox,
                customtTextField(
                    hint: "eg. 20,5 kg",
                    label: "Berat",
                    controller: controller.pberatController),
                10.heightBox,
                customtTextField(
                  hint: "eg. 1500000 (tanpa titik)",
                  label: "Harga",
                  controller: controller.ppriceController,
                  keyboardType: TextInputType.number, // Hanya boleh angka
                ),
                10.heightBox,
                customtTextField(
                    hint: "eg. 20",
                    label: "Quantity",
                    controller: controller.pquantityController),
                10.heightBox,
                customtTextField(
                    hint: "Ada (jika ada lampirkan) atau Tidak ada",
                    label: "Apakah memiliki Surat Keterangan Sehat ?",
                    controller: controller.psksController),
                20.heightBox,
                normalText(
                    text:
                        "Kolom tidak boleh ada yang kosong, jika kosong hewan tidak terupload !",
                    color: black),
                10.heightBox,
                const Divider(color: white),
                boldText(text: "Pilih gambar hewan"),
                10.heightBox,
                Obx(
  () => Wrap(
    spacing: 20,
    runSpacing: 12,
    children: List.generate(
      9,
      (index) => Stack(
        alignment: Alignment.topRight,
        children: [
          controller.pImagesList.length > index &&
                  controller.pImagesList[index] != null
              ? Image.file(
                  controller.pImagesList[index],
                  width: 100,
                ).onTap(() {
                  controller.pickImage(index, context);
                })
              : (controller.existingImages.length > index &&
                      controller.existingImages[index].isNotEmpty
                  ? Image.network(
                      controller.existingImages[index],
                      width: 100,
                    ).onTap(() {
                      controller.pickImage(index, context);
                    })
                  : GestureDetector( // Gunakan GestureDetector
                      onTap: () {
                        controller.pickImage(index, context);
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white, // Ganti warna fill sesuai keinginan Anda
                          borderRadius: BorderRadius.circular(8.0), // Bentuk tombol
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add, // Ganti ikon sesuai keinginan Anda
                            color: Colors.black, // Warna ikon
                          ),
                        ),
                      ),
                    )),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              controller.deleteImage(index);
            },
          )
        ],
      ),
    ),
  ),
),

                5.heightBox,
                normalText(
                    text:
                        "Gambar pertama akan menjadi tampilan depan hewan (masukkan setidaknya 1 gambar)",
                    color: black),
                10.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
