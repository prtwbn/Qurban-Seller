//import 'package:flutter/material.dart';
import 'package:qurban_seller/const/const.dart';
//import 'package:qurban_3/consts/consts.dart';

Widget customTextField({String? title, String? hint, controller, isPass}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    title!.text.size(16).make(),
    5.heightBox,
    TextFormField(
      obscureText: isPass,
      controller: controller,
      decoration: InputDecoration(
          hintStyle: const TextStyle(
            
            color: textfieldGrey,
          ),
          hintText: hint,
          isDense: true,
          fillColor: lightGrey,
          filled: true,
          border: InputBorder.none,
          focusedBorder:
              const OutlineInputBorder(borderSide: BorderSide(color: purpleColor))),
    ),
    5.heightBox,
  ]);
}
