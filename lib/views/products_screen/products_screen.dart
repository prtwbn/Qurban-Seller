import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/products_controller.dart';
import 'package:qurban_seller/services/store_services.dart';
import 'package:qurban_seller/views/products_screen/edit_product.dart';
import 'package:qurban_seller/views/products_screen/add_product.dart';
import 'package:qurban_seller/views/products_screen/product_detail.dart';
import 'package:qurban_seller/views/widgets/appbar_widget.dart';
import 'package:qurban_seller/views/widgets/loading_indicator.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';
//import 'package:intl/intl.dart' as intl;

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductsController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: yellow,
        onPressed: () async {
          await controller.getCategories();
          controller.populateCategoryList();
          Get.to(() => const AddProduct());
        },
        child: const Icon(Icons.add),
      ),
      appBar: appbarWidget(products),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  
                  children: 
                  
                  List.generate(
                    data.length,
                    ((index) => Card(
                          child: ListTile(
                            onTap: () {
                              Get.to(() => ProductDetails(
                                    data: data[index],
                                  ));
                            },
                            leading: Image.network(data[index]['p_imgs'][0],
                                width: 100, height: 100, fit: BoxFit.cover),
                            title: boldText(
                                text: "${data[index]['p_jenishewan']}",
                                color: fontGrey),
                            subtitle: Row(
                              children: [
                                normalText(
                                    text: "Rp. ${double.parse(data[index]['p_price']).numCurrency}",
                                    color: darkGrey),
                                10.widthBox,
                                //boldText(text: "Featured", color: green),
                              ],
                            ),
                            trailing: VxPopupMenu(
                              arrowSize: 0.0,
                              menuBuilder: () => Column(
                                children: List.generate(
                                    popupMenuTitles.length,
                                    (i) => Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              Icon(popupMenuIcons[i]),
                                              10.widthBox,
                                              normalText(
                                                  text: popupMenuTitles[i],
                                                  color: darkGrey)
                                            ],
                                          ).onTap(() {
                                            switch (i) {
                                              case 0:
                                                Get.to(() => EditProduct(
                                                    data: data[
                                                        index]));
                                                break;
                                              case 1:
                                              controller.removeProduct(data[index].id);
                                              VxToast.show(context, msg: "Product Removed");
                                              break;
                                              default:
                                            }
                                          }),
                                        )),
                              ).box.white.rounded.width(200).make(),
                              clickType: VxClickType.singleClick,
                              child: const Icon(Icons.more_vert_rounded),
                            ),
                          ),
                        )),
                  ),
                ),
              ),
            );
          }
        },
      ),
      /*body: */
    );
  }
}
