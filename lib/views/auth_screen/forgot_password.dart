//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
//import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/auth_controller.dart';
import 'package:qurban_seller/views/auth_screen/signup_screen.dart';
import 'package:qurban_seller/views/home_screen/home.dart';
import 'package:qurban_seller/views/widgets/applogowidget.dart';
import 'package:qurban_seller/views/widgets/loading_indicator.dart';
import 'package:qurban_seller/views/widgets/our_button.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: white,
        appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), color: black, // Back arrow icon
          onPressed: () {
            Get.back(); // Navigate back when the arrow is pressed
          },
        ),
      ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.heightBox,

              Center(
                  child:
                      applogoWidget()), // Memasukkan applogoWidget ke dalam Center widget
              10.heightBox,
              Center(
                child: boldText(
                    text: appname,
                    size: 20.0), // Memasukkan appname ke dalam Center widget
              ),

              40.heightBox,
              normalText(text: "Reset Password", size: 18.0, color: black),
              10.heightBox,
              Obx(
                () => Column(
                  children: [
                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        fillColor: textfieldGrey,
                        filled: true,
                        prefixIcon: Icon(Icons.email, color: purpleColor),
                        border: InputBorder.none,
                        hintText: emailHint,
                      ),
                    ),
                    
                    20.heightBox,
                    SizedBox(
                      width: context.screenWidth - 40,
                      child: controller.isloading.value
                          ? loadingIndicator()
                          : ourButton(
                              color: brown,
                              title: "Kirim email reset password",
                              onPress: () async {
                                if (controller.emailController.text.isEmpty) {
                              // Show an error message if the email field is empty
                              VxToast.show(context, msg: "Isi kolom email");
                            } else {
                              controller.isloading(true);
                              await controller
                                  .resetPassword(); // Call the resetPassword method
                              controller.isloading(false);
                            }
                              },
                            ),
                    ),
                    5.heightBox,
                    /*
                    createNewAccount.text.color(fontGrey).make(),
                    5.heightBox,
                    ourButton(
                        color: yellow,
                        title: signup,
                        textColor:white,
                        onPress: () {
                          Get.to(() => const SignupScreen());
                        }).box.width(context.screenWidth - 50).make(),*/
                  ],
                )
                    .box
                    .white
                    .outerShadowMd
                    .padding(const EdgeInsets.all(8))
                    .make(),
              ),
              10.heightBox,
              Center(child: normalText(text: anyProblem, color: black)),
              const Spacer(),
            ],
          ),
        ));
  }
}
