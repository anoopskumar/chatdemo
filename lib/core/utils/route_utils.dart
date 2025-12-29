import 'package:chat_app/core/constants/string.dart';
import 'package:chat_app/core/models/user_model.dart';
import 'package:chat_app/ui/screens/auth/login/login_screen.dart';
import 'package:chat_app/ui/screens/auth/signup/signup_screen.dart';
import 'package:chat_app/ui/screens/bottom_navigation/chat_list/chat_room/chat_screen.dart';
import 'package:flutter/material.dart';

import '../../ui/screens/bottom_navigation/bottom_navigation_screen.dart';
import '../../ui/screens/home/home_screen.dart';
import '../../ui/screens/splash/splash_screen.dart';
import '../../ui/screens/wrapper/wrapper.dart';

class RouteUtils {
  static Route<dynamic?> onGenerateRoute(RouteSettings settings){

final args=settings.arguments;
    switch(settings.name){
      case splash:
      return MaterialPageRoute(builder: (context)=>SplashScreen());
      //home
      case home:
      return MaterialPageRoute(builder: (context)=>BottomNavigationScreen());
      //Auth
      case signup:
      return MaterialPageRoute(builder: (context)=>SignupScreen());
       case login:
      return MaterialPageRoute(builder: (context)=>LoginScreen());
      case wrapper:
      return MaterialPageRoute(builder: (context)=>Wrapper());
      case chatRoom:
      return MaterialPageRoute(builder: (context)=>ChatScreen(receiver:args as UserModel ,));
      
      default:
      return MaterialPageRoute(
            builder: (context) => const MaterialApp(
                  home: Center(child: Text("No Route Found")),
                ));
    }
   
    
  }
}