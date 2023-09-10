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
    controller.pnameController.text = data['p_name'];
    controller.pdescController.text = data['p_desc'];
    controller.ppriceController.text = data['p_price'];
    controller.pquantityController.text = data['p_quantity'].toString();

    controller.categoryvalue.value = data['p_category'];
    controller.subcategoryvalue.value = data['p_subcategory'];
    controller.getCategories();
    controller.populateCategoryList();
    return Obx(
      () => Scaffold(
        backgroundColor: yellow2,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back)),
          title: boldText(text: "Add Product", size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      await controller.uploadImages();
                      await controller.updateProduct(data.id, context);
                    },
                    child: boldText(text: save, color: black),
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
                customtTextField(
                    hint: "Contoh. Kambing Qurban Pak De",
                    label: "Nama Produk",
                    controller: controller.pnameController),
                10.heightBox,
                customtTextField(
                    hint: "Contoh. Berat 2kg, Umur 2 tahun, Jenis Kelamin",
                    label: "Deskripsi Lengkap",
                    isDesc: true,
                    controller: controller.pdescController),
                10.heightBox,
                customtTextField(
                    hint: "Contoh. 1500000 (angka saja)",
                    label: "Harga",
                    controller: controller.ppriceController),
                10.heightBox,
                customtTextField(
                    hint: "Contoh. 20",
                    label: "Kuantitas",
                    controller: controller.pquantityController),
                10.heightBox,
                productDropDown("Category", controller.categoryList,
                    controller.categoryvalue, controller),
                10.heightBox,
                productDropDown("Subcategory", controller.subcategoryList,
                    controller.subcategoryvalue, controller),
                10.heightBox,
                const Divider(color: black),
                boldText(text: "Choose product images"),
                10.heightBox,
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      3,
                      (index) => Stack(
                        children: [
                          controller.pImagesList[index] != null
                              ? Image.file(
                                  controller.pImagesList[index],
                                  width: 100,
                                ).onTap(() {
                                  controller.pickImage(index, context);
                                })
                              : (controller.existingImages[index].isNotEmpty
                                  ? Image.network(
                                      controller.existingImages[index],
                                      width: 100,
                                    ).onTap(() {
                                      controller.pickImage(index, context);
                                    })
                                  : productImages(label: "${index + 1}")
                                      .onTap(() {
                                      controller.pickImage(index, context);
                                    })),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () => controller.deleteImage(index),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                5.heightBox,
                normalText(
                    text: "First image will be your display image",
                    color: black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
