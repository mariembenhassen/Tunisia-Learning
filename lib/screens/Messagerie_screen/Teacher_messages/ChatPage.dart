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
  late String selectedTeacherId;
  late int idUser;
  List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    // Retrieve the arguments from the route
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    if (arguments != null) {
      idSource = arguments['idSource'];
      selectedTeacherId = arguments['selectedTeacherId'];
      idUser = arguments['idUser'];
      fetchMessages();
    }
  }

  Future<void> fetchMessages() async {
    final url =
        'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_conversation_Teacher.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'idSource': idSource,
        }),
      );

      if (response.statusCode == 200) {
        // Print the raw response body
        print('Raw response body: ${response.body}');

        // Check if response contains HTML (simple check)
        if (response.body.contains('<html>') ||
            response.body.contains('<br />')) {
          throw Exception('Unexpected HTML content received');
        }

        // Preprocess the response body
        String cleanedResponse = _cleanResponse(response.body);

        // Check if cleanedResponse is valid JSON
        List<dynamic> data;
        try {
          data = jsonDecode(cleanedResponse);
        } catch (e) {
          print('Failed to decode JSON: $e');
          data = []; // Initialize as empty list on error
        }

        setState(() {
          messages = data.map((message) {
            return {
              'mail': (String html) {
                final decoded = html
                    .replaceAll(RegExp(r'<br\s*/?>'),
                        '\n') // Replace <br /> with new lines
                    .replaceAll(RegExp(r'<[^>]*>'),
                        '') // Remove any remaining HTML tags
                    .replaceAll(RegExp(r'\s+'),
                        ' ') // Replace multiple spaces with a single space
                    .trim(); // Trim leading and trailing spaces
                return decoded;
              }(message['mail']),
              'idetablissement': message['idetablissement'],
              'idutilisateur':
                  int.tryParse(message['idutilisateur'].toString()) ?? 0,
              'id': int.tryParse(message['id'].toString()) ?? 0,
              'expediteur': int.tryParse(message['expediteur'].toString()) ?? 0,
              'nomprenom': message['nomprenom'],
            };
          }).toList();
        });
      } else {
        print('Failed to load messages. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  String _cleanResponse(String responseBody) {
    // Remove HTML tags
    responseBody = responseBody.replaceAll(RegExp(r'<[^>]*>'), '');
    // Remove or replace any unexpected characters
    responseBody = responseBody.replaceAll(RegExp(r'[^\w\s,.!?-]'), '');
    responseBody = responseBody.replaceAll(RegExp(r'\s+'), ' ');
    responseBody = responseBody.trim();

    // Ensure valid JSON format, handle specific cases if necessary
    return responseBody;
  }

  String _decodeHtmlEntities(String text) {
    // Decode HTML entities
    return text
        .replaceAll('&lt;br /&gt;', '\n')
        .replaceAll('&lt;b&gt;', '')
        .replaceAll('&lt;/b&gt;', '')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&amp;', '&');
  }

  // Helper function to decode HTML entities and remove unwanted tags

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Teacher'),
      ),
      body: messages.isEmpty
          ? Center(child: Text('No messages available'))
          : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message['nomprenom'] ?? 'Unknown'),
                  subtitle: Text(message['mail'] ?? ''),
                  onTap: () {
                    // Handle message tap if needed
                    print('Tapped on message: ${message['id']}');
                  },
                );
              },
            ),
    );
  }
}
