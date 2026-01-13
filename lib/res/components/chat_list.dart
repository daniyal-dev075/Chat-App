import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/model/message_model.dart';
import 'package:whatsapp_clone/res/components/my_message.dart';
import 'package:whatsapp_clone/res/components/sender_message_card.dart';
import 'package:whatsapp_clone/view_model/chat_view_model.dart';

import 'loader.dart';

class ChatList extends ConsumerStatefulWidget {
  final String receiverUserId;
  const ChatList({super.key,required this.receiverUserId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {

  final ScrollController messageController = ScrollController();

  @override
  void dispose (){
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream: ref.watch(chatControllerProvider).chatStream(widget.receiverUserId),
      builder: (context,snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Loader());
        }
        
        SchedulerBinding.instance.addPostFrameCallback((_){
          messageController.jumpTo(messageController.position.maxScrollExtent);
        });
        return ListView.builder(
          controller: messageController,
          itemCount: snapshot.data!.length,
            itemBuilder: (context,index){
            final messageData = snapshot.data![index];
            var timeSent = DateFormat.Hm().format(messageData.timeSent);
          if(messageData.senderId == FirebaseAuth.instance.currentUser!.uid){
            return MyMessage(message: messageData.text, time: timeSent);
          }
            return SenderMessageCard(message: messageData.text, time: timeSent);
        });
      }
    );
  }
}
