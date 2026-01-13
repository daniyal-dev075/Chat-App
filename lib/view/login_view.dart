import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/res/components/custom_button.dart';
import 'package:whatsapp_clone/res/components/loader.dart';
import 'package:whatsapp_clone/view_model/auth_view_model.dart';
import '../res/app_colors.dart';
import '../utils/utils.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final phoneController = TextEditingController();
  Country? country;
  @override

  void pickCountry(){
    showCountryPicker(context: context, onSelect: (Country _country){
      setState(() {
        country = _country;
      });
    });
  }
  bool isLoading = false; // put this at the top of your State class

  void sendPhoneNumber() async {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      String normalized = Utils().normalizePhoneNumber(phoneNumber, country!.phoneCode);
      setState(() => isLoading = true);
      try {
        await ref.read(authControllerProvider).signInWithPhoneNumber(context, normalized);
        // Do NOT set isLoading = false here because navigation will occur
      } catch (e) {
        Utils().toastMessage(e.toString());
        if (mounted) setState(() => isLoading = false);
      }
    } else {
      Utils().toastMessage('Fill out fields');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Enter your Phone Number'),
        backgroundColor: AppColors.backgroundColor,
      ),
      body: isLoading ? Loader() :Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [
              SizedBox(height: 10.h),
              Center(child: Text('WhatsApp will need to verify your Phone Number')),
              SizedBox(height: 10.h),
              TextButton(
                onPressed: () {
                  pickCountry();
                },
                child: Text(
                  'Pick Country',
                  style: TextStyle(color: AppColors.tabColor, fontSize: 16.sp),
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(country!=null)
                      Text('+${country!.phoneCode}',style: TextStyle(fontSize: 14.sp),),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.grey,
                        controller: phoneController,
                        decoration: InputDecoration(
                          hintText: 'Phone Number',
                          hintStyle: const TextStyle(color: Colors.grey),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 2),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 2),
                          ),
                          disabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],),
            Padding(
              padding: const EdgeInsets.only(bottom: 70.0),
              child: Column(
                children: [
                  CustomButton(
                    title: 'Next',
                    onPressed: sendPhoneNumber,
                    width: 100.w,
                    borderRadius: 0,
                    textStyle: TextStyle(color: Colors.black, fontSize: 16.sp),
                  ),
                ],
              ),
            ),
          ]
      ),
    );
  }
}