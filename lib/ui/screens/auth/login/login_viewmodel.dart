import 'dart:developer';

import 'package:chat_app/core/enums/enums.dart';
import 'package:chat_app/core/others/base_viewmodel.dart';
import 'package:chat_app/core/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginViewmodel extends BaseViewmodel{
  final AuthService _auth;

  LoginViewmodel(this._auth);

  String _email='';
  String _password='';

  setEmail(String value){
    _email=value;
    notifyListeners();
    log("Email: $_email");
  }

   setPassword(String value){
    _password=value;
    notifyListeners();
     log("Passwoed: $_password");
  }

  login()async{
    setState(ViewState.loading);
    try {
     await  _auth.login(_email, _password);
      setState(ViewState.idle);
    }on FirebaseAuthException catch (e) {
      rethrow;
    }catch (e) {
      log(e.toString());
            setState(ViewState.idle);
      rethrow;
    }
   
  }
}