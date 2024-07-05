import 'package:flutter/material.dart';
import 'package:flutter_first_project/screens/data/course_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseScreen extends StatefulWidget {
  final int idEtablissement;
  final int idNiveau;
  final int idClasse;

  CourseScreen({
    required this.idEtablissement,
    required this.idNiveau,
    required this.idClasse,
  });

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  late Future<List<Course>> futureCourses;

  @override
  void initState() {
    super.initState();
    futureCourses = fetchCourses(
      widget.idEtablissement,
      widget.idNiveau,
      widget.idClasse,
    );
  }

  Future<List<Course>> fetchCourses(
      int idEtablissement, int idNiveau, int idClasse) async {
    final url =
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_exercours.php?idetablissement=2&idniveau=1&idclasse=2';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes).trim();
      List<dynamic> jsonResponse = json.decode(responseBody);
      return jsonResponse.map((course) => Course.fromJson(course)).toList();
    } else {
      throw Exception('Failed to load courses: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Courses'),
      ),
      body: Center(
        child: FutureBuilder<List<Course>>(
          future: futureCourses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text("No courses available."),
              );
            } else {
              List<Course> courses = snapshot.data!;
              return ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  Course course = courses[index];
                  return ListTile(
                    title: Text('Course ID: ${course.idCours}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Teacher: ${course.enseignant}'),
                        Text('Subject: ${course.matiere}'),
                        Text('Type: ${course.type}'),
                        Text('Date: ${course.date}'),
                        Text('Documents:'),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: course.documents
                              .map((doc) =>
                                  Text('${doc.titre}: ${doc.document}'))
                              .toList(),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
