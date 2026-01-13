import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/view_model/chat_view_model.dart';

import '../app_colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  const BottomChatField({super.key, required this.receiverUserId});

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref
          .read(chatControllerProvider)
          .sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
          );
      setState(() {
        _messageController.text = '';
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _messageController,
              onChanged: (val){
                if(val.isNotEmpty){
                  setState(() {
                    isShowSendButton = true;
                  });
                }else{
                  setState(() {
                    isShowSendButton = false;
                  });
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.mobileChatBoxColor,
                prefixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Icon(Icons.emoji_emotions, color: Colors.grey),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Icon(Icons.attach_file, color: AppColors.tabColor),
                    ],
                  ),
                ),
                hintText: 'Type your message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none),
                ),
                contentPadding: EdgeInsets.all(10),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.tabColor,
            child: GestureDetector(
              onTap: () {
                sendTextMessage();
              },
              child: isShowSendButton
                  ? Icon(Icons.send, color: Colors.white)
                  : Icon(Icons.mic, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
