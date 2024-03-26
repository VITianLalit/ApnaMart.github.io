import 'package:apna_mart/consts/consts.dart';

Widget orderPlaceDetails({title1, title2, d1, d2}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "$title1".text.fontWeight(FontWeight.bold).fontFamily(semibold).make(),
            "$d2".text.color(redColor).fontFamily(semibold).make(),
          ],
        ),
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "$title2".text.fontFamily(semibold).fontWeight(FontWeight.bold).make(),
              "$d2".text.make(),
            ],
          ),
        )
      ],
    ),
  );
}