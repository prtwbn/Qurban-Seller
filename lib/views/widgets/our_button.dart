//import 'package:flutter/cupertino.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

Widget ourButton({title, color,textColor, onPress}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        primary: color,
        padding: const EdgeInsets.all(12),
      ),
      onPressed: onPress,
      child: normalText(text: title, color: textColor, size: 16.0));
}
