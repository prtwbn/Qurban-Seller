import 'package:get/get.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/auth_controller.dart';
import 'package:qurban_seller/views/home_screen/home.dart';
import 'package:qurban_seller/views/widgets/applogowidget.dart';
import 'package:qurban_seller/views/widgets/custom.dart';
import 'package:qurban_seller/views/widgets/our_button.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  //text controllers
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return 
        Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            boldText(text: "Join the $appname" , size: 18.0, color: lightGrey),
            //"Join the $appname".text.black.size(22).fontFamily(bold).make(),
            15.heightBox,
            Obx(() => Column(
                children: [
                  customTextField(
                      hint: nameHint, title: name, controller: nameController, isPass: false,),
                  customTextField(
                      hint: emailHint, title: email, controller: emailController, isPass: false,),
                  customTextField(
                      hint: passwordHint,
                      title: password,
                      controller: passwordController, isPass: true,),
                  customTextField(
                      hint: passwordHint,
                      title: retypePassword,
                      controller: passwordRetypeController, isPass: true,),
                  Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {}, child: forgetPass.text.make())),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: purpleColor,
                        checkColor: white,
                        value: isCheck,
                        onChanged: (newValue) {
                          setState(() {
                            isCheck = newValue;
                          });
                        },
                      ),
                      10.widthBox,
                      Expanded(
                        child: RichText(
                            text: const TextSpan(children: [
                          TextSpan(
                              text: "I agree to the ",
                              style: TextStyle(
                                  //fontFamily: regular,
                                  //fontSize: 13,
                                  color: fontGrey)),
                          TextSpan(
                              text: termAndCond,
                              style: TextStyle(
                                  //fontFamily: regular,
                                  //fontSize: 13,
                                  color: purpleColor)),
                          TextSpan(
                              text: " & ",
                              style: TextStyle(
                                  //fontFamily: regular,
                                  fontSize: 13,
                                  color: purpleColor)),
                          TextSpan(
                              text: privacyPolicy,
                              style: TextStyle(
                                  //fontFamily: regular,
                                  fontSize: 13,
                                  color: purpleColor)),
                        ])),
                      )
                    ],
                  ),
                  5.heightBox,
                  controller.isloading.value? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(purpleColor),
                      ) : ourButton(
                      color: isCheck == true ? purpleColor : lightGrey,
                      title: signup,
                      //textColor: white,
                      onPress: () async {
                        if (isCheck != false) {
                          controller.isloading(true);
                          try {
                            await controller
                                .signupMethod(
                                    context: context,
                                    email: emailController.text,
                                    password: passwordController.text)
                                .then((value) {
                              return controller.storeUserData(
                                email: emailController.text,
                                password: passwordController.text,
                                name: nameController.text,
                              );
                            }).then((value) {
                              VxToast.show(context, msg: "loggedin");
                              Get.offAll(() => const Home());
                            });
                          } catch (e) {
                            auth.signOut();
                            VxToast.show(context, msg: e.toString());
                            controller.isloading(false);
                          }
                        }
                      }).box.width(context.screenWidth - 50).make(),
                  10.heightBox,
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: alreadyHaveAccount,
                          style: TextStyle(color: fontGrey),
                        ),
                        TextSpan(
                          text: login,
                          style: TextStyle( color: purpleColor),
                        ),
                      ],
                    ),
                  ).onTap(() {
                    Get.back();
                  })
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(const EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ),
          ],
        ),
      ),
    );
  }
}
