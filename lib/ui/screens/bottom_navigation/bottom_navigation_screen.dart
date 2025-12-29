import 'package:chat_app/ui/screens/bottom_navigation/bottom_navigation_viewmodel.dart';
import 'package:chat_app/ui/screens/other/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'chat_list/chat_list_screen.dart';
import 'profile/profile_screen.dart';

// List<Widget> screens = [
//   ChatsListScreen(),
//   ChatsListScreen(),
//   ChatsListScreen()
// ];

class BottomNavigationScreen extends StatelessWidget {
  const BottomNavigationScreen({super.key});

  static final List<Widget> _screens = [
    Center(child: Text("Home Screen")),
    ChatsListScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    final items= const [
      BottomNavigationBarItem(
                label: "",
                icon: BottomNavButton(btnIcon: Icon(Icons.access_alarm),)),
                 BottomNavigationBarItem(
                label: "",
                icon: BottomNavButton(btnIcon: Icon(Icons.message),)),
                 BottomNavigationBarItem(
                label: "",
                icon: BottomNavButton(btnIcon:Icon(Icons.male),)),
    ];
    return ChangeNotifierProvider(
      create: (context) => BottomNavigationViewmodel(),
      child: Consumer<BottomNavigationViewmodel>(builder: (context, model, _) {
        return Scaffold(
          body:currentUser== null?Center(child: CircularProgressIndicator(),): BottomNavigationScreen._screens[model.currentIndex],
          bottomNavigationBar: CustomNavBar(onTap:model.setIndex ,items: items,),
        );
      }),
    );
  }
}

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,this.onTap,required this.items
  });

  final void Function(int)? onTap;
  final List<BottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    final borderRadius = const BorderRadius.only( topRight: Radius.circular(30),
            topLeft: Radius.circular(30),);
    return Container(
      decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
                color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ]),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BottomNavigationBar(
          onTap: onTap,
          elevation: 20,
          items: items,
        ),
      ),
    );
  }
}

class BottomNavButton extends StatelessWidget {
  const BottomNavButton({
    super.key,required this.btnIcon
  });
  final Icon btnIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: btnIcon,
    );
  }
}
