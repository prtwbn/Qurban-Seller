import '../../const/const.dart';

Widget normalText({text,color= Colors.black, size=14.0}) {
  return "$text".text.color(color).size(size).make();
}

Widget boldText({text, color = Colors.black, size = 14.0}){
  return "$text".text.semiBold.color(color).size(size).make();
}