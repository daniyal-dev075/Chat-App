
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/utils/routes/route_name.dart';
import 'package:whatsapp_clone/view/error_view.dart';
import 'package:whatsapp_clone/view/home_view.dart';
import 'package:whatsapp_clone/view/landing_view.dart';
import 'package:whatsapp_clone/view/login_view.dart';
import 'package:whatsapp_clone/view/otp_view.dart';
import 'package:whatsapp_clone/view/select_contact_view.dart';
import 'package:whatsapp_clone/view/user_info_view.dart';

import '../../res/info.dart';
import '../../view/chat_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.homeView:
        return MaterialPageRoute(
          builder: (BuildContext context) => HomeView(),
        );
      case RouteName.chatView:
        final arguments = settings.arguments as Map<String,dynamic>;
        final name = arguments['name'];
        final uid = arguments['uid'];
        final isOnline = arguments['isOnline'];
        return MaterialPageRoute(
          builder: (BuildContext context) => ChatView(name: name,uid: uid,),
        );
      case RouteName.landingView:
        return MaterialPageRoute(
          builder: (BuildContext context) => LandingView(),
        );
      case RouteName.loginView:
        return MaterialPageRoute(
          builder: (BuildContext context) => LoginView(),
        );
      case RouteName.otpView:
        final verificationId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => OtpView(verificationId: verificationId,),
        );
      case RouteName.userInfoView:
        return MaterialPageRoute(
          builder: (BuildContext context) => UserInfoView(),
        );
      case RouteName.errorView:
        final error = settings.arguments as String;
        return MaterialPageRoute(
          builder: (BuildContext context) => ErrorView(error: error,),
        );
      case RouteName.selectContactView:
        return MaterialPageRoute(
          builder: (BuildContext context) => SelectContactView(),
        );
      default:
        return MaterialPageRoute(
          builder: (BuildContext context) => ErrorView(error: 'Failed to load View')
        );
    }
  }
}