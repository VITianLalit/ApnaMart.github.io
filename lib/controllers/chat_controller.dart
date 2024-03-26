import 'package:apna_mart/consts/consts.dart';
import 'package:apna_mart/controllers/home_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatsController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    getChatId();
    super.onInit();
  }
  var chats = firestore.collection(chatCollection);
  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username;
  var currentId = currentUser!.uid;

  var msgController = TextEditingController();

  dynamic chatDocId;
  var isLoading = false.obs;

  Future<void> getChatId() async {
    isLoading(true);
    QuerySnapshot snapshot = await chats
        .where('users', isEqualTo: {
      'friendId': null,
      'currentId': null,
    })
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      chatDocId = snapshot.docs.single.id;
    } else {
      DocumentReference newChatRef = await chats.add({
        'created_on': Timestamp.now(), // Use Timestamp.now() to get the current time
        'last_msg': '',
        'users': {'friendId': null, 'currentId': null},
        'toId': '',
        'fromId': '',
        'friend_name': friendName,
        'sender_name': senderName,
      });
      chatDocId = newChatRef.id;
    }
    isLoading(false);
  }

  sendMsg(msg) async{
    if(msg.trim().isNotEmpty){
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': friendId,
        'fromId': currentId,
      });
      chats.doc(chatDocId).collection(messageCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg':msg,
        'uid': currentId,
      });
    }
  }
}