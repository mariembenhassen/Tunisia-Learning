//import 'package:flutter_first_project/screens/selection_screen/selection.dart';
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

/*
Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  //all screens will be registered here like manifest in android
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  MyProfileScreen.routeName: (context) => MyProfileScreen(),
  ParentHomeScreen.routeName: (context) => ParentHomeScreen(),
   '/child_detail': (context) => ChildDetailScreen(),
 // ChildDetailScreen.routeName: (context) => ChildDetailScreen(),
  // ChildDetailScreen.routeName: (context) => ChildDetailScreen(
  // child: ModalRoute.of(context)?.settings.arguments
  //    as Map<String, dynamic>? ??
  // {},
  //),

  //StudentsListScreen.routeName: (context) => StudentsListScreen(),
}; */

/*import 'package:brain_school/screens/login_screen/login_screen.dart';
import 'package:brain_school/screens/splash_screen/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'screens/assignment_screen/assignment_screen.dart';
import 'screens/datesheet_screen/datesheet_screen.dart';
import 'screens/fee_screen/fee_screen.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/my_profile/my_profile.dart';

Map<String, WidgetBuilder> routes = {
  //all screens will be registered here like manifest in android
  SplashScreen.routeName: (context) => SplashScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  MyProfileScreen.routeName: (context) => MyProfileScreen(),
  FeeScreen.routeName: (context) => FeeScreen(),
  AssignmentScreen.routeName: (context) => AssignmentScreen(),
  DateSheetScreen.routeName: (context) => DateSheetScreen(),
};*/
