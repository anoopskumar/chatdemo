import 'package:chat_app/core/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final _fire = FirebaseFirestore.instance;

  saveMessage(Map<String, dynamic> message, String chatRoomId) async {
    try {
      await _fire
          .collection("chatRooms")
          .doc(chatRoomId)
          .collection("messages")
          .add(message);
    } catch (e) {}
  }

  updateLastMessage(String currentUid,String receiverUid,String message,int timestamp) async {
     try {
      await _fire
          .collection("users")
          .doc(currentUid).update({"lastMessage":{
            "content":message,
            "timestamp":timestamp,
            "senderId":'$currentUid _ $receiverUid'
          },
          "unreadCounter":FieldValue.increment(1)
          });
      await _fire
          .collection("users")
          .doc(receiverUid).update({"lastMessage":{
            "content":message,
            "timestamp":timestamp,
            "senderId":'$currentUid _ $receiverUid'
          },
           "unreadCounter":0});
    } catch (e) {}
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessage(String chatRoomId) {
    return _fire
        .collection("chatRooms")
        .doc(chatRoomId)
        .collection("messages").orderBy("timestamp",descending: false)
        .snapshots();
  }
}
