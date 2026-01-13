import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorView extends StatefulWidget {
  final String error;
  const ErrorView({super.key,required this.error});

  @override
  State<ErrorView> createState() => _ErrorViewState();
}

class _ErrorViewState extends State<ErrorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text(widget.error,style: TextStyle(fontSize: 30.sp,color: Colors.grey),))
        ],
      ),
    );
  }
}
