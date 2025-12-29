import 'dart:developer';

import 'package:chat_app/core/constants/string.dart';
import 'package:chat_app/core/enums/enums.dart';
import 'package:chat_app/core/extension/widget_extension.dart';
import 'package:chat_app/core/service/auth_service.dart';
import 'package:chat_app/ui/screens/auth/login/login_viewmodel.dart';
import 'package:chat_app/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/constants/styles.dart';
import '../../../../widgets/button_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewmodel(AuthService()),
      child: Consumer<LoginViewmodel>(builder: (context, model, _) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                40.verticalSpace,
                Text(
                  "Login",
                  style: h,
                ),
                5.verticalSpace,
                Text(
                  "Please Log In to Your Account",
                  style: body.copyWith(color: grey),
                ),
                30.verticalSpace,
                //const Expanded(flex: 2,child: SizedBox.shrink(),),
                CustomTextField(
                  onChanged: model.setEmail,
                  hintText: 'Enter Email',
                ),
                24.verticalSpace,
                CustomTextField(
                  onChanged: model.setPassword,
                  hintText: 'Enter Password',
                ),
                20.verticalSpace,
                CustomButton(
                  loading: model.state==ViewState.loading,
                  text: 'Login',
                  onPressed:model.state==ViewState.loading?null: () async {
                    try {
                      await model.login();
                      context.showSnackbar("User logged up successfully!");
                      Navigator.pushNamed(context, home);
                    } on FirebaseAuthException catch (e) {
                      context.showSnackbar(e.toString());
                    } catch (e) {
                      context.showSnackbar(e.toString());
                    }
                  },
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have Account? ",
                      style: body.copyWith(color: Colors.grey),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, signup);
                        },
                        child: Text(
                          "Sign Up",
                          style: body.copyWith(fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
                const Expanded(
                  flex: 2,
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
