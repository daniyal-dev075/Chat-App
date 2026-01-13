import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/res/info.dart';

import '../app_colors.dart';

class SenderMessageCard extends StatefulWidget {
  final String message;
  final String time;
  const SenderMessageCard({super.key, required this.message, required this.time});

  @override
  State<SenderMessageCard> createState() => _SenderMessageCardState();
}

class _SenderMessageCardState extends State<SenderMessageCard> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          color: AppColors.senderMessageColor,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ),
                child: Text(widget.message,style: TextStyle(fontSize: 16.sp),),
              ),
              Positioned(
                  bottom: 2,
                  right: 10,
                  child: Row(
                    children: [
                      Text(widget.time,style: TextStyle(fontSize: 13.sp,color: Colors.white60),),
                      SizedBox(width: 5.w,),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
