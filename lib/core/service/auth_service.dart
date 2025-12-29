import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth=FirebaseAuth.instance;

   Future<User?> signup(String email,String password)async{
   try {
     final authCredential= await _auth.createUserWithEmailAndPassword(email: email, password: password);

   if(authCredential.user!=null){
      log("User created sucessfully");
      return authCredential.user;
   }
 return null;
   } 
   on FirebaseAuthException catch(e){
      log(e.message!);
       rethrow;
   }
   catch (e) {
     log(e.toString());
      rethrow;
   }
  }

  Future login(String email,String password)async{
    try {
     final authCredential= await _auth.signInWithEmailAndPassword(email: email, password: password);

   if(authCredential.user!=null){
      log("User loggedin sucessfully");
   }

   } 
   on FirebaseAuthException catch(e){
      log(e.message!);
      rethrow;
   }
   catch (e) {
     log(e.toString());
     rethrow;
   }

  }


  Future<void> logout()async{
    try {
      await _auth.signOut();
    } catch (e) {

      log(e.toString());
      rethrow;
      
    }
  }
}