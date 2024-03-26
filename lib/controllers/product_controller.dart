
import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProductController extends GetxController{
  var quantity = 0.obs;
  var colorIndex = 0.obs;
  var totalPrice = 0.obs;
  var subcat = [];

  var isFav = false.obs;

  getSubCategories(title) async{
    subcat.clear();
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var decoded = categoryModelFromJson(data);
    var s = decoded.categories.where((element) => element.name == title).toList();
    for(var e in s[0].subcategory){
      subcat.add(e);
    }
  }

  changeColorIndex(index){
    colorIndex.value = index;
  }

  increaseQuantity(totalQuantity){
    if(totalQuantity>quantity.value){
      quantity.value++;
    }
  }

  decreaseQuantity(){
    if(quantity.value>0){
      quantity.value--;
    }
  }
  calculateTotalPrice(price){
    totalPrice.value = price*quantity.value;
  }
  
  addToCart({title, img, sellername, color, qty, tprice, context, vendorID}) async{
    await firestore.collection(cartCollection).doc().set({
      'title': title,
      'img': img,
      'sellername': sellername,
      'color': color,
      'qty':qty,
      'vendor_id': vendorID,
      'tprice':tprice,
      'added by': currentUser!.uid,
    }).catchError((error){
      VxToast.show(context, msg: error.toString());
    });
  }

  resetValue(){
    totalPrice.value = 0;
    quantity.value = 0;
    colorIndex.value = 0;
  }

  addToWishList(docId, context) async{
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist' : FieldValue.arrayUnion([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(true);
    VxToast.show(context, msg: "Added to wishlist");
  }

  removeFromWishList(docId, context) async{
    await firestore.collection(productsCollection).doc(docId).set({
      'p_wishlist' : FieldValue.arrayRemove([currentUser!.uid])
    }, SetOptions(merge: true));
    isFav(false);
    VxToast.show(context, msg: "Removed from wishlist");
  }

  checkIfFav(data) async{
    if(data['p_wishlist'].contains(currentUser!.uid)){
      isFav(true);
    }else{
      isFav(false);
    }
  }
}