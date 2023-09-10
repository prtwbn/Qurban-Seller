import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/products_controller.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

Widget productDropDown(hint, List<String> list, dropvalue, ProductsController controller) {
  return Obx(
    () => DropdownButtonHideUnderline(
      child: DropdownButton(
        hint: normalText(text: "$hint", color: fontGrey),
        value: dropvalue.value == '' ? null : dropvalue.value,
        isExpanded: true,
        items: list.map((e) {
          return DropdownMenuItem(
            child: e.toString().text.make(),
            value: e,
          );
        }).toList(),
        onChanged: (newValue) {
          if (hint== "Category") {
            controller.subcategoryvalue.value = '';
            controller.populateSubcategory(newValue.toString());
          }
          dropvalue.value = newValue.toString();
        },
      ),
    )
        .box
        .white
        .padding(const EdgeInsets.symmetric(horizontal: 4))
        .roundedSM
        .make(),
  );
}
