import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/view_model/auth_view_model.dart';

import '../res/app_colors.dart';

class OtpView extends ConsumerWidget {
  final String verificationId;
  const OtpView({super.key, required this.verificationId});

  void verifyOtp(
    BuildContext context,
    WidgetRef ref,
    String verificationId,
    String userOtp,
  ) {
    ref
        .read(authControllerProvider)
        .verifyOtp(context, verificationId, userOtp);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verifying your Number'),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: Column(
        children: [
          SizedBox(height: 20.h),
          Center(child: Text('We have sent an SMS with a code')),
          SizedBox(
            width: 150.w,
            child: TextField(
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              cursorColor: AppColors.tabColor,
              decoration: InputDecoration(
                hintText: '- - - - - -',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 30),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.tabColor, width: 2),
                ),
                disabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                ),
              ),
              onChanged: (val) {
                if(val.length == 6){
                  verifyOtp(context, ref, verificationId, val.trim());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
