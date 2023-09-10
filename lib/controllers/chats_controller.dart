import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/const/firebase_consts.dart';
import 'package:qurban_seller/controllers/home_controller.dart';

class ChatsController extends GetxController {
  var friendName;
  var friendId;
  var told;

  @override
  void onInit() {
    friendName = Get.arguments[0];
    friendId = Get.arguments[1];
    told = Get.arguments[2];
    getChatId();
    super.onInit();
  }

  var chats = firestore.collection(chatsCollection);
  // var friendName = Get.arguments[0];
  // var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username;
  //late RxString currentId;
  // RxString currentId = ''.obs;

  var currentId = currentUser!.uid;

  var msgController = TextEditingController();

  dynamic chatDocId;

  var isLoading = false.obs;

  getChatId() async {
    print("ini friend id ${friendId}");
    print("ini friend name ${friendName}");

    var chatSnapshot = await chats
        .where('users', arrayContainsAny: [friendId, currentId])
        .limit(1)
        .get();

    if (chatSnapshot.docs.isNotEmpty) {
      chatDocId = chatSnapshot.docs.single.id;
      //await chats.doc(chatDocId).update({'unread_count_pembeli': 0});
    } else {
      try {
        var addChat = await chats.add({
          'created_on': FieldValue.serverTimestamp(),
          'last_msg': '',
          'users': [friendId, currentId],
          'told': friendId,
          'fromId': currentId,
          'friend_name': friendName,
          'sender_name': senderName
        });

        chatDocId = addChat.id;
      } catch (e) {
        print(e);
      }
    }

    isLoading(false);
  }

  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'told': friendId, // Ini harus menjadi ID pembeli
        'fromId': currentId, // Ini harus menjadi ID penjual
        //'unread_count_penjual': FieldValue.increment(1),
      });

      chats.doc(chatDocId).collection(messagesCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }
}
