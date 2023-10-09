import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

Widget customtTextField(
    {label,
    hint,
    controller,
    isDesc = false,
    TextInputType keyboardType = TextInputType.text}) {
  return TextFormField(
    keyboardType: keyboardType,
    style: const TextStyle(color: black),
    controller: controller,
    maxLines: isDesc ? 4 : 1,
    decoration: InputDecoration(
        isDense: true,
        label: normalText(text: label),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: white,
            )), // OutlineInputBorder
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: white,
            )),
        hintText: hint,
        hintStyle: const TextStyle(color: black)),
  );
}
