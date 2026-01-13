import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp_clone/res/app_colors.dart';
import 'package:whatsapp_clone/res/components/contacts_list.dart';
import 'package:whatsapp_clone/view_model/auth_view_model.dart';

import '../utils/routes/route_name.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        ref.read(authControllerProvider).setUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3, child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: Text('WhatsApp',style: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle: false,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search,color: Colors.grey,)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert,color: Colors.grey,)),
        ],
        bottom: TabBar(
          indicatorColor: AppColors.tabColor,
          indicatorWeight: 4.w,
          labelColor: AppColors.tabColor,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
          Tab(text: 'CHATS',),
          Tab(text: 'STATUS',),
          Tab(text: 'CALLS',)
        ]),
      ),
      body: const TabBarView(
        children: [
          ContactsList(), // CHATS
          Center(child: Text("Status screen coming soon")), // STATUS
          Center(child: Text("Calls screen coming soon")), // CALLS
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, RouteName.selectContactView);
      },backgroundColor: AppColors.tabColor,child: Icon(Icons.comment),),
    )
    );
    
  }
}
