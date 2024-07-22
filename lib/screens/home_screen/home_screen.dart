import 'dart:ui';
import 'package:flutter_first_project/components/side_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_first_project/components/side_menu.dart';
import 'package:flutter_first_project/constante.dart';
import 'package:flutter_first_project/screens/Messagerie_screen/Parent_Messagerie_screen.dart';
import 'package:flutter_first_project/screens/Messagerie_screen/Teacher_Messagerie_screen.dart';
import 'package:flutter_first_project/screens/login_screen/login_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:sizer/sizer.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<TeacherDetails?> _teacherDetailsFuture;
  //
  late String id = ''; // Initialize id, nom, prenom
  late String nom = '';
  late String prenom = '';
  //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    id = args['id'] ?? '';
    nom = args['nom'] ?? '';
    prenom = args['prenom'] ?? '';

    _teacherDetailsFuture = fetchTeacherDetails(id);
  }

  Future<TeacherDetails?> fetchTeacherDetails(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_teacher_detail.php?id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final teacherDetails =
            TeacherDetails.fromJson(jsonDecode(response.body));
        return teacherDetails;
      } else {
        throw Exception('Failed to load teacher details');
      }
    } catch (e) {
      print('Error fetching teacher details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<TeacherDetails?>(
        future: _teacherDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            return buildContent(snapshot.data!);
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }

  Widget buildContent(TeacherDetails teacherDetails) {
    return Scaffold(
      //the appbar part

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
                      Icon(Icons.logout, color: Colors.redAccent),
                      SizedBox(width: 10),
                      Text(
                        'Déconnexion',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              color: Colors.white,
              elevation: 8,
            ),
          ),
        ],
      ),

      drawer: SideMenu(id: id, nom: nom, prenom: prenom),
      body: Column(
        children: [
          // We will divide the screen into two parts
          // Fixed height for first half
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
            // padding: EdgeInsets.all(20.0),
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
                        Text('${teacherDetails.nom} ${teacherDetails.prenom}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                )),

                        Text(
                          'Nom d\'établissement :',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 12.0,
                                  ),
                        ),
                        Text('${teacherDetails.etablissement}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                )),

                        Text(
                          'Année scolaire en cours:',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontSize: 12.0,
                                  ),
                        ),

                        Text('${teacherDetails.anneeScolaireEnCours}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                )),
                      ],
                    ),
                    SizedBox(width: 25.0),
                    CircleAvatar(
                      radius: SizerUtil.deviceType == DeviceType.tablet
                          ? 12.w
                          : 13.w,
                      backgroundColor: Color.fromARGB(255, 204, 238, 230),
                      backgroundImage:
                          AssetImage('assets/images/teacher_profil.png'),
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
                color: Color(0xFFF4F6F7),
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
                          onPress: () {
                            Navigator.pushNamed(
                                context, TeacherMessagingPage.routeName,
                                arguments: {
                                  'iduser': int.parse(teacherDetails.id
                                      .toString()), // Ensure it's an integer
                                  'idetablissement': int.parse(teacherDetails
                                      .idEtablissement
                                      .toString()), // Ensure it's an integer
                                });
                          },
                          icon: 'assets/icons/ask.svg',
                          title: 'Messagerie',
                        ),
                        HomeCard(
                          onPress: () {
                            //go to assignment screen here
                            //Navigator.pushNamed(
                            //context, AssignmentScreen.routeName);
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
                          onPress: () {},
                          icon: 'assets/icons/timetable.svg',
                          title: 'Demande De Rattrapage',
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
          borderRadius: BorderRadius.circular(20.0 / 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              height: SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40.sp,
              width: SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40.sp,
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
        color: Color(0xFFF4F6F7),
        borderRadius: BorderRadius.circular(20.0),
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

class TeacherDetails {
  final String id;
  final String nom;
  final String prenom;
  final String dateNaissance;
  final String lieuNaissance;
  final String adresse;
  final String telephone;
  final String sexe;
  final String email;
  final String idEtablissement;
  final String etablissement;
  final String anneeScolaireEnCours;

  TeacherDetails({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.dateNaissance,
    required this.lieuNaissance,
    required this.adresse,
    required this.telephone,
    required this.sexe,
    required this.email,
    required this.idEtablissement,
    required this.etablissement,
    required this.anneeScolaireEnCours,
  });

  factory TeacherDetails.fromJson(Map<String, dynamic> json) {
    return TeacherDetails(
      id: json['data']['id'] ?? '',
      nom: json['data']['nom'] ?? '',
      prenom: json['data']['prenom'] ?? '',
      dateNaissance: json['data']['date_naissance'] ?? '',
      lieuNaissance: json['data']['lieu_naissance'] ?? '',
      adresse: json['data']['adresse'] ?? '',
      telephone: json['data']['telephone'] ?? '',
      sexe: json['data']['sexe'] ?? '',
      email: json['data']['email'] ?? '',
      idEtablissement: json['data']['idetablissement'] ?? '',
      etablissement: json['data']['etablissement'] ?? '',
      anneeScolaireEnCours: json['data']['annee_scolaire_en_cours'] ?? '',
    );
  }
}
