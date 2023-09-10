//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/profile_controller.dart';
import 'package:qurban_seller/views/widgets/custom_textfield.dart';
import 'package:qurban_seller/views/widgets/loading_indicator.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

class EditProfileScreen extends StatefulWidget {
  final String? username;
  const EditProfileScreen({Key? key, this.username}) : super(key: key);


  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var controller = Get.find<ProfileController>();

  @override
  void initState() {
    controller.nameController.text = widget.username!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: yellow2,
        appBar: AppBar(
          title: boldText(text: editProfile, size: 16.0),
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
    
                      //if img is not selected
                      if (controller.profileImgPath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink =
                            controller.snapshotData['imageUrl'];
                      }
    
                      //if old pw match database
                      if (controller.snapshotData['password'] ==
                          // ignore: duplicate_ignore
                          controller.oldpassController.text) {
                        await controller.changeAuthPassword(
                            email: controller.snapshotData['email'],
                            password: controller.oldpassController.text,
                            newpassword: controller.newpassController.text);
                        await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.newpassController.text);
                        
                        VxToast.show(context, msg: "Updated");
                      } else if (controller
                              .oldpassController.text.isEmptyOrNull &&
                          controller.newpassController.text.isEmptyOrNull) {
                        await controller.updateProfile(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.snapshotData['password']);
                            VxToast.show(context, msg: "Updated");
                        
                      } else {
                        VxToast.show(context, msg: "Some error occured");
                        controller.isloading(false);
                      }
                    },
                    child: normalText(text: save))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: [
                controller.snapshotData['imageUrl'] == '' &&
                        controller.profileImgPath.isEmpty
                    ? Image.asset(imgUser, width: 100, fit: BoxFit.cover)
                        .box
                        .roundedFull
                        .clip(Clip.antiAlias)
                        .make()
                    : controller.snapshotData['imageUrl'] != '' &&
                            controller.profileImgPath.isEmpty
                        ? Image.network(
                            controller.snapshotData['imageUrl'],
                            width: 100,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make()
                        : Image.file(
                            File(controller.profileImgPath.value),
                            width: 100,
                            fit: BoxFit.cover,
                          ).box.roundedFull.clip(Clip.antiAlias).make(),
                10.heightBox,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: white),
                  onPressed: () {
                    controller.changeImage(context);
                  },
                  child: normalText(text: changeImage, color: fontGrey),
                ),
                10.heightBox,
                const Divider(color: white),
                customtTextField(
                    label: name,
                    hint: "eg. Pratiwi Bagus",
                    controller: controller.nameController),
                30.heightBox,
                Align(
                    alignment: Alignment.centerLeft,
                    child: boldText(text: "Change Your Password")),
                10.heightBox,
                customtTextField(
                    label: password,
                    hint: passwordHint,
                    controller: controller.oldpassController),
                10.heightBox,
                customtTextField(
                    label: confirmPass,
                    hint: passwordHint,
                    controller: controller.newpassController),
              ],
            ),
          
        ),
      ),
    );
  }
}
