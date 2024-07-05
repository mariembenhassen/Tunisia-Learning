import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_first_project/components/side_menu_parent.dart';
import 'package:flutter_first_project/screens/assignment_screen/course_list_screen.dart';
import 'package:flutter_first_project/screens/data/course_model.dart';
import 'package:flutter_first_project/screens/emploi_du_temps_screen/emploi_du_temps_screen.dart';
import 'package:flutter_first_project/screens/login_screen/login_screen.dart';
import 'package:flutter_first_project/constante.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_first_project/components/side_menu_parent.dart';
import 'package:flutter_first_project/screens/login_screen/login_screen.dart';

import 'package:flutter_first_project/constante.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChildDetailScreen extends StatelessWidget {
  static const routeName = 'ChildDetailScreen';

  final String apiUrl =
      'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_child_detail.php';

  Future<Map<String, dynamic>> fetchChildDetails(int id) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'id': id.toString()},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else {
      throw Exception('Failed to load child details');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null || args['child'] == null) {
      // Handle if no child data is passed
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error: No child data provided.'),
        ),
      );
    }

    final int childId =
        int.parse(args['child']['id'].toString()); // Convert id to integer

    late Future<Map<String, dynamic>> futureChildDetails =
        fetchChildDetails(childId);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Tunisia Learning',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15.5,
                color: Colors.white,
              ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 30),
            onPressed: () {
              // Handle bell icon press
            },
          ),
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
              offset: Offset(0, 50),
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
        ],
      ),
      drawer: const SideMenu(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureChildDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('No data found'),
            );
          }

          var childData = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 3.2,
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
                                'Élève:',
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(
                                ' ${childData['nom']} ${childData['prenom']}',
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(
                                'Nom d\'utilisateur:',
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(
                                '${childData['tuteur_nomprenom']}',
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(
                                'École:',
                                style: TextStyle(fontSize: 10),
                              ),
                              Text(
                                '${childData['etablissement_nom']}',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: kDefaultPadding / 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: MediaQuery.of(context).size.height / 10,
                            decoration: BoxDecoration(
                              color: kOtherColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Niveau:',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: kTextBlackColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${childData['niveau_nom']}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: kTextBlackColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: MediaQuery.of(context).size.height / 10,
                            decoration: BoxDecoration(
                              color: kOtherColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Classe:',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: kTextBlackColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${childData['classe_nom']}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: kTextBlackColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                    color: Color(0xFFF4F6F7),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            HomeCard(
                              onPress: () {},
                              icon: 'assets/icons/ask.svg',
                              title: 'Messagerie',
                            ),
                            HomeCard(
                              onPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CourseScreen(
                                      idEtablissement: 1,
                                      idNiveau: 2,
                                      idClasse: 2,
                                    ),
                                  ),
                                );
                              },
                              icon: 'assets/icons/assignment.svg',
                              title: 'Cours et exercice',
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            HomeCard(
                              onPress: () {},
                              icon: 'assets/icons/holiday.svg',
                              title: 'Demande D\'absences',
                            ),
                            HomeCard(
                              onPress: () {
                                Navigator.pushNamed(
                                    context, EmploiDuTempsScreen.routeName,
                                    arguments: {
                                      'idetablissement':
                                          childData['idetablissement']
                                              .toString(),
                                      'idniveau':
                                          childData['idniveau'].toString(),
                                      'idclasse':
                                          childData['idclasse'].toString(),
                                    });
                              },
                              icon: 'assets/icons/timetable.svg',
                              title: 'Emploi du temps',
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            HomeCard(
                              onPress: () {},
                              icon: 'assets/icons/result.svg',
                              title: 'Résultats',
                            ),
                            HomeCard(
                              onPress: () {
                                // Navigator.pushNamed(
                                // context, DateSheetScreen.routeName);
                              },
                              icon: 'assets/icons/datesheet.svg',
                              title: 'Emploi du temps',
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            HomeCard(
                              onPress: () {},
                              icon: 'assets/icons/result.svg',
                              title: 'Résultats',
                            ),
                            HomeCard(
                              onPress: () {
                                // Navigator.pushNamed(
                                // context, DateSheetScreen.routeName);
                              },
                              icon: 'assets/icons/datesheet.svg',
                              title: 'Feuille de date',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    Key? key,
    required this.onPress,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final VoidCallback onPress;
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        width: 40.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              icon,
              height: 40.sp,
              width: 40.sp,
              color: Color(0xFFF4F6F7),
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

void main() {
  runApp(MaterialApp(
    home: ChildDetailScreen(),
  ));
}
