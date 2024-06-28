import 'package:flutter/material.dart';
import 'package:flutter_first_project/components/side_menu.dart';
import 'package:flutter_first_project/screens/login_screen/login_screen.dart';
import 'package:flutter_first_project/constante.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChildDetailScreen extends StatelessWidget {
  static const routeName = 'ChildDetailScreen';

  final String apiUrl =
      'http://localhost/Tunisia_Learning_backend/get_child_detail.php';

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
        ],
      ),
      drawer: SideMenu(),
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'eleve : ${childData['nom']} ${childData['prenom']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nom d\'utilisateur :  ${childData['tuteur_nomprenom']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'École : ${childData['etablissement_nom']}',
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Sexe : ${childData['sexe']}',
                  ),
                  Text(
                    'Date de naissance : ${childData['date_naissance']}',
                  ),
                  Text(
                    'niveau : ${childData['niveau_nom']}',
                  ),
                  Text(
                    'classe : ${childData['classe_nom']}',
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Handle button press for "Voir Plus"
                    },
                    child: Text('Voir Plus'),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text('Vacance scolaire'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
