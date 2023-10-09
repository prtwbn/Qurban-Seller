//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/models/product_variation.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;
  const ProductDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back, color: darkGrey)),
        title: boldText(
            text: "${data['p_jenishewan']}", color: fontGrey, size: 16.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxSwiper.builder(
              autoPlay: data['p_imgs'].length > 1,
              height: 350,
              itemCount: data['p_imgs'].length,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              enableInfiniteScroll: data['p_imgs'].length > 1,
              onPageChanged: (index) {
                        // Anda dapat memperbarui state dengan indeks gambar saat ini, jika diperlukan.
                      },
              itemBuilder: (context, index) {
                return  GestureDetector(
                          onTap: () {
                            // Menampilkan gambar dalam tampilan perbesar saat ditekan
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  appBar: AppBar(
                                    backgroundColor:
                                        Colors.black,
                                    leading: IconButton(
                                      icon: Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Tutup tampilan perbesar
                                      },
                                    ),
                                  ),
                                  body: PhotoViewGallery.builder(
                                    itemCount: data['p_imgs'].length,
                                    builder: (context, index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider:
                                            NetworkImage(data['p_imgs'][index]),
                                        minScale:
                                            PhotoViewComputedScale.contained,
                                        maxScale:
                                            PhotoViewComputedScale.covered * 2,
                                      );
                                    },
                                    scrollPhysics: BouncingScrollPhysics(),
                                    backgroundDecoration: BoxDecoration(
                                      color: Colors.black,
                                    ),
                                    pageController: PageController(
                                        initialPage:
                                            index), // Memulai dari gambar yang ditekan
                                    onPageChanged: (index) {
                                      // Anda dapat melakukan sesuatu saat halaman gambar berubah, jika diperlukan.
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                
                child: Stack(
                  children: [
                    Image.network(
                      data['p_imgs'][index],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: Colors.black.withOpacity(0.5),
                        child: Text(
                          "${index + 1}/${data['p_imgs'].length}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
                );
              },
            ),
            10.heightBox,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boldText(
                      text: "${data['p_jenishewan']}",
                      color: fontGrey,
                      size: 16.0),
                  10.heightBox,
                  Row(
                    children: [
                      boldText(
                          text: "${data['p_category']}",
                          color: fontGrey,
                          size: 16.0),
                      Icon(Icons.arrow_right_outlined),
                      SizedBox(width: 5),
                      normalText(
                          text: "${data['p_subcategory']}",
                          color: fontGrey,
                          size: 16.0),
                    ],
                  ),
                  /*
                  10.heightBox,
                  VxRating(
                    isSelectable: false,
                    value: double.parse(data['p_rating']),
                    //value: 3.0,
                    onRatingUpdate: (value) {},
                    normalColor: textfieldGrey,
                    selectionColor: golden,
                    count: 5,
                    maxRating: 5,
                    size: 25,
                  ), */
                  10.heightBox,
                  boldText(
                      text: "Rp. ${double.parse(data['p_price']).numCurrency}",
                      color: red,
                      size: 18.0),
                  20.heightBox,
                  Column(
                    children: [
                      //quantity row
                      Row(children: [
                        SizedBox(
                          width: 100,
                          child: boldText(text: "Tersedia", color: fontGrey),
                        ),
                        normalText(
                            text: "${data['p_quantity']} hewan",
                            color: fontGrey),
                      ]),
                    ],
                  ).box.white.padding(const EdgeInsets.all(8)).make(),
                  const Divider(),
                  20.heightBox,
                  boldText(text: "Deskripsi", color: fontGrey),
                  10.heightBox,
                  normalText(text: "${data['p_desc']}", color: fontGrey),
                  20.heightBox,
                  boldText(text: "Berat", color: fontGrey),
                  10.heightBox,
                  normalText(text: "${data['p_berat']}", color: fontGrey),
                  20.heightBox,
                  boldText(text: "Jenis kelamin", color: fontGrey),
                  10.heightBox,
                  normalText(
                      text: "${data['p_jeniskelamin']}", color: fontGrey),
                  20.heightBox,
                  boldText(text: "Umur", color: fontGrey),
                  10.heightBox,
                  normalText(text: "${data['p_umur']}", color: fontGrey),
                  20.heightBox,
                  boldText(text: "Surat Keterangan Sehat", color: fontGrey),
                  10.heightBox,
                  normalText(text: "${data['p_sks']}", color: fontGrey),
                  /*
                  Column(
  children: data['p_variations'].map<Widget>((v) {
    var variation = ProductVariation.fromJson(v);
    return Row(
      children: [
        Text(variation.name),
        Spacer(),
        Text("Rp. ${variation.price.numCurrency}"),
      ],
    );
  }).toList(),
),
*/
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
