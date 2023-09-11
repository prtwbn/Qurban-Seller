import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/home_controller.dart';

class ChatsController extends GetxController {
  late String friendName;
  late String friendId;
  late String told;

  late CollectionReference chats;
  late String senderName;
  late String currentId;
  late TextEditingController msgController;
  dynamic chatDocId;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    friendId = Get.arguments[0];
    friendName = Get.arguments[1];
    told = Get.arguments[2];
    chats = FirebaseFirestore.instance.collection(chatsCollection);
    senderName = Get.find<HomeController>().username;
    currentId = currentUser!.uid;
    msgController = TextEditingController();

    getChatId();
  }

  /// Cari chat history
  /// Jika ada, ambil chatId
  /// Jika tidak ada, buat baru
  void getChatId() async {
    print("friendId: ${friendId}");
    print("currentId: ${currentId}");
    var chatSnapshot = await chats.where('users', whereIn: [
      [friendId, currentId],
      [currentId, friendId]
    ]).get();

    print("chatSnapshot.docs: ${chatSnapshot.docs}");

    if (chatSnapshot.docs.isNotEmpty) {
      chatDocId = chatSnapshot.docs.single.id;
    } else {
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
    }

    isLoading(false);
  }

  void sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'told': friendId,
        'fromId': currentId,
      });

      chats.doc(chatDocId).collection(messagesCollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }
}
