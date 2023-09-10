//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/profile_controller.dart';
import 'package:qurban_seller/views/widgets/custom_textfield.dart';
import 'package:qurban_seller/views/widgets/loading_indicator.dart';
//import 'package:qurban_seller/views/widgets/map_widget.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';
//import 'package:geolocator/geolocator.dart';


class ShopSettings extends StatelessWidget {
  const ShopSettings({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    var controller = Get.find<ProfileController>();

    
    return Obx(
      () => Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: boldText(text: shopSettings, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      await controller.updateShop(
                        //shopaddress: controller.shopAdressController.text,
                        shopname: controller.shopNameController.text,
                        shopmobile: controller.shopMobileController.text,
                        shopdesc: controller.shopDescController.text,
                      );
                      VxToast.show(context, msg: "Shop updated");
                    },
                    child: normalText(text: save))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              customtTextField(
                  label: shopName,
                  hint: nameHint,
                  controller: controller.shopNameController),
            
              
              //Expanded(
              //  child: GoogleMapWidget(controller: controller),
              //),
              10.heightBox,
              customtTextField(
                  label: mobile,
                  hint: shopMobileHint,
                  controller: controller.shopMobileController),
              10.heightBox,
              customtTextField(
                isDesc: true,
                label: description,
                hint: shopDescHint,
                controller: controller.shopDescController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
