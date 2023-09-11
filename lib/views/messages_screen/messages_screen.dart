//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/services/store_services.dart';
import 'package:qurban_seller/views/messages_screen/chat_screen.dart';
import 'package:qurban_seller/views/widgets/loading_indicator.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';
import 'package:intl/intl.dart' as intl;

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("messagesss");
    return Scaffold(
      appBar: AppBar(
        title: boldText(text: messages, size: 16.0, color: fontGrey),
      ),
      body: StreamBuilder(
        stream: StoreServices.getMessages(currentUser!.uid),
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(data.length, (index) {
                      // var t = data[index]['created_on'] == null
                      //     ? DateTime.now()
                      //     : data[index]['created_on'].toDate();
                      // var time = intl.DateFormat("h:mma").format(t);
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(data[index]['users']
                                .where((user) => user != currentUser!.uid)
                                .first)
                            .get(),
                        builder: (context, userSnapshot) {
                          if (userSnapshot.hasData) {
                            dynamic userData = userSnapshot.data!.data();

                            String imageUrl = userData['imageUrl'];

                            return ListTile(
                              onTap: () {
                                Get.to(() => const ChatScreen(), arguments: [
                                  data[index]['users']
                                      .where((user) => user != currentUser!.uid)
                                      .first,
                                  data[index]['fromId'],
                                  data[index]['told'],
                                ]);
                              },
                              leading: imageUrl.isNotEmpty
                                  ? Image.network(imageUrl,
                                          width: 50, fit: BoxFit.cover)
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make()
                                  : Image.asset('assets/user.png',
                                          width: 50, fit: BoxFit.cover)
                                      .box
                                      .roundedFull
                                      .clip(Clip.antiAlias)
                                      .make(),
                              title: boldText(
                                  text: userData['name'], color: fontGrey),
                              subtitle: normalText(
                                  text: data[index]['last_msg'],
                                  color: darkGrey),
                            );
                          } else if (snapshot.hasError) {
                            return const Text('Failed to load data');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      );
                    }),
                  )),
            );
          }
        }),
      ),
      /*body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
            child: Column(
          children: List.generate(
              20,
              (index) => ListTile(
                onTap: (){
                  Get.to(() => const ChatScreen());
                },
                    leading: const CircleAvatar(
                      backgroundColor: purpleColor,
                      child: Icon(
                        Icons.person,
                        color: white,
                      ),
                    ),
                    title: boldText(text: "Username", color: fontGrey),
                    subtitle:
                        normalText(text: "last message...", color: darkGrey),
                    trailing: normalText(text: "10:45PM", color: darkGrey) ,
                  )),
        )),
      ),*/
    );
  }
}
