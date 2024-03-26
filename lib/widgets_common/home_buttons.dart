import 'package:apna_mart/consts/consts.dart';

Widget homeButtons({width, height, icon,String? title, onPress}){
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5,
          offset: Offset(0, 1),
        )
      ],
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(icon, width: 26,)
        ),
        SizedBox(height: 10,),
        title!.text.fontFamily(semibold).color(darkFontGrey).make(),
      ],
    ),
  );
}