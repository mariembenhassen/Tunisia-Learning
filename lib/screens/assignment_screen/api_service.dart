/*import 'dart:convert';
import 'package:flutter_first_project/screens/data/course_model.dart';
import 'package:http/http.dart' as http;

Future<List<Course>> fetchCourses(
    int idEtablissement, int idNiveau, int idClasse) async {
  final url =
      'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_exercours.php?idetablissement=$idEtablissement&idniveau=$idNiveau&idclasse=$idClasse';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

    return jsonResponse.map((course) => Course.fromJson(course)).toList();
  } else {
    throw Exception('Failed to load courses: ${response.statusCode}');
  }
}
*/