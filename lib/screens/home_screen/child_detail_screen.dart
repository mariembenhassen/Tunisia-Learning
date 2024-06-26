import 'package:flutter/material.dart';
import 'package:flutter_first_project/screens/login_screen/login_screen.dart';
import 'package:flutter_first_project/constante.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// child_detail_screen.dart

class ChildDetailScreen extends StatelessWidget {
  static const routeName = 'ChildDetailScreen';

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

    final dynamic childData = args['child'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Tunisia Learning'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nom d\'utilisateur : ${childData['nom']} ${childData['prenom']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'École : School Name', // Replace with actual school name
              ),
              SizedBox(height: 10),
              Text(
                'Sexe : ${childData['sexe']}',
              ),
              Text(
                'Date de naissance : ${childData['date_naissance']}',
              ),
              Text(
                'Adresse : ${childData['adresse']}',
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
      ),
    );
  }
}
