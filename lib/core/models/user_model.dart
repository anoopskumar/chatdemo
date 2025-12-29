import 'dart:convert';

class UserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? imageUrl;
  final Map<String,dynamic>? lastMessage;
  final int? unreadCounter;
  final String? userDeviceToken;


  UserModel({
    this.uid,
    this.name,
    this.email,
    this.imageUrl,
    this.lastMessage,
    this.unreadCounter,
    this.userDeviceToken,
  });


  Map<String,dynamic> toMap(){
    return <String,dynamic>{
      'uid':uid,
      'name':name,
      'email':email,
      'imageurl':imageUrl,
      'lastMessage':lastMessage,
      'unreadCounter':unreadCounter,
      'userDeviceToken' :userDeviceToken

    };
  }

  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
      uid: map['uid'] !=null?map['uid'] as String :null,
       name: map['name'] !=null?map['name'] as String :null, 
        email: map['email'] !=null?map['email'] as String :null,
         imageUrl: map['imageUrl'] !=null?map['imageUrl'] as String :null,
         lastMessage: map['lastMessage'] !=null ?Map<String, dynamic>.from((map['lastMessage'] as Map<String,dynamic>)):null,
         unreadCounter:map['unreadCounter'] !=null?map['unreadCounter'] as int :null,
         userDeviceToken:map['userDeviceToken'] !=null?map['userDeviceToken'] as String:null
    );
  }

  String toJson() => json.encode(toMap());
  
  factory UserModel.fromJson(String source)=>UserModel.fromMap(json.decode(source));

  @override
  String toString(){
    return 'UserModel(uid:$uid,name:$name,email:$email,imageurl:$imageUrl,lastMessage:$lastMessage,unreadCounter:$unreadCounter,userDeviceToken:$userDeviceToken)';
  }
}