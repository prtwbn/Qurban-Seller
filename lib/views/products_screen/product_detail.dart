//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
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
        title: boldText(text: "${data['p_jenishewan']}", color: fontGrey, size: 16.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxSwiper.builder(
                autoPlay: true,
                height: 350,
                itemCount: data['p_imgs'].length,
                aspectRatio: 16 / 9,
                viewportFraction: 1.0,
                itemBuilder: (context, index) {
                  return Image.network(
                    //imgProduct,
                    data['p_imgs'][index],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                }),
            10.heightBox,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boldText(text: "${data['p_jenishewan']}", color: fontGrey, size: 16.0),
                  10.heightBox,
                  Row(
                    children: [
                      boldText(text: "${data['p_category']}", color: fontGrey, size: 16.0),
                      10.widthBox,
                      normalText(text: "${data['p_subcategory']}", color: fontGrey, size: 16.0),
                    ],
                  ),
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
                  ),
                  10.heightBox,
                  boldText(text: "Rp. ${double.parse(data['p_price']).numCurrency}", color: red, size: 18.0),
                  20.heightBox,
                  Column(
                    children: [
                      //quantity row
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child:
                               boldText(text: "Quantity", color: fontGrey),
                          ),
                          normalText(text: "${data['p_quantity']} items", color: fontGrey),
                        ]
                      ),
                    ],
                  ).box.white.padding(const EdgeInsets.all(8)).make(),
                  const Divider(),
                  20.heightBox,
                  boldText(text: "Description", color: fontGrey),

                  10.heightBox,
                  normalText(text: "${data['p_desc']}", color: fontGrey),

                  20.heightBox,
                  boldText(text: "Berat", color: fontGrey),

                  10.heightBox,
                  normalText(text: "${data['p_berat']}", color: fontGrey),

                  20.heightBox,
                  boldText(text: "Jenis kelamin", color: fontGrey),

                  10.heightBox,
                  normalText(text: "${data['p_jeniskelamin']}", color: fontGrey),

                  20.heightBox,
                  boldText(text: "Umur", color: fontGrey),

                  10.heightBox,
                  normalText(text: "${data['p_umur']}", color: fontGrey),
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
