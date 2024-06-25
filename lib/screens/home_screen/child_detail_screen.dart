import 'package:flutter/material.dart';

class ChildDetailScreen extends StatelessWidget {
  final Map<String, dynamic> child;

  static var routeName;

  ChildDetailScreen({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(child['child_name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${child['child_name']}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Sex: ${child['sexe']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Level: ${child['niveau']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Class: ${child['classe']}', style: TextStyle(fontSize: 18)),
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }
}

/*import 'package:flutter/material.dart';

void main() {
  runApp(ChildDetailScreen());
}

class ChildDetailScreen extends StatelessWidget {
  static String routeName = 'ChildDetailScreen';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tunisia Learning',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tunisia Learning'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // First screen layout
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nom d\'utilisateur : [02301321] MONIA JOUNI',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Nom d\'établissement : Ecole Primaire Ibn Khaldoun'),
                    Text('Année scolaire en cours: 2023/2024'),
                    SizedBox(height: 10),
                    DropdownButton<String>(
                      isExpanded: true,
                      items: <String>[
                        'KALLEL BAYREM',
                        'KALLEL YAHYA',
                        'KALLEL LAMIS'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                      hint: Text('Élève en cours:'),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'Niveau :',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'Classe :',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Voir Plus'),
                    ),
                    SizedBox(height: 10),
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
            // Second screen layout
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    Text(
                      'Nom d\'utilisateur : Parent Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Nom d\'établissement : School'),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StudentButton(name: 'Kallel Yahya'),
                        StudentButton(name: 'Kallel Bayrem'),
                      ],
                    ),
                    SizedBox(height: 20),
                    StudentButton(name: 'Kallel Lamis'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentButton extends StatelessWidget {
  final String name;

  StudentButton({required this.name});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () {},
        child: Text(name),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 20),
          backgroundColor: Colors.blue,
          textStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}



/*import 'package:flutter/material.dart';

class ChildDetailScreen extends StatelessWidget {
  final Map<String, dynamic> child;

  static var routeName;

  ChildDetailScreen({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(child['child_name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${child['child_name']}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Sex: ${child['sexe']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Level: ${child['niveau']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Class: ${child['classe']}', style: TextStyle(fontSize: 18)),
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }
}
*/
*/