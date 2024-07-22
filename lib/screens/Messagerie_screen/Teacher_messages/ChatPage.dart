import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatTeacherPage extends StatefulWidget {
  static const String routeName = '/ChatTeacherPage';

  @override
  _ChatTeacherPageState createState() => _ChatTeacherPageState();
}

class _ChatTeacherPageState extends State<ChatTeacherPage> {
  late int idSource;
  late int selectedTeacherId;
  late int idUser;
  List<dynamic> conversation = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      idSource = arguments['idSource'] ?? 0;
      selectedTeacherId = arguments['selectedTeacherId'] ?? 0;
      idUser = arguments['idUser'] ?? 0;
      fetchConversation();
    } else {
      setState(() {
        errorMessage = 'Invalid parameters';
        isLoading = false;
      });
    }
  }

  Future<void> fetchConversation() async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_conversation_Teacher.php'),
        body: json.encode({'idSource': idSource}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        setState(() {
          conversation = json.decode(response.body) ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load conversation';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Teacher'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  itemCount: conversation.length,
                  itemBuilder: (context, index) {
                    final message = conversation[index];
                    String messageText = message['mail'] ?? 'No message';
                    String senderName = message['nomprenom'] ?? 'Unknown';
                    return ListTile(
                      title: Text(messageText),
                      subtitle: Text('From: $senderName'),
                    );
                  },
                ),
    );
  }
}
