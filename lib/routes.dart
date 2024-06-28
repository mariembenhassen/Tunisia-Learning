
import 'package:flutter_first_project/screens/home_screen/child_detail_screen.dart';
import 'package:flutter_first_project/screens/home_screen/parent_home_screen.dart';
import 'package:flutter_first_project/screens/login_screen/login_screen.dart';
import 'package:flutter_first_project/screens/SplashScreen/SplashScreen.dart';
import 'package:flutter/cupertino.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/my_profile/my_profile.dart';

Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  MyProfileScreen.routeName: (context) => MyProfileScreen(),
  ParentHomeScreen.routeName: (context) => ParentHomeScreen(),
 ChildDetailScreen.routeName: (context) => ChildDetailScreen(),
};


