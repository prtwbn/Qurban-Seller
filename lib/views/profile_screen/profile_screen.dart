import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/auth_controller.dart';
import 'package:qurban_seller/controllers/profile_controller.dart';
import 'package:qurban_seller/services/store_services.dart';
import 'package:qurban_seller/views/auth_screen/login_screen.dart';
import 'package:qurban_seller/views/messages_screen/messages_screen.dart';
import 'package:qurban_seller/views/profile_screen/change_password.dart';
import 'package:qurban_seller/views/profile_screen/edit_profilescreen.dart';
import 'package:qurban_seller/views/shop_screen/shop_settings_screen.dart';
import 'package:qurban_seller/views/widgets/loading_indicator.dart';
import 'package:qurban_seller/views/widgets/map_widget.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 239, 239, 1),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: boldText(text: settings, size: 16.0),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => EditProfileScreen(
                        username: controller.snapshotData['name'],
                      ));
                },
                icon: const Icon(
                  Icons.edit,
                  color: black,
                )),
          ]
          /*
          TextButton(
              onPressed: () async {
                await Get.find<AuthController>().signoutMethod(context);
                Get.offAll(() => const LoginScreen());
              },
              child: normalText(text: logout))
        ],*/
          ),
      body: FutureBuilder(
        future: StoreServices.getProfile(currentUser!.uid),
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return loadingIndicator(circleColor: white);
          } else {
            controller.snapshotData = snapshot.data!.docs[0];

            return Column(
              children: [
                ListTile(
                  leading: controller.snapshotData['imageUrl'] == ''
                      ? Image.asset(imgUser, width: 70, fit: BoxFit.cover)
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make()
                      : Image.network(controller.snapshotData['imageUrl'],
                              width: 100)
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make(),
                  title: boldText(text: "${controller.snapshotData['name']}"),
                  subtitle:
                      normalText(text: "${controller.snapshotData['email']}"),
                ),
                const Divider(),
                10.heightBox,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      children: List.generate(
                          profileButtonsIcons.length,
                          (index) => ListTile(
                                onTap: () async {
                                  switch (index) {
                                    case 0:
                                      Get.to(() => ChangePassword());
                                      break;
                                    case 1:
                                      await Get.put(AuthController())
                                          .signoutMethod();
                                      //Get.offAll(() => const LoginScreen());
                                      break;

                                    default:
                                  }
                                },
                                leading: Icon(profileButtonsIcons[index],
                                    color: black),
                                title: normalText(
                                    text: profileButtonsTitles[index]),
                              ))),
                )
              ],
            );
          }
        }),
      ),
    );
  }
}
