import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatTeacherPage extends StatefulWidget {
  static const routeName = 'chatTeacherPage';

  @override
  _ChatTeacherPageState createState() => _ChatTeacherPageState();
}

class _ChatTeacherPageState extends State<ChatTeacherPage> {
  late int idSource;
  late int idUser;
  late int selectedParentId;
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
          idSource = args['idSource'] as int? ?? 0;
          idUser = args['idUser'] as int? ?? 0;
          selectedParentId = args['selectedParentId'] as int? ?? 0;
        });
        fetchConversation(idSource);
      }
    });
  }

  void fetchConversation(int idSource) async {
    String url =
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_conversation_Teacher.php';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idSource': idSource}),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          conversation = List<Map<String, dynamic>>.from(jsonData);
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
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/send_to_parent.php';
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
          'selectedParentId': selectedParentId,
          'message': message,
          'idsource': idSource
        }),
      );

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData['success'] != null) {
          setState(() {
            conversation.add({
              'nomprenom': 'Moi',
              'mail': message,
              'dateheure': DateTime.now().toString(),
              'idsource': idSource
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

  // Function to convert 'Moi' to 'You'
  String convertMoiToYou(String senderName) {
    if (senderName == 'Moi') {
      return 'You';
    }
    return senderName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF345FB4),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 231, 233, 237),
              const Color.fromARGB(255, 245, 246, 246)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: conversation.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: conversation.length,
                      itemBuilder: (context, index) {
                        final message = conversation[index];
                        bool isMe = message['nomprenom'] == 'Moi';
                        String senderName = convertMoiToYou(
                            isMe ? 'Moi' : '${message['nomprenom'] ?? ''}');
                        Color? bubbleColor =
                            isMe ? Color(0xFF6789CA) : Colors.grey[200];
                        Color textColor = isMe ? Colors.white : Colors.black87;
                        Alignment alignment =
                            isMe ? Alignment.centerRight : Alignment.centerLeft;

                        return Align(
                          alignment: alignment,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            padding: EdgeInsets.all(15.0),
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
                                  color: Colors.black12,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: isMe
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  senderName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  message['mail'] ?? '',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  message['dateheure'] ?? '',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey[400],
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
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 14),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Color(0xFF345FB4),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
