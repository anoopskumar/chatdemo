import 'dart:developer';

import 'package:chat_app/core/enums/enums.dart';
import 'package:chat_app/core/others/base_viewmodel.dart';

import '../../../../../core/models/user_model.dart';
import '../../../../../core/service/database_service.dart';

class ChatListViewmodel extends BaseViewmodel {
  final DatabaseService _db;
  final UserModel _currentUser;

  ChatListViewmodel(this._db,this._currentUser){
    fetchUser();
  }
  List<UserModel> _users =[];

   List<UserModel> _filteredUsers =[];

   List<UserModel> get users=> _users;

   List<UserModel> get filteredUser=> _filteredUsers;

  search(String value){
    _filteredUsers=_users.where((e)=>e.name!.toLowerCase().contains(value)).toList();
    notifyListeners();

  }


  fetchUser()async{
    try {
      setState(ViewState.loading);
    //final res=  await _db.fetchUsers(_currentUser.uid!);

    _db.fetchUserStream(_currentUser.uid!).listen((data){
     _users= data.docs.map((e)=>UserModel.fromMap(e.data())).toList();
     _filteredUsers=users;
     notifyListeners();

    });
    // if(res != null){
    //     _users =res.map((e)=>UserModel.fromMap(e!)).toList();
    //     _filteredUsers=users;
    //     notifyListeners();

    // }
    setState(ViewState.idle);
    } catch (e) {
      setState(ViewState.idle);
      log("Error Fetching Users: $e");
    }
  }
}