//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/chats_controller.dart';
import 'package:qurban_seller/services/store_services.dart';
import 'package:qurban_seller/views/messages_screen/components/chat_bubble.dart';
import 'package:qurban_seller/views/widgets/loading_indicator.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  

  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController(), permanent: true);

    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: darkGrey),
            onPressed: () {
              Get.back();
            }),
        title: boldText(text: chats, size: 16.0, color: fontGrey),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() {
              if (controller.friendName == null) {
                return const SizedBox(); // Tampilkan widget kosong jika friendName belum ada
              } else {
                return controller.isLoading.value
                    ? Center(child: loadingIndicator())
                    : Expanded(
                        child: StreamBuilder(
                        stream: StoreServices.getChatMessages(
                            controller.chatDocId.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: loadingIndicator(),
                            );
                          } else if (snapshot.data!.docs.isEmpty) {
                            return Center(
                              child: "Send a message..."
                                  .text
                                  .color(darkFontGrey)
                                  .make(),
                            );
                          } else {
                            return ListView.builder(
                              reverse: true, // ini akan membalik urutan item
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var data = snapshot.data!.docs[
                                    snapshot.data!.docs.length - index - 1];
                                return Align(
                                    alignment: data['uid'] == currentUser!.uid
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: senderBubble(data));
                              },
                            );
                          }
                        },
                      ));
              }
            }),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controller.msgController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textfieldGrey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textfieldGrey,
                      ),
                    ),
                    hintText: "Type a message...",
                  ),
                )),
                IconButton(
                    onPressed: () {
                      controller.sendMsg(controller.msgController.text);
                      controller.msgController.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: redColor,
                    ))
              ],
            )
                .box
                .height(60)
                .padding(const EdgeInsets.all(12))
                .margin(const EdgeInsets.only(bottom: 8))
                .make(),
          ],
        ),
      ),
    );
  }
}
