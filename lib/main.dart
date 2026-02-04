import 'dart:developer';

import 'package:chat_app/core/service/database_service.dart';
import 'package:chat_app/core/service/kotlin_service.dart';
import 'package:chat_app/core/service/notification_service.dart';
import 'package:chat_app/core/utils/route_utils.dart';
import 'package:chat_app/ui/screens/other/user_provider.dart';
import 'package:chat_app/ui/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey= GlobalKey<NavigatorState>();

void main()async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
 int battery = await BatteryService.getBatteryLevel();
  log("Battery level: $battery%");
  await NotificationService.instance.initialize();
  
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) =>ChangeNotifierProvider(
        create: (context) => UserProvider(DatabaseService()),
        child:  MaterialApp(
          
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark,seedColor: const Color.fromARGB(255,171,222,244))),
          navigatorKey: navigatorKey,
          onGenerateRoute:RouteUtils.onGenerateRoute ,
          home: Center(
            child: SplashScreen(),
          ),
        ),
      ),
       );
  }
}
