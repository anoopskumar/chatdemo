import 'dart:developer';

import 'package:chat_app/core/enums/enums.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/others/base_viewmodel.dart';
import 'package:chat_app/core/service/database_service.dart';
import 'package:chat_app/core/service/notification_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/service/auth_service.dart';

class SignupViewmodel extends BaseViewmodel{
  final AuthService _auth;
  final DatabaseService _db;

  SignupViewmodel(this._auth,this._db);

  String _name="";
   String _email="";
     String _password="";
       String _confirmPassword="";

      setName(String value){
    _name=value;
    notifyListeners();
    log("Name: $_name");
  }

 

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

    setConfirmPassword(String value){
    _confirmPassword=value;
    notifyListeners();
     log("confirm Passwoed: $_confirmPassword");
  }




  signup()async{
    setState(ViewState.loading);
    try {

      if(_password !=_confirmPassword){
        throw Exception("The Password do not match");
      }
    final res= await  _auth.signup(_email, _password);
    if(res!=null){
      final usertoken= NotificationService.instance.mtoken;
    UserModel user=UserModel(uid: res.uid,name: _name,email:_email,userDeviceToken: usertoken );
   await _db.saveUser(user.toMap());
    }
      setState(ViewState.idle);
    }on FirebaseAuthException catch (e) {
      setState(ViewState.idle);
      rethrow;
    }catch (e) {
      log(e.toString());
      setState(ViewState.idle);
      rethrow;
    }

  }
}