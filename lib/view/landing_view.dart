import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/res/app_colors.dart';
import 'package:whatsapp_clone/res/components/custom_button.dart';

import '../utils/routes/route_name.dart';

class LandingView extends StatefulWidget {
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(height: 40.h),
            Center(
              child: Text(
                'Welcome to WhatsApp',
                style: TextStyle(fontSize: 30.sp),
              ),
            ),
            SizedBox(height: 40.h),
            Image.asset(
              'images/bg.png',
              color: AppColors.tabColor,
              height: 340,
              width: 340,
            ),
            SizedBox(height: 70.h),
            Center(
              child: Text(
                'Read our Privacy Policy.Tap \"Agree and Continue\" to accept the Terms of Service',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20.h,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomButton(borderRadius: 0,width: 200,title: 'Agree and Continue', onPressed: (){
                Navigator.pushNamed(context, RouteName.loginView);
              }),
            ),
          ],
        ),
      ),
    );
  }
}
