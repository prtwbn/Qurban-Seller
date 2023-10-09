//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/products_controller.dart';
//import 'package:qurban_seller/models/product_variation.dart';
import 'package:qurban_seller/views/products_screen/components/product_dropdown.dart';
import 'package:qurban_seller/views/products_screen/components/product_images.dart';
import 'package:qurban_seller/views/widgets/custom_textfield.dart';
import 'package:qurban_seller/views/widgets/loading_indicator.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  /*
  List<ProductVariation> variations = [];

  void addVariationField() {
    setState(() {
      variations.add(ProductVariation(name: '', price: 0.0));
    });
  } */

  var selectedGender = 'Jantan'.obs;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());
    controller.init();
    return Obx(
      () => Scaffold(
   backgroundColor: Color.fromRGBO(239, 239, 239, 1),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back), color: black,),
          title: boldText(text: "Tambah Hewan", size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      if (controller.isValidForm(context)) {
                        controller.isloading(true);
                        await controller.uploadImages();
                        await controller.uploadProduct(context);
                        Get.back();
                      }
                    },
                    child: boldText(text: "Simpan", color: black))
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
                productDropDown("Subcategory", controller.subcategoryList,
                    controller.subcategoryvalue, controller),
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
                const Divider(color: black),
                boldText(text: "Pilih gambar hewan"),
                10.heightBox,
                Obx(
                  () => Wrap(
                    spacing: 20,
                    runSpacing: 12,
                    children: List.generate(
                      9,
                      (index) => controller.pImagesList[index] != null
                          ? Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Image.file(
                                  controller.pImagesList[index],
                                  width: 100,
                                ).onTap(() {
                                  controller.pickImage(index, context);
                                }),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    controller.deleteImage(index);
                                  },
                                )
                              ],
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              color: Colors
                                  .white, // Ganti dengan warna yang Anda inginkan
                              child: Center(
                          child: Icon(
                            Icons.add, // Ganti ikon sesuai keinginan Anda
                            color: Colors.black, // Warna ikon
                          ),
                        ),
                            ).onTap(() {
                              controller.pickImage(index, context);
                            }),
                    ),
                  ),
                ),
                5.heightBox,
                normalText(
                    text:
                        "Gambar pertama akan menjadi tampilan depan hewan (masukkan setidaknya 1 gambar)",
                    color: black),
                10.heightBox,
                /*
              Column(
  children: variations.map((v) {
    return Row(
  children: [
    Flexible(
      child: TextField(
        onChanged: (value) => v.name = value,
        decoration: InputDecoration(hintText: 'Nama Variasi'),
      ),
    ),
    SizedBox(width: 10), // memberikan jarak sedikit antara dua TextField
    Flexible(
      child: TextField(
        onChanged: (value) => v.price = double.tryParse(value) ?? 0.0,
        decoration: InputDecoration(hintText: 'Harga Variasi'),
        keyboardType: TextInputType.number,
      ),
    ),
  ],
);

  }).toList(),
),

ElevatedButton(onPressed: addVariationField, child: Text('Tambah Variasi')),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
