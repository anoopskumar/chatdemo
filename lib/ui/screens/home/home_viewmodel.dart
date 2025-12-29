
import 'package:chat_app/core/others/base_viewmodel.dart';
import 'package:chat_app/core/service/database_service.dart';

class HomeViewmodel extends BaseViewmodel{
  final DatabaseService _db;
  // UserModel? _currentUser;

  // UserModel? get currentUser=>_currentUser;
  HomeViewmodel(this._db);
  // fetchUserData(String uid)async{
  //   setState(ViewState.loading);
  // final res= await _db.loadUser(uid);
  // if(res!=null) {
  //   _currentUser= UserModel.fromMap(res);


  // }
  // setState(ViewState.idle);
  // }
}