import 'package:http_parser/http_parser.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/constante.dart';
import 'package:flutter_first_project/screens/data/course_model.dart';
import 'package:flutter_first_project/screens/login_screen/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

String getContentType(String? extension) {
  switch (extension) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'pdf':
      return 'application/pdf';
    case 'docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    default:
      return 'application/octet-stream';
  }
}

class CourseScreen extends StatefulWidget {
  static const routeName = 'CourseScreen';
  final int idEtablissement;
  final int idNiveau;
  final int idClasse;
  final int idEleve;

  CourseScreen({
    required this.idEtablissement,
    required this.idNiveau,
    required this.idClasse,
    required this.idEleve,
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
    final baseUrl =
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_exercours.php?idetablissement=$idEtablissement&idniveau=$idNiveau&idclasse=$idClasse';

    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes).trim();
      List<dynamic> jsonResponse = json.decode(responseBody);
      return jsonResponse.map((course) => Course.fromJson(course)).toList();
    } else {
      throw Exception('Failed to load courses: ${response.statusCode}');
    }
  }

  // Function to launch URL
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Color getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'قراءة وفهم':
        return Color.fromARGB(255, 225, 82, 206);
      case 'الرياضيات':
        return Colors.orange;
      case 'التاريخ':
        return Colors.blue;
      case 'anglais':
        return Colors.purple;
      case 'production écrite':
        return Color.fromARGB(255, 67, 4, 139);
      case 'lecture et compréhension':
        return Color.fromARGB(255, 237, 229, 4);
      case 'قواعد لغة':
        return Color.fromARGB(255, 182, 4, 43);
      default:
        return Color.fromARGB(255, 1, 84, 33);
    }
  }

  // Function to show success message
  void _showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.sentiment_very_satisfied, color: Colors.white),
            SizedBox(width: 8),
            Text('Bravo !', style: TextStyle(color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4), // Increase duration
      ),
    );
  }

  String getContentType(String? extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      // Add other cases as needed
      default:
        return 'application/octet-stream';
    }
  }

  Future<void> _pickFile(int idcours) async {
    try {
      final result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;

        if (file.bytes != null) {
          final uri = Uri.parse(
              'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/upload_response.php');

          final request = http.MultipartRequest('POST', uri)
            ..fields['idcours'] = idcours.toString() // Replace with actual data
            ..fields['idetablissement'] =
                widget.idEtablissement.toString() // Replace with actual data
            ..fields['ideleve'] =
                widget.idEleve.toString() // Replace with actual data
            ..files.add(
              http.MultipartFile.fromBytes(
                'file',
                file.bytes!,
                filename: file.name,
                contentType: file.extension != null
                    ? MediaType.parse(getContentType(file.extension))
                    : MediaType.parse('application/octet-stream'),
              ),
            );

          final response = await request.send();

          if (response.statusCode == 200) {
            final responseBody = await response.stream.bytesToString();
            final result = json.decode(responseBody);

            if (result['status'] == 'success') {
              _showSuccessSnackBar();
            } else {
              print('Error: ${result['message']}');
            }
          } else {
            print('Error: ${response.statusCode}');
          }
        } else {
          print('File bytes are null.');
        }
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Lessons and Exercises',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16.5,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
        ),
        backgroundColor: kPrimaryColor,
        actions: [
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
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Padding around the list
        child: FutureBuilder<List<Course>>(
          future: futureCourses,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No courses available."));
            } else {
              List<Course> courses = snapshot.data!;
              return ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  Course course = courses[index];
                  return Card(
                    color: Color.fromARGB(
                        255, 240, 248, 255), // Light background color
                    elevation: 4, // Subtle shadow
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: 8), // Margin between cards
                    child: Padding(
                      padding: EdgeInsets.all(16), // Padding inside the card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.matiere,
                            style: TextStyle(
                              fontSize: 24, // Reduced font size for title
                              fontWeight: FontWeight.bold,
                              color: getSubjectColor(course.matiere),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Teacher: ${course.enseignant}',
                            style: TextStyle(
                              fontSize: 14, // Reduced font size
                              color: Color.fromARGB(255, 50, 50,
                                  50), // Darker text color for contrast
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Type: ${course.type}',
                            style: TextStyle(
                              fontSize: 14, // Reduced font size
                              color: Color.fromARGB(
                                  255, 50, 50, 50), // Darker text color
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Date: 2024/08/25',
                            style: TextStyle(
                              fontSize: 14, // Reduced font size
                              color: Color.fromARGB(
                                  255, 50, 50, 50), // Darker text color
                            ),
                          ),
                          SizedBox(height: 12),
                          Divider(
                            color: Color.fromARGB(
                                255, 200, 200, 200), // Lighter divider color
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Files:',
                            style: TextStyle(
                              fontSize: 16, // Font size for section title
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 30, 30,
                                  30), // Darker color for section title
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Tap on the documents below to download them.',
                            style: TextStyle(
                              fontSize: 14, // Font size for description
                              color: Color.fromARGB(
                                  255, 100, 100, 100), // Subtle text color
                            ),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 12, // Spacing between file items
                            runSpacing: 6,
                            children: course.documents.map((document) {
                              return InkWell(
                                onTap: () {
                                  String fullUrl =
                                      'https://www.ibnkhaldoun.tunisia-learning.com/${document.document}';
                                  _launchURL(fullUrl); // Launch URL on tap
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.file_present,
                                      size: 32, // Size of the file icon
                                      color: getSubjectColor(course.matiere),
                                    ),
                                    SizedBox(
                                        width:
                                            8), // Spacing between icon and text
                                    Text(
                                      document.titre,
                                      style: TextStyle(
                                        color: getSubjectColor(course.matiere),
                                        fontSize:
                                            14, // Font size for file title
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 16),
                          if (course.type.toLowerCase() == 'exercice') ...[
                            Text(
                              'Please submit your assignment:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 30, 30,
                                    30), // Darker color for the prompt
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () => _pickFile(course.idcours),
                              icon: Icon(
                                Icons.upload_file,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Select file(s)',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 70, 130,
                                    180), // Button background color
                                padding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16), // Button padding
                              ),
                            ),
                          ],
                        ],
                      ),
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
