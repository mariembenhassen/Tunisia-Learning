import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AbscenceScreen extends StatefulWidget {
  static String routeName = 'AbscenceScreen';

  @override
  _AbscenceScreenState createState() => _AbscenceScreenState();
}

class _AbscenceScreenState extends State<AbscenceScreen> {
  int? idUser;
  int? idEtablissement;
  final TextEditingController _observationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // Retrieve arguments from the navigator
      final Map<String, dynamic> args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      idUser = args['iduser'];
      idEtablissement = args['idetablissement'];
    });
  }

  Future<void> _sendAbsenceRequest() async {
    final String url =
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/send_abscence.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'idenseignant': idUser,
          'observation': _observationController.text,
          'idetablissement': idEtablissement,
          'date': _dateController.text,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Demande d\'absence envoyée avec succès !'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Échec de l\'envoi de la demande : ${responseData['message']}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('La demande a échoué avec le statut: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(' Une erreur s\'est produite: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Demande d\'Absence',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.blue[800],
      ),
      backgroundColor: Colors.grey[100], // Light grey background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'J\'espère que vous allez bien!',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.blueGrey[800],
                  ),
            ),
            SizedBox(height: 20),
            Text(
              'Merci de compléter les informations suivantes pour soumettre votre demande d\'absence.',
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    color: Colors.blueGrey[800],
                  ),
            ),
            SizedBox(height: 20),
            Text(
              'Observation:',
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _observationController,
              maxLines: 4,
              style: TextStyle(color: Colors.black), // Set text color to black
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Entrez votre observation ici',
                hintStyle:
                    TextStyle(color: Colors.grey[600]), // Light grey hint text
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Date:',
              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _dateController,
              style: TextStyle(color: Colors.black), // Set text color to black
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Entrez la date (YYYY-MM-DD)',
                hintStyle: TextStyle(color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _sendAbsenceRequest,
                child: Text(
                  'Envoyer',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800], // Button color
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}