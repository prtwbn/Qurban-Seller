//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
// ignore_for_file: use_build_context_synchronously

//import 'dart:io';

import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/profile_controller.dart';
import 'package:qurban_seller/views/widgets/custom_password.dart';
import 'package:qurban_seller/views/widgets/custom_textfield.dart';
import 'package:qurban_seller/views/widgets/loading_indicator.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

class ChangePassword extends StatefulWidget {
  //final String? username;
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var controller = Get.find<ProfileController>();

  @override
  void initState() {
    //controller.nameController.text = widget.username!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
       backgroundColor: Color.fromRGBO(239, 239, 239, 1),
        appBar: AppBar(
          title: boldText(text: "Ubah Password", size: 16.0),
          iconTheme: IconThemeData(color: Colors.black), 
          actions: [
            controller.isloading.value
                ? loadingIndicator(circleColor: white)
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);

                      if (controller.newpassController.text.length < 6) {
                        VxToast.show(context,
                            msg:
                                "Password tidak boleh kurang dari sama dengan 6 karakter");
                        controller.isloading(false);
                        return;
                      }

                      if (controller.snapshotData['password'] ==
                          controller.oldpassController.text) {
                        await controller.changeAuthPassword(
                          email: controller.snapshotData['email'],
                          password: controller.oldpassController.text,
                          newpassword: controller.newpassController.text,
                        );

                        // This line updates the password in the Firestore.
                        await controller.updatePw(
                            password: controller.newpassController.text);

                        controller.oldpassController.clear();
                        controller.newpassController.clear();

                        VxToast.show(context, msg: "Password Updated");
                        Navigator.pop(context);
                        controller.isloading(false);
                      } else {
                        // Message for incorrect old password
                        VxToast.show(context,
                            msg: "Password lama yang Anda masukkan salah");
                        controller.isloading(false);
                      }
                    },
                    child: normalText(text: "Simpan"))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: boldText(text: "Ubah Password")),
              10.heightBox,
              CustomPassword(
                  controller: controller.oldpassController,
                  hint: passwordHint,
                  title: "Password Lama",
                  isPass: true),
              10.heightBox,
              CustomPassword(
                  controller: controller.newpassController,
                  hint: passwordHint,
                  title: "Password Baru",
                  isPass: true),
              
            ],
          ),
        ),
      ),
    );
  }
}
