import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:whatsapp_clone/res/components/bottom_chat_field.dart';
import 'package:whatsapp_clone/res/components/chat_list.dart';
import 'package:whatsapp_clone/res/components/loader.dart';
import 'package:whatsapp_clone/view_model/auth_view_model.dart';

import '../res/app_colors.dart';

class ChatView extends ConsumerWidget {
  final String name;
  final String uid;
  const ChatView({super.key,required this.name,required this.uid});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: StreamBuilder<UserModel>(
          stream: ref.read(authControllerProvider).userDataById(uid),
            builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              return Loader();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,style: TextStyle(fontSize: 18.sp),),
                Text(snapshot.data!.isOnline ? 'Online' : 'Offline',style: TextStyle(fontSize: 13.sp),),
              ],
            );
        }),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.video_call,color: Colors.grey,)),
          IconButton(onPressed: (){}, icon: Icon(Icons.call,color: Colors.grey,)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color: Colors.grey,)),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: ChatList(receiverUserId: uid,)),
          BottomChatField(receiverUserId: uid,),
        ],
      ),
    );
  }
}
