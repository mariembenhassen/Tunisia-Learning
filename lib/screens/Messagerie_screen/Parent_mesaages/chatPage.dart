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
  List<Map<String, dynamic>> conversation = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['idSource'] != null) {
        idSource = args['idSource'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation History'),
        backgroundColor: Colors.blue[800],
      ),
      body: conversation.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: conversation.length,
              itemBuilder: (context, index) {
                final message = conversation[index];
                bool isMe = message['nom'] == 'Moi';
                String senderName = isMe
                    ? 'Moi'
                    : '${message['nom'] ?? ''} ${message['prenom'] ?? ''}';
                Color? bubbleColor = isMe ? Colors.blue[100] : Colors.grey[200];
                Color textColor = isMe ? Colors.black : Colors.black87;
                Alignment alignment =
                    isMe ? Alignment.centerRight : Alignment.centerLeft;

                return Align(
                  alignment: alignment,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                        bottomLeft:
                            isMe ? Radius.circular(16.0) : Radius.circular(0),
                        bottomRight:
                            isMe ? Radius.circular(0) : Radius.circular(16.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
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
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          message['mail'] ?? '',
                          style: TextStyle(color: textColor),
                        ),
                        SizedBox(height: 5.0),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
            SizedBox(width: 8.0),
            CircleAvatar(
              backgroundColor: Colors.blue[800],
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: () {
                  // Send message logic
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

