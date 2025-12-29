import 'package:chat_app/core/constants/color.dart';
import 'package:chat_app/core/constants/string.dart';
import 'package:chat_app/core/enums/enums.dart';
import 'package:chat_app/core/service/database_service.dart';
import 'package:chat_app/core/service/notification_service.dart';
import 'package:chat_app/ui/screens/bottom_navigation/chat_list/chat_room/chat_list_viewmodel.dart';
import 'package:chat_app/ui/screens/other/user_provider.dart';
import 'package:chat_app/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/styles.dart';
import '../../../../core/models/user_model.dart';

class ChatsListScreen extends StatelessWidget {
  const ChatsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    return ChangeNotifierProvider(
      create: (context) => ChatListViewmodel(DatabaseService(), currentUser!),
      child: Consumer<ChatListViewmodel>(
         builder: (context,model,_) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.05),
            child: Column(
              children: [
                30.verticalSpace,
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${currentUser?.name}',
                    style: h,
                  ),
                ),
                ElevatedButton(onPressed: ()async{
                 // await NotificationService.instance.sendNotification('hello title', 'This is notification body');

                }, child: Text('send Notification')),
                20.verticalSpace,
                 CustomTextField(
                  hintText: 'Search here...',
                  isSearch: true,
                  onChanged: model.search,
                ),
                10.verticalSpace,
               model.state ==ViewState.loading?Center(child: CircularProgressIndicator(),): model.users.isEmpty?Expanded(child: const Center(child: Text("No Users yet"),)):
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (context, index) => 10.verticalSpace,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    itemBuilder: (context, index) {
                      final user = model.filteredUser[index];
                      
                      return ChatTile(
                      user: user,
                      onTap: () => Navigator.pushNamed(context, chatRoom,arguments: user),
                    );
                    },
                    itemCount: model.filteredUser.length,
                    
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, this.onTap,required this.user});
  final UserModel user;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    DateTime now =DateTime.now();
    if(user.lastMessage !=null){

    }
    DateTime lastMessageTime = user.lastMessage ==null?now: DateTime.fromMillisecondsSinceEpoch(user.lastMessage!["timestamp"]);
  
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      onTap: onTap,
      tileColor: grey.withOpacity(0.12),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: grey.withOpacity(.5),
        child: Text((user.name?.isNotEmpty??false)? (user.name![0]):"A",style: h,),
      ),
      title: Text(user.name??''),
      subtitle: Text(
        (user.lastMessage!=null && user.lastMessage?["senderId"] == currentUser?.lastMessage?["senderId"] )?user.lastMessage!["content"]:"",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
           (user.lastMessage!=null && user.lastMessage?["senderId"] == currentUser?.lastMessage?["senderId"] )?"": getTime(),
            style: TextStyle(color: grey),
          ),
          10.verticalSpace,
      user.unreadCounter==0 || user.unreadCounter==null?SizedBox(height: 15,) :   CircleAvatar(
            radius: 10,
            backgroundColor: primary,
            child:(user.lastMessage!=null && user.lastMessage?["senderId"] == currentUser?.lastMessage?["senderId"])  ? Text(
              "${user.unreadCounter}",
              style: small.copyWith(color: white),
            ):Container(),
          )
        ],
      ),
    );
  }

  String getTime(){
    DateTime now =DateTime.now();
    if(user.lastMessage !=null){

    }
    DateTime lastMessageTime = user.lastMessage ==null?now: DateTime.fromMillisecondsSinceEpoch(user.lastMessage!["timestamp"]);
    int minutes = now.difference(lastMessageTime).inMinutes % 60;
    if(minutes<60){
      return "$minutes minutes ago";
    }else{
      return "${now.difference(lastMessageTime).inMinutes % 24} hours ago";
    }

  }
}
