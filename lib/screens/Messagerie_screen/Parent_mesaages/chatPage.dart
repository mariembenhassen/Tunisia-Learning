import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  static const routeName = '/chatPage';

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late int idSource;
  late int idUser;
  late int selectedTeacherId;
  List<Map<String, dynamic>> conversation = [];
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (args != null) {
        setState(() {
          idSource = args['idSource'] as int? ?? 0; // Provide a default value
          idUser = args['idUser'] as int? ?? 0; // Provide a default value
          selectedTeacherId =
              args['selectedTeacherId'] as int? ?? 0; // Provide a default value
        });
        fetchConversation(idSource);
      }
    });
  }

  void fetchConversation(int idSource) async {
    String url =
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_conversation.php';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idSource': idSource}),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        List<Map<String, dynamic>> tempConversation =
            List<Map<String, dynamic>>.from(jsonData);

        // Sort the conversation list based on dateheure
        tempConversation.sort((a, b) {
          DateTime dateA = DateTime.parse(a['dateheure']);
          DateTime dateB = DateTime.parse(b['dateheure']);
          return dateA.compareTo(dateB);
        });

        setState(() {
          conversation = tempConversation;
        });
      } else {
        print('Failed to load conversation');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void sendMessage() async {
    String url =
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/send_to_teacher.php';
    String message = messageController.text;

    if (message.isEmpty) {
      return;
    }

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'idUser': idUser,
          'selectedTeacherId': selectedTeacherId,
          'message': message,
          'idsource': idSource
        }),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['success'] != null) {
          setState(() {
            conversation.add({
              'nom': 'Moi',
              'mail': message,
              'dateheure': DateTime.now().toString()
            });
            messageController.clear();
          });
        } else {
          print('Failed to send message');
        }
      } else {
        print('Failed to send message');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light grey background color
      appBar: AppBar(
        title: Text('Chat with Teacher', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF345FB4),
      ),
      body: conversation.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: conversation.length,
                    itemBuilder: (context, index) {
                      final message = conversation[index];
                      bool isMe = message['nom'] == 'Moi';
                      String senderName = isMe
                          ? 'You'
                          : '${message['nom'] ?? ''} ${message['prenom'] ?? ''}';
                      Color bubbleColor =
                          isMe ? Color(0xFF007AFF) : Colors.white;
                      Color textColor = isMe ? Colors.white : Colors.black87;
                      Alignment alignment =
                          isMe ? Alignment.centerRight : Alignment.centerLeft;

                      return Align(
                        alignment: alignment,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: bubbleColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                              bottomLeft: isMe
                                  ? Radius.circular(16.0)
                                  : Radius.circular(0),
                              bottomRight: isMe
                                  ? Radius.circular(0)
                                  : Radius.circular(16.0),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                senderName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  fontSize: 14.0,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                message['mail'] ?? '',
                                style:
                                    TextStyle(color: textColor, fontSize: 16.0),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                message['dateheure'] ?? '',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(
                      12.0), // Increased padding for better spacing
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageController,
                          style: TextStyle(color: Colors.black87),
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            hintStyle: TextStyle(
                                color: Colors.grey[600]), // Subtle hint color
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  25.0), // Slightly larger radius
                              borderSide:
                                  BorderSide.none, // Remove default border
                            ),
                            filled: true,
                            fillColor: Colors.white, // Clean white background
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical:
                                  12.0, // Increased vertical padding for a better typing experience
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide(
                                  color: Color(0xFF007AFF),
                                  width: 1.5), // Focus border color
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          width:
                              10.0), // Increased spacing between the text field and the button
                      CircleAvatar(
                        backgroundColor: Colors.white, // Prominent button color
                        radius:
                            25.0, // Slightly larger radius for better touch target
                        child: IconButton(
                          icon: Icon(Icons.send,
                              color: Color.fromARGB(255, 36, 44, 153)),
                          onPressed: sendMessage,
                          iconSize: 20.0, // Adjusted icon size
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
