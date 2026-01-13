import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp_clone/view_model/auth_view_model.dart';

import '../res/app_colors.dart';
import 'package:whatsapp_clone/utils/utils.dart';

class UserInfoView extends ConsumerStatefulWidget {
  const UserInfoView({super.key});

  @override
  ConsumerState<UserInfoView> createState() => _UserInfoViewState();
}

class _UserInfoViewState extends ConsumerState<UserInfoView> {

  final TextEditingController nameController = TextEditingController();
  File? image;
  @override
  void dispose(){
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    image = await Utils().pickImageFromGallery(context);
    setState(() {
    });
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if(name.isNotEmpty){
      ref.read(authControllerProvider).saveUserDataToFirebase(context, name, image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Center(
              child: Stack(
                children: [
                 image == null ? CircleAvatar(
                    radius: 64.r,
                   backgroundColor: Colors.grey,
                   child: Icon(Icons.person,size: 70,),
                  ) : CircleAvatar(
                   radius: 64.r,
                   backgroundImage: FileImage(image!)
                 ),
                  Positioned(
                    bottom: -10,
                      left: 80,
                      child: IconButton(onPressed: (){selectImage();}, icon: Icon(Icons.add_a_photo)))
                ],
              ),
            ),
            SizedBox(height: 40.h,),
            Row(
              children: [
                Container(
                  width: 300.w,
                  padding: EdgeInsets.only(top: 20,left: 15,right: 10,bottom: 20),
                  child: TextField(
                    cursorColor: AppColors.tabColor,
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Name',
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.tabColor, width: 2),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                  ),
                ),
                IconButton(onPressed: storeUserData, icon: Icon(Icons.done))
              ],
            )
          ],
        ),
      ),
    );
  }
}
