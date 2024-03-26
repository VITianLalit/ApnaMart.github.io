import 'package:apna_mart/consts/consts.dart';

class FirestoreServices{
  static getUser(uid){
    return firestore.collection(usersCollection).where('id', isEqualTo: uid).snapshots();
  }

  //get products according to category
  static getProducts(category){
    return firestore.collection(productsCollection).where('p_category', isEqualTo: category).snapshots();
  }

  // get cart
  static getCart(uid){
    return firestore.collection(cartCollection).where('added by', isEqualTo: uid).snapshots();
  }

  static deleteDocument(docId){
    return firestore.collection(cartCollection).doc(docId).delete();
  }

  static getChatMessages(docId){
    return firestore.collection(chatCollection).doc(docId).collection(messageCollection).orderBy('created_on', descending: false).snapshots();
  }
  
  static getAllOrders(){
    return firestore.collection(ordersCollection).where('order_by', isEqualTo: currentUser!.uid).snapshots();
  }

  static getWishLists(){
    return firestore.collection(productsCollection).where('p_wishlist', arrayContains: currentUser!.uid).snapshots();
  }

  static getAllMessage(){
    return firestore.collection(chatCollection).where('fromId', isEqualTo: currentUser!.uid).snapshots();
  }

  static getCounts() async{
    var res = await Future.wait([
      firestore.collection(cartCollection).where('added_by', isEqualTo: currentUser!.uid).get().then((value){
        return value.docs.length;
      }),
      firestore.collection(productsCollection).where('p_wishlist', arrayContains: currentUser!.uid).get().then((value){
        return value.docs.length;
      }),
      firestore.collection(ordersCollection).where('order_by', isEqualTo: currentUser!.uid).get().then((value){
        return value.docs.length;
      }),
    ]);
    return res;
  }

  static allproducts(){
    return firestore.collection(productsCollection).snapshots();
  }

//   Get featured products method
  static getFeaturedProducts(){
    return firestore.collection(productsCollection).where('is_featured', isEqualTo: true).get();
  }
  
  static searchProduct(title){
    return firestore.collection(productsCollection).where('p_name', isLessThanOrEqualTo: title).get();
  }

  static getSubCategoryProducts(title){
    return firestore.collection(productsCollection).where('p_subcategory', isEqualTo: title).snapshots();
  }
}