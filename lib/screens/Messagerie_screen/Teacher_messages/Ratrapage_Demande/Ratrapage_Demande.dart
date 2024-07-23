import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RatrapageScreen extends StatefulWidget {
  static String routeName = 'RatrapageScreen';

  @override
  _RatrapageScreenState createState() => _RatrapageScreenState();
}

class _RatrapageScreenState extends State<RatrapageScreen> {
  int? idUser;
  int? idEtablissement;
  int? selectedMatiere;
  int? selectedNiveau;
  int? selectedClasse;

  Future<List<dynamic>> fetchMatieres() async {
    final response = await http.get(Uri.parse(
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_all_matiére.php'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return data['data'];
      }
    }
    return [];
  }

  Future<List<dynamic>> fetchNiveaux(int idEtablissement) async {
    final response = await http.post(
      Uri.parse(
          'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_all_niveaux.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idetablissement': idEtablissement}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return data['data'];
      }
    }
    return [];
  }

  Future<List<dynamic>> fetchClasses(int idNiveau, int idEtablissement) async {
    final response = await http.post(
      Uri.parse(
          'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_all_classes.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'idniveau': idNiveau, 'idetablissement': idEtablissement}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return data['data'];
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve arguments from the navigator
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    idUser = args['iduser'];
    idEtablissement = args['idetablissement'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Demande de Rattrapage'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID Utilisateur: $idUser'),
              Text('ID Etablissement: $idEtablissement'),
              SizedBox(height: 20),
              FutureBuilder<List<dynamic>>(
                future: fetchMatieres(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data available');
                  }

                  final matieres = snapshot.data!;

                  return DropdownButton<int>(
                    value: selectedMatiere,
                    hint: Text('Select Matière'),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedMatiere = newValue;
                        fetchNiveaux(idEtablissement!).then((niveaux) {
                          setState(() {
                            // Update niveaux list
                          });
                        });
                      });
                    },
                    items: matieres.map((matiere) {
                      return DropdownMenuItem<int>(
                        value: int.tryParse(
                            matiere['id'].toString()), // Convert String to int
                        child: Text(matiere['matiere']),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 20),
              FutureBuilder<List<dynamic>>(
                future: selectedMatiere != null && idEtablissement != null
                    ? fetchNiveaux(idEtablissement!)
                    : Future.value([]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data available');
                  }

                  final niveaux = snapshot.data!;

                  return DropdownButton<int>(
                    value: selectedNiveau,
                    hint: Text('Select Niveau'),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedNiveau = newValue;
                        fetchClasses(selectedNiveau!, idEtablissement!)
                            .then((classes) {
                          setState(() {
                            // Update classes list
                          });
                        });
                      });
                    },
                    items: niveaux.map((niveau) {
                      return DropdownMenuItem<int>(
                        value: int.tryParse(
                            niveau['id'].toString()), // Convert String to int
                        child: Text(niveau['niveau']),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 20),
              FutureBuilder<List<dynamic>>(
                future: selectedNiveau != null && idEtablissement != null
                    ? fetchClasses(selectedNiveau!, idEtablissement!)
                    : Future.value([]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No data available');
                  }

                  final classes = snapshot.data!;

                  return DropdownButton<int>(
                    value: selectedClasse,
                    hint: Text('Select Classe'),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedClasse = newValue;
                      });
                    },
                    items: classes.map((classe) {
                      return DropdownMenuItem<int>(
                        value: int.tryParse(
                            classe['id'].toString()), // Convert String to int
                        child: Text(classe['classe']),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
