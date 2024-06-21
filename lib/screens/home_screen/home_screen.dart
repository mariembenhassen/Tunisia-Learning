// ignore_for_file: prefer_const_constructors, constant_identifier_names

import 'dart:ui';
import 'package:flutter_first_project/components/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_first_project/components/side_menu.dart';
import 'package:flutter_first_project/constante.dart';
//import 'package:flutter_first_project/screens/assignment_screen/assignment_screen.dart';
//import 'package:flutter_first_project/screens/datesheet_screen/datesheet_screen.dart';
//import 'package:flutter_first_project/screens/fee_screen/fee_screen.dart';
//import 'package:flutter_first_project/screens/my_profile/my_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/screens/login_screen/login_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
//import 'widgets/student_data.dart';

//definition of the custom data

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //the appbar part

      appBar: AppBar(
        //
        backgroundColor: kPrimaryColor,
        // style:
        title: Text(
          'Tunisia Learning',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15.5,
                color: Colors.white,
              ), //
        ),
        actions: [
//
          IconButton(
            icon: Icon(Icons.notifications, size: 30),
            onPressed: () {
              // Handle bell icon press
            },
          ),

          //
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'logout') {
                  // Handle logout action
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.routeName, (route) => false);
                }
              },
              offset: Offset(0, 50), // Adjust the offset for vertical alignment
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.black54),
                      SizedBox(width: 10),
                      Text('Déconnexion'),
                    ],
                  ),
                ),
              ],
              icon: Icon(
                Icons.account_circle_sharp,
                size: 30,
              ),
            ),
          ),

          /*IconButton(
            icon: Icon(Icons.menu_open_rounded, size: 30),
            onPressed: () {
              // Handle custom icon press
            },
          ),*/
        ],
      ),
      drawer: const SideMenu(),
      /*
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: kPrimaryColor,
              ),
              child: Text(
                'KNANI SOUII SIHEM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                'Home',
              ),
              onTap: () {
                // Handle Home tap
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Courses'),
              onTap: () {
                // Handle Courses tap
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Handle Settings tap
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                // Handle logout action
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false); // Adjust your route
              },
            ),
          ],
        ),
      ),*/

      //
      body: Column(
        children: [
          // We will divide the screen into two parts
          // Fixed height for first half
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.5,
            padding: EdgeInsets.all(kDefaultPadding),
            color: kPrimaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nom d'utilisateur :",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 12.0,
                                  ),
                        ),
                        //exemple of a name of user methode get
                        Text('KNANI SOUII SIHEM',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                )),

                        Text(
                          'Nom d\'établissement :',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 12.0,
                                  ),
                        ),
                        Text('Ecole Primaire Ibn Khaldoun',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                )),

                        Text(
                          'Année scolaire en cours:',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 12.0,
                                  ),
                        ),
                        SizedBox(
                          height: kDefaultPadding / 2,
                        ),
                        YearSelectionWidget(),
                      ],
                    ),
                    SizedBox(
                      height: kDefaultPadding / 2,
                    ),
                  ],
                ),
              ],
            ),
          ),
          //the up part done
          //the down part
          //the expanded part
          Expanded(
            child: Container(
              width: 100.w,
              decoration: BoxDecoration(
                color: kOtherColor,
                borderRadius: kTopBorderRadius,
              ),
              child: SingleChildScrollView(
                //for padding
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {},
                          icon: 'assets/icons/quiz.svg',
                          title: 'Take Quiz',
                        ),
                        HomeCard(
                          onPress: () {
                            //go to assignment screen here
                            //Navigator.pushNamed(
                            //context, AssignmentScreen.routeName);
                          },
                          icon: 'assets/icons/assignment.svg',
                          title: 'Assignments',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {},
                          icon: 'assets/icons/holiday.svg',
                          title: 'Holidays',
                        ),
                        HomeCard(
                          onPress: () {},
                          icon: 'assets/icons/timetable.svg',
                          title: 'Time Table',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {},
                          icon: 'assets/icons/result.svg',
                          title: 'Result',
                        ),
                        HomeCard(
                          onPress: () {
                            // Navigator.pushNamed(
                            //  context, DateSheetScreen.routeName);
                          },
                          icon: 'assets/icons/datesheet.svg',
                          title: 'DateSheet',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {},
                          icon: 'assets/icons/ask.svg',
                          title: 'Ask',
                        ),
                        HomeCard(
                          onPress: () {},
                          icon: 'assets/icons/gallery.svg',
                          title: 'Gallery',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        HomeCard(
                          onPress: () {},
                          icon: 'assets/icons/event.svg',
                          title: 'Events',
                        ),
                        HomeCard(
                          onPress: () {},
                          icon: 'assets/icons/logout.svg',
                          title: 'Logout',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard(
      {Key? key,
      required this.onPress,
      required this.icon,
      required this.title})
      : super(key: key);
  final VoidCallback onPress;
  final String icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.only(top: 1.h),
        width: 40.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(kDefaultPadding / 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40.sp,
              width: SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40.sp,
              color: kOtherColor,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }
}

class YearSelectionWidget extends StatefulWidget {
  @override
  _YearSelectionWidgetState createState() => _YearSelectionWidgetState();
}

class _YearSelectionWidgetState extends State<YearSelectionWidget> {
  // Initialize the selected year
  String _selectedYear = '2023-2024';

  // List of years to select from
  final List<String> _years = [
    '2023-2024',
    '2022-2023',
    '2021-2022',
    '2020-2021',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: kOtherColor,
        borderRadius: BorderRadius.circular(kDefaultPadding),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedYear,
          onChanged: (String? newValue) {
            setState(() {
              _selectedYear = newValue!;
            });
          },
          items: _years.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12.0,
                  color: kTextBlackColor,
                  fontWeight: FontWeight.w200,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
