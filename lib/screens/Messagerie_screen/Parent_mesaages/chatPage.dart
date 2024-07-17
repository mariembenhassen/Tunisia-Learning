import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String senderName;
  final int idEtablissement;
  final int selectedTeacherId;
  final int idUser;

  const ChatScreen({
    Key? key,
    required this.senderName,
    required this.idEtablissement,
    required this.selectedTeacherId,
    required this.idUser,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> chatHistory = [];

  @override
  void initState() {
    super.initState();
    fetchChatHistory();
  }

  void fetchChatHistory() async {
    String url =
        //'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_teacher_messages.php?iduser=${widget.idUser}&idetablissement=${widget.idEtablissement}';
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_teacher_messages.php?iduser=2059&idetablissement=1';
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          chatHistory = List<Map<String, dynamic>>.from(jsonData);
        });
      } else {
        print('Failed to load chat history');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<bool> sendMessage(
      int idUser, int selectedTeacherId, String message) async {
    final url = Uri.parse(
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/send_to_teacher.php');
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({
      "idUser": idUser,
      "selectedTeacherId": selectedTeacherId,
      "message": message,
    });

    try {
      var response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Message sent successfully');
        fetchChatHistory(); // Fetch updated chat history after sending message
        return true;
      } else {
        print('Failed to send message: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.senderName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: chatHistory.length,
              itemBuilder: (context, index) {
                final message = chatHistory[index];
                bool isSender = message['senderId'] == widget.selectedTeacherId;

                // Safely access and handle nullable values
                String messageText = message['message'] ?? '';
                String sentTime = message['timestamp'] ?? '';

                return Container(
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isSender ? Colors.blue[200] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        messageText,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Sent $sentTime',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),

            
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String message = messageController.text.trim();
                    if (message.isNotEmpty) {
                      sendMessage(
                          widget.idUser, widget.selectedTeacherId, message);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

