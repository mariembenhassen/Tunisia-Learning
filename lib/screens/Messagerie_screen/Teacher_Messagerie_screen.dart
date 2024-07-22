import 'package:flutter/material.dart';
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
        _fetchMessages();
      } else {
        setState(() {
          _errorMessage = 'Invalid parameters';
          _isLoading = false;
        });
      }
    });
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
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.blue[800],
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
      body: _isLoading
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

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/chatPage',
                          arguments: {
                            'idSource': int.parse(message['idsource']),
                            'selectedTeacherId': idUser.toString(),
                            'idUser': idUser,
                          },
                        );
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUnseen ? Colors.blue[50] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
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
                                    '${message['sender_name']}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    messagePreview,
                                    style: TextStyle(
                                      color: Colors.black87,
                                    ),
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
                                      isUnseen
                                          ? Icon(
                                              Icons.mark_email_unread,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.done,
                                              color: Colors.blueGrey,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/sendMessagePage', // Replace with your route for the message sending page
            arguments: {
              'id': idUser,
              'idEtablissement': idEtablissement,
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[700],
        elevation: 8.0,
        tooltip: 'Send a new message',
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -1),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: Duration(milliseconds: 400),
              tabBackgroundColor: Colors.blue[700]!,
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
                // Handle tab change actions here
              },
            ),
          ),
        ),
      ),
    );
  }
}
