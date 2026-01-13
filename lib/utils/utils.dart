import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart' hide Toast;
import 'package:whatsapp_clone/res/app_colors.dart';

class Utils {
  void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.tabColor,
        timeInSecForIosWeb: 2,
        fontSize: 16.sp
    );
  }

  Future<File?> pickImageFromGallery(BuildContext context) async {
    File? image;
    try{
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(pickedImage != null){
        image = File(pickedImage.path);
      }
    }catch (e){
      toastMessage(e.toString());
    }
    return image;
  }
   String normalizePhoneNumber(String? phoneNumber, String countryCode) {
    if (phoneNumber == null || phoneNumber.isEmpty) return '';

    phoneNumber = phoneNumber.trim().replaceAll(' ', '').replaceAll('-', '');

    if (phoneNumber.startsWith('+')) {
      return phoneNumber; // already correct
    }

    if (phoneNumber.startsWith('0')) {
      return '+$countryCode${phoneNumber.substring(1)}';
    }

    return '+$countryCode$phoneNumber';
  }
  void showNotificationBanner(String title, String body) {
    showOverlayNotification(
          (context) {
        return SafeArea(
          child: Container(
            margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 8,
              color: AppColors.tabColor,
              child: ListTile(
                leading: const Icon(Icons.notifications, color: Colors.white, size: 28),
                title: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  body,
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    OverlaySupportEntry.of(context)?.dismiss();
                  },
                ),
              ),
            ),
          ),
        );
      },
      duration: const Duration(seconds: 4), // stays for 4 seconds
      position: NotificationPosition.top,   // slides from top
    );
  }



}