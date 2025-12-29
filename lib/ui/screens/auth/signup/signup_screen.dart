import 'package:chat_app/core/constants/string.dart';
import 'package:chat_app/core/extension/widget_extension.dart';
import 'package:chat_app/core/service/auth_service.dart';
import 'package:chat_app/core/service/database_service.dart';
import 'package:chat_app/ui/screens/auth/signup/signup_viewmodel.dart';
import 'package:chat_app/widgets/button_widget.dart';
import 'package:chat_app/widgets/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/color.dart';
import '../../../../core/constants/styles.dart';
import '../../../../core/enums/enums.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignupViewmodel(AuthService(),DatabaseService()),
      child: Consumer<SignupViewmodel>(builder: (context, model, _) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                40.verticalSpace,
                Text(
                  "Create your Account",
                  style: h,
                ),
                5.verticalSpace,
                Text(
                  "Please provide the details",
                  style: body.copyWith(color: grey),
                ),
                24.verticalSpace,
                CustomTextField(
                  onChanged: model.setName,
                  hintText: 'Enter Name',
                ),
                24.verticalSpace,
                CustomTextField(
                  onChanged: model.setEmail,
                  hintText: 'Enter Email',
                ),
                24.verticalSpace,
                CustomTextField(
                  onChanged: model.setPassword,
                  hintText: 'Enter Password',
                  isPassword:true ,
                ),
                24.verticalSpace,
                CustomTextField(
                  onChanged: model.setConfirmPassword,
                  hintText: 'Confirm Password',
                  isPassword:true ,
                ),
                30.verticalSpace,
                CustomButton(
                  loading: model.state==ViewState.loading,
                  text: 'Sign Up',
                  onPressed:model.state==ViewState.loading?null: () async {
                    try {
                      await model.signup();
                      context.showSnackbar("User signed up successfully!");
                      Navigator.pop(context);
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
                      "Already have Account? ",
                      style: body.copyWith(color: Colors.grey),
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, login);
                        },
                        child: Text(
                          "Login",
                          style: body.copyWith(fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
