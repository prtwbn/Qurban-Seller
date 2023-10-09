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
    print("Pesan");
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 239, 239, 1),
      appBar: AppBar(
        title: boldText(text: "Pesan", size: 16.0, color: fontGrey),
      ),
      body: StreamBuilder(
        stream: StoreServices.getMessages(currentUser!.uid),
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator();
          } else {
            var data = snapshot.data!.docs;
            if (data.isEmpty) {
              // Jika tidak ada produk
              return Center(child: Text("Pesan kosong"));
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(data.length, (index) {
                      var t = data[index]['created_on'] == null
                           ? DateTime.now()
                           : data[index]['created_on'].toDate();
                       var time = intl.DateFormat("h:mma").format(t);
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
                              trailing: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      normalText(text: time, color: darkGrey),
      if (data[index]['unread_count_penjual'] != null &&
          data[index]['unread_count_penjual'] > 0)
        CircleAvatar(
          radius: 10,
          backgroundColor: Colors.red,
          child: Text(
            '${data[index]['unread_count_penjual']}',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
    ],
  ),
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
    );
  }
}
