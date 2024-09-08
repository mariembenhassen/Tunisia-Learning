import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_first_project/screens/Messagerie_screen/Parent_mesaages/chatPage.dart';
import 'package:flutter_first_project/screens/Messagerie_screen/Parent_mesaages/send.dart';
import 'package:flutter_first_project/screens/home_screen/child_detail_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class ParentMessagingPage extends StatefulWidget {
  static const routeName = '/parent_messagerie';

  @override
  _ParentMessagingPageState createState() => _ParentMessagingPageState();
}

class Teacher {
  final String id;
  final String fullName;

  Teacher({required this.id, required this.fullName});
}

class _ParentMessagingPageState extends State<ParentMessagingPage> {
  late int idUser;
  late int idEtablissement;
  String? selectedReceiverType;
  String? selectedTeacher;

  String? selectedChild;
  final List<String> childrenNames = [];
  TextEditingController messageController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<String> receiverTypes = ['Administrator', 'Enseignant'];
  List<Teacher> teacherNames = [];
  List<Teacher> filteredTeacherNames = [];

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null &&
          args['iduser'] != null &&
          args['idetablissement'] != null) {
        idUser = args['iduser'];
        idEtablissement = args['idetablissement'];
        fetchMessages(idUser, idEtablissement);
        fetchChildrenNames(idUser);
        fetchTeacherNames();
      }
    });
  }

  void fetchTeacherNames() async {
    String url =
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_all_teachers.php';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData is List<dynamic>) {
          List<Teacher> teachers = jsonData.map((teacher) {
            return Teacher(
              id: teacher['id'].toString(),
              fullName: teacher['fullName'].trim(),
            );
          }).toList();

          setState(() {
            teacherNames = teachers;
            filteredTeacherNames = teacherNames.toList();
          });
        } else {
          print('Invalid data format received');
        }
      } else {
        print('Failed to load teacher names');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchChildrenNames(int parentId) async {
    String url =
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_childreen_names.php';

    try {
      var response =
          await http.post(Uri.parse(url), body: {'id': parentId.toString()});

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<dynamic> childrenData = jsonData['data'];

        setState(() {
          childrenNames.clear();
          for (var child in childrenData) {
            String fullName = '${child['nom']} ${child['prenom']}';
            childrenNames.add(fullName);
          }
        });
      } else {
        print('Failed to load children names');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void fetchMessages(int idUser, int idEtablissement) async {
    String url =
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_teacher_messages.php?iduser=$idUser&idetablissement=$idEtablissement';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          messages = List<Map<String, dynamic>>.from(jsonData);
        });
      } else {
        print('Failed to load messages');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void updateMessageState(int messageId, int lu) async {
    String url =
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/update_lu_state.php';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'messageId': messageId, 'lu': lu}),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['status'] == 'success') {
          print('Message state updated successfully');
        } else {
          print('Failed to update message state: ${jsonData['message']}');
        }
      } else {
        print('Failed to update message state');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null ||
        args['iduser'] == null ||
        args['idetablissement'] == null ||
        args['idNiveau'] == null ||
        args['idClasse'] == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error: Missing parameters.'),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Reduced height
        child: AppBar(
          backgroundColor: Color(0xFF345FB4), // Keep the original color
          elevation: 0, // Removes the default shadow for a cleaner look
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 5.0), // Reduced padding for a shorter height
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Messages",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0, // Slightly smaller font size
                        fontWeight:
                            FontWeight.w600, // Lighter font weight for elegance
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2.0),
                      height: 2.0,
                      width: 50.0, // Subtle design element below the title
                      color: Colors.white
                          .withOpacity(0.7), // A thin line for modern look
                    ),
                  ],
                ),
              ),
            ],
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 11, 102, 182),
                  Color.fromARGB(
                      255, 20, 140, 210), // Adding a gradient for more depth
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey[200], // Set your desired background color here
        child: messages.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  String messagePreview = message['mail'].length > 50
                      ? '${message['mail'].substring(0, 50)}...'
                      : message['mail'];
                  bool isUnseen = message['lu'] == '1';
                  bool isMoi = message['sender_name'] == 'Moi';

                  return GestureDetector(
                    onTap: () {
                      if (isUnseen && !isMoi) {
                        updateMessageState(int.parse(message['id']), 0);
                      }
                      Navigator.pushNamed(
                        context,
                        ChatPage.routeName,
                        arguments: {
                          'idSource': int.parse(message['idsource']),
                          'selectedTeacherId': int.parse(message['idsender']),
                          'idUser': idUser,
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUnseen && !isMoi
                            ? Color(0xFF6789CA)
                            : Color(0xFFF4F6F7),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF6789CA),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isMoi ? 'You' : '${message['sender_name']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isUnseen && !isMoi
                                        ? Colors.white
                                        : Color.fromARGB(221, 50, 50, 50),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  messagePreview,
                                  style: TextStyle(color: Colors.black87),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${message['dateheure']}',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Tooltip(
                                          message: 'Open chat',
                                          child: IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.solidCommentDots,
                                              color: Colors.blue,
                                              size: 22,
                                            ),
                                            onPressed: () {
                                              if (isUnseen && !isMoi) {
                                                updateMessageState(
                                                    int.parse(message['id']),
                                                    0);
                                              }
                                              Navigator.pushNamed(
                                                context,
                                                ChatPage.routeName,
                                                arguments: {
                                                  'idSource': int.parse(
                                                      message['idsource']),
                                                  'selectedTeacherId':
                                                      int.parse(
                                                          message['idsender']),
                                                  'idUser': idUser,
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          isMoi
                                              ? FontAwesomeIcons.checkDouble
                                              : isUnseen
                                                  ? FontAwesomeIcons.check
                                                  : FontAwesomeIcons
                                                      .checkDouble,
                                          color: isMoi
                                              ? Colors.blue
                                              : isUnseen
                                                  ? Colors.red
                                                  : Colors.green,
                                          size: 22,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/sendMessagePage',
            arguments: {
              'childrenNames': childrenNames,
              'filteredTeachers': filteredTeacherNames,
              'id': idUser,
              'idEtablissement': idEtablissement,
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 242, 244, 247),
        elevation: 8.0,
        tooltip: 'Send a new message',
      ),
    );
  }
}
