import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // 👈 add this
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:whatsapp_clone/res/app_colors.dart';
import 'package:whatsapp_clone/res/components/loader.dart';
import 'package:whatsapp_clone/utils/routes/route_name.dart';
import 'package:whatsapp_clone/utils/routes/routes.dart';
import 'package:whatsapp_clone/utils/utils.dart';
import 'package:whatsapp_clone/view/error_view.dart';
import 'package:whatsapp_clone/view/home_view.dart';
import 'package:whatsapp_clone/view/landing_view.dart';
import 'package:whatsapp_clone/view/login_view.dart';
import 'package:whatsapp_clone/view_model/auth_view_model.dart';

import 'data/firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {

        return OverlaySupport.global(
          child: MaterialApp(
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: AppColors.backgroundColor,
              appBarTheme: AppBarTheme(color: AppColors.appBarColor),
            ),
            debugShowCheckedModeBanner: false,
            home: ref.watch(userDataAuthProvider).when(
              data: (user) {
                if (user == null) {
                  return const LoginView();
                } else {
                  return const HomeView();
                }
              },
              error: (err, trace) {
                return ErrorView(error: err.toString());
              },
              loading: () => const Loader(),
            ),
            onGenerateRoute: Routes.generateRoute,
          ),
        );
      },
    );
  }
}