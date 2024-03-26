import 'package:apna_mart/consts/consts.dart';

Widget ourButton({onPress, color, textColor,String? title}){
  return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.all(12),
      ),
      child: title!.text.color(textColor).fontFamily(bold).make(),
  );
}