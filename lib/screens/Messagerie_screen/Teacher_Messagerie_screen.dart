import 'package:flutter/material.dart';
import 'package:flutter_first_project/screens/Messagerie_screen/Teacher_messages/ChatPage.dart';
import 'package:flutter_first_project/screens/Messagerie_screen/Teacher_messages/send_to_parent.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_first_project/screens/Messagerie_screen/Teacher_messages/ChatPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_nav_bar/google_nav_bar.dart';

class TeacherMessagingPage extends StatefulWidget {
  static const String routeName = '/teacher-messaging';

  @override
  _TeacherMessagingPageState createState() => _TeacherMessagingPageState();
}

class _TeacherMessagingPageState extends State<TeacherMessagingPage> {
  List<dynamic> _messages = [];
  bool _isLoading = true;
  String _errorMessage = '';
  late int idUser;
  late int idEtablissement;
  List<dynamic> _parents = [];
  List<dynamic> _students = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      if (arguments != null &&
          arguments['iduser'] != null &&
          arguments['idetablissement'] != null) {
        idUser = arguments['iduser'];
        idEtablissement = arguments['idetablissement'];
        _fetchParents();
        _fetchStudents();
        _fetchMessages();
      } else {
        setState(() {
          _errorMessage = 'Invalid parameters';
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _updateMessageStatus(int messageId, int lu) async {
    final url =
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/update_lu_state.php';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'messageId': messageId,
      'lu': lu,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['status'] == 'success') {
          print('Message status updated successfully.');
        } else {
          print('Failed to update message status: ${responseBody['message']}');
        }
      } else {
        print(
            'Failed to update message status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchParents() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_all_parents.php?idetablissement=$idEtablissement'));
      print('Parents response status: ${response.statusCode}');
      print('Parents response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> parents = json.decode(response.body);
        print('Decoded parents: $parents');

        setState(() {
          _parents = parents;
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to load parents. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  Future<void> _fetchStudents() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_all_students.php?idetablissement=$idEtablissement'));
      print('Students response status: ${response.statusCode}');
      print('Students response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> students = json.decode(response.body);
        print('Decoded students: $students');

        setState(() {
          _students = students;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to load students. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_parents_messages.php?iduser=$idUser&idetablissement=$idEtablissement'));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> messages = json.decode(response.body);
        print('Decoded messages: $messages');

        setState(() {
          _messages = messages;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to load messages. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), // Reduced height
        child: AppBar(
          backgroundColor:
              Color(0xFF345FB4), // Original blue color with gradient effect
          elevation: 0, // No shadow for cleaner look
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 5.0), // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Messages",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0, // Adjusted font size
                        fontWeight: FontWeight.w600, // Slightly lighter weight
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2.0),
                      height: 2.0,
                      width: 50.0, // Thin line for subtle style
                      color: Colors.white.withOpacity(0.7),
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
                  Color(0xFF345FB4),
                  Color.fromARGB(
                      255, 20, 140, 210), // Subtle gradient for depth
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
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage))
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      String messagePreview = message['mail'].length > 50
                          ? '${message['mail'].substring(0, 50)}...'
                          : message['mail'];
                      bool isUnseen = message['lu'] == '1';
                      bool isMoi = message['sender_name'] == 'Moi';

                      return GestureDetector(
                        onTap: () {
                          if (isUnseen && !isMoi) {
                            _updateMessageStatus(int.parse(message['id']), 0);
                          }
                          Navigator.pushNamed(
                            context,
                            ChatTeacherPage.routeName,
                            arguments: {
                              'idSource': int.parse(message['idsource']),
                              'selectedParentId':
                                  int.parse(message['idsender']),
                              'idUser': idUser,
                            },
                          );
                        },
                        child: Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUnseen && !isMoi
                                ? Color(
                                    0xFF6789CA) // Change color for unseen messages
                                : Color(
                                    0xFFF4F6F7), // Change color for seen messages
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: isUnseen && !isMoi
                                    ? Color(
                                        0xFF6789CA) // Shadow color for unseen messages
                                    : Colors
                                        .transparent, // No shadow for seen messages
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
                                      isMoi
                                          ? 'You'
                                          : '${message['sender_name']}',
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
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(221, 49, 49, 49)),
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
                                                  FontAwesomeIcons
                                                      .solidCommentDots,
                                                  color: Colors.blue,
                                                  size: 22,
                                                ),
                                                onPressed: () {
                                                  if (isUnseen && !isMoi) {
                                                    _updateMessageStatus(
                                                        int.parse(
                                                            message['id']),
                                                        0);
                                                  }
                                                  Navigator.pushNamed(
                                                    context,
                                                    ChatTeacherPage.routeName,
                                                    arguments: {
                                                      'idSource': int.parse(
                                                          message['idsource']),
                                                      'selectedParentId':
                                                          int.parse(message[
                                                              'idsender']),
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
            SendToParentPage.routeName,

            // Define your route for sending message
            arguments: {
              'students': _students,
              'parents': _parents,
              'idUser': idUser,
              'idEtablissement': idEtablissement,
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(
            255, 253, 253, 253), // Keeping the same background color
        elevation: 8.0,
        tooltip: 'Send a new message',
      ),
    );
  }
}
