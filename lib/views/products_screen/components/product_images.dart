import 'package:qurban_seller/const/const.dart';
//import 'package:qurban_seller/views/widgets/text_style.dart';

Widget productImages({required label, onPress}) {
  return "$label".text.bold.color(fontGrey).size(16.0).makeCentered().box.color(lightGrey).size(100, 100).roundedSM.make();
}