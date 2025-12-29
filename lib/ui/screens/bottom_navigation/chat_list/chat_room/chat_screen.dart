import 'package:chat_app/core/constants/color.dart';
import 'package:chat_app/core/extension/widget_extension.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/core/service/chat_service.dart';
import 'package:chat_app/ui/screens/bottom_navigation/chat_list/chat_room/chat_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/styles.dart';
import '../../../../../core/service/notification_service.dart';
import '../../../../../widgets/textfield.dart';
import '../../../other/user_provider.dart';
import 'chat_widgets.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key,required this.receiver});

  final UserModel receiver;

  @override
  Widget build(BuildContext context) {
        final currentUser = Provider.of<UserProvider>(context).user;
    return ChangeNotifierProvider(
      create: (context) => ChatViewmodel(ChatService(), currentUser!, receiver),
      child: Consumer<ChatViewmodel>(
        builder: (context,model,_) {
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.sw * 0.05),
                    child: Column(
                      children: [
                        30.verticalSpace,
                        _buildHeader(context, name: receiver.name??''),
                        30.verticalSpace,
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(0),

                          itemBuilder: (context, index) { 
                            final message = model.message[index];
                           return ChatBubble(
                            isCurrentUser: message.senderId == currentUser!.uid,
                            message:message,
                          );
                          },
                          itemCount: model.message.length,
                          separatorBuilder: (context, index) => 10.verticalSpace,
                        ))
                      ],
                    ),
                  ),
                ),
                BottomField(
                  controller: model.controller,
                  // onChanged: (p0) {
                  // },
                  onTap: ()async {
                    try {
                    await   model.saveMessage();
                    await NotificationService.instance.sendNotification('${currentUser?.name}', model.message.last.content.toString(),receiver.userDeviceToken??'');

                    //await NotificationService.instance.sendNotification('${currentUser?.name}', model.message.last.toString());
                    
                    } catch (e) {

                      context.showSnackbar(e.toString());
                      
                    }
                   
                  },
                )
              ],
            ),
          );
        }
      ),
    );
  }

  Row _buildHeader(BuildContext context,{String name = ''}) {
    return Row(
      children: [
        InkWell(
          onTap:()=> Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.only(left: 10, top: 6, bottom: 6),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: grey.withOpacity(0.15)),
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        20.horizontalSpace,
        Text(
          name,
          style: h.copyWith(fontSize: 20.sp),
        ),
        Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: grey.withOpacity(0.15)),
          child: Icon(Icons.more_vert),
        ),
      ],
    );
  }
}

