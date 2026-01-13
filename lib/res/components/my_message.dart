import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/res/info.dart';

import '../app_colors.dart';

class MyMessage extends StatefulWidget {
  final String message;
  final String time;
  const MyMessage({super.key, required this.message, required this.time});

  @override
  State<MyMessage> createState() => _MyMessageState();
}

class _MyMessageState extends State<MyMessage> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          color: AppColors.messageColor,
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
                bottom: 4,
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
