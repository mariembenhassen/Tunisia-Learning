// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter_first_project/screens/my_profile/my_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/screens/home_screen/home_screen.dart';

//stf
class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: Colors.white,
        child: Column(
          children: [
            //
            // Close Button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Closes the drawer
                },
              ),
            ),
            //
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      'mariem ben hassen',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    accountEmail: Text(
                      'Teacher',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.normal),
                    ),
                    currentAccountPicture: Icon(
                      Icons.account_circle_sharp,
                      size: 50,
                      color: Color.fromARGB(255, 44, 78, 181),

                      // Colors.white,
                    ),
                    //this if you want to add an image as a cover
                    /* decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/image1.jpeg'),
                        fit: BoxFit.fill,
                      ),
                    ),*/

                    decoration: BoxDecoration(
                      color: Colors.white12,
                    ),
                  ),

                  //home part
                  ListTile(
                    leading: Icon(
                      Icons.home_filled,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 25,
                    ),
                    title: Text(
                      "Tableau de bord",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    ),
                  ),
                  //modifier profile
                  ListTile(
                    leading: Icon(
                      Icons.home_filled,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 25,
                    ),
                    title: Text(
                      "Demande de rattrapage",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    ),
                  ),
                  //
                  //
                  ListTile(
                    leading: Icon(
                      Icons.home_filled,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 25,
                    ),
                    title: Text(
                      "Demande d'absences",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    ),
                  ),
                  //
                  //
                  ListTile(
                    leading: Icon(
                      Icons.home_filled,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 25,
                    ),
                    title: Text(
                      "Cours et exercices ",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    ),
                  ),
                  //
                  //
                  ListTile(
                    leading: Icon(
                      Icons.home_filled,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 25,
                    ),
                    title: Text(
                      "Messagerie interne",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    ),
                  ),
                  //
                  //
                  ListTile(
                    leading: Icon(
                      Icons.home_filled,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 25,
                    ),
                    title: Text(
                      "Cours en ligne",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    ),
                  ),
                  //
                  //
                  ListTile(
                    leading: Icon(
                      Icons.home_filled,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 25,
                    ),
                    title: Text(
                      "Documents",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    ),
                  ),
                  //
                  //divider2
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text(
                      'Notification',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                    onTap: () => null,
                    trailing: ClipOval(
                      child: Container(
                        color: Colors.red,
                        width: 20,
                        height: 20,
                        child: Center(
                          child: Text(
                            '8',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //modifier profile
                  ListTile(
                    leading: Icon(
                      Icons.manage_accounts_rounded,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      size: 25,
                    ),
                    title: Text(
                      "Accés et Coordonnés",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                          fontWeight: FontWeight.normal),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyProfileScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
