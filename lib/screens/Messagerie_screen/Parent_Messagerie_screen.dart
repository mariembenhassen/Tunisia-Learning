import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:flutter_first_project/screens/Messagerie_screen/Parent_mesaages/chatPage.dart';
import 'package:flutter_first_project/screens/home_screen/child_detail_screen.dart';
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
  // List<Map<String, dynamic>> teacherNames = [];
  // List<Map<String, dynamic>> filteredTeacherNames = [];
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

        // Check if jsonData is List<dynamic>
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
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_teacher_messages.php?iduser=2059&idetablissement=1';

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

/*
  void openBottomSheet(Map<String, dynamic> message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 300.0, // Adjust the height as needed
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "From: ${message['sender_name']}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            Text(
                              "Date: ${message['dateheure']}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Message:",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    message['mail'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }*/
  /*
void openChatScreen(Map<String, dynamic> message) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ChatScreen(
        selectedTeacherId: message['idsender'] as int,
        senderName: message['sender_name'],
        idEtablissement: idEtablissement,
        idUser:idUser,
      ),
    ),
  );
}*/

 void openChatScreen(Map<String, dynamic> message) {
    int senderId = int.tryParse(message['idsender'].toString()) ?? 0;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          selectedTeacherId: senderId,
          senderName: message['sender_name'],
          idEtablissement: idEtablissement,
          idUser: idUser,
        ),
      ),
    );
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
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.blue[600],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Messages",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      
      body: messages.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                String messagePreview = message['mail'].length > 50
                    ? '${message['mail'].substring(0, 50)}...'
                    : message['mail'];
                bool isUnseen = message['lu'] == '1';

                return GestureDetector(
                  onTap: () {
                    // Handle tap action here, navigate to chat page or show details
                    openChatScreen(message); // Example of opening bottom sheet
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUnseen ? Colors.grey[200] : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         
                          '${message['sender_name']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          messagePreview,
                          style: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${message['dateheure']}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            isUnseen
                                ? Icon(
                                    Icons.mark_email_unread,
                                    color: Color.fromARGB(255, 236, 186, 182),
                                  )
                                : Icon(
                                    Icons.done,
                                    color: Colors.grey,
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/sendMessagePage', // Replace with your route for the message sending page
            arguments: {
              'childrenNames': childrenNames,
              'filteredTeachers': filteredTeacherNames,
              'id': idUser,
              'idEtablissement': idEtablissement,
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[600],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.blue[600]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: Icons.message,
                  text: 'Messages',
                ),
                GButton(
                  icon: Icons.list_alt,
                  text: 'Sélectionner',
                ),
                GButton(
                  icon: Icons.library_add,
                  text: 'Envoyer',
                ),
              ],
              selectedIndex: 0,
              onTabChange: (index) {
                if (index == 1) {}
                if (index == 2) {}
              },
            ),
          ),
        ),
      ),
    );
  }
}
