import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_first_project/frontassignmentpage.dart';
import 'package:flutter_first_project/screens/home_screen/home_screen.dart';

class HomeworkTrackingPage extends StatefulWidget {
  static const String routeName = 'HomeworkTrackingPage';

  @override
  _HomeworkTrackingPageState createState() => _HomeworkTrackingPageState();
}

class _HomeworkTrackingPageState extends State<HomeworkTrackingPage> {
  int _selectedIndex = 1; // Default to Homework tab

  List<Map<String, dynamic>> homeworkList = [
    {
      'studentName': 'Aya Massmoudi',
      'subject': 'Mathematics',
      'submissionDate': '2024-09-01',
      'homeworkPreview': 'Solve the equations on page 32...',
      'status': 'Pending',
    },
    {
      'studentName': 'Ahmed Attiya',
      'subject': 'Science',
      'submissionDate': '2024-05-02',
      'homeworkPreview': '..',
      'status': 'Pending',
    },
    {
      'studentName': 'Wejden Kacem',
      'subject': 'Science',
      'submissionDate': '2024-05-03',
      'homeworkPreview': '...',
      'status': 'Pending',
    },
    {
      'studentName': 'Hassan Belhaj',
      'subject': 'English',
      'submissionDate': '2024-09-04',
      'homeworkPreview': ' ...',
      'status': 'Pending',
    },
  ];

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, AssignmentPage.routeName);
        break;
      case 1:
        // Already on HomeworkTrackingPage, so no navigation needed
        break;
      case 2:
        Navigator.pushNamed(context, HomeScreen.routeName);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Received Homework',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF345FB4),
      ),
      body: ListView.builder(
        itemCount: homeworkList.length,
        itemBuilder: (context, index) {
          final homework = homeworkList[index];
          return Card(
            color: Color(0xFF6789CA),
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16),
              title: Text(
                homework['studentName']!,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 173, 205, 235)),
              ),
              subtitle: Text(
                'Subject: ${homework['subject']} \nSubmission Date: ${homework['submissionDate']} \nStatus: ${homework['status']}',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 251, 249, 249),
                ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.download,
                        color: Color.fromARGB(255, 23, 252, 134)),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Downloading ${homework['studentName']}\'s homework.'),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.comment, color: Colors.amber),
                    onPressed: () {
                      _showAddRemarkDialog(context, index);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.star_rate, color: Colors.orange),
                    onPressed: () {
                      _showRateDialog(context, index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, size: 30),
            label: 'Assignments',
            tooltip: 'View Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work, size: 30),
            label: 'Homework',
            tooltip: 'View Homework',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30),
            label: 'Home',
            tooltip: 'Go to Home',
          ),
        ],
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 14),
        unselectedLabelStyle: TextStyle(fontSize: 14),
      ),
    );
  }

  void _showAddRemarkDialog(BuildContext context, int index) {
    final TextEditingController _remarkController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: Text(
            'Add Remark for ${homeworkList[index]['studentName']}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: _remarkController,
              decoration: InputDecoration(
                hintText: 'Enter your remark here',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  homeworkList[index]['status'] = 'Seen';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Remark added for ${homeworkList[index]['studentName']} and status updated to Seen.'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text('Send', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showRateDialog(BuildContext context, int index) {
    final TextEditingController _ratingController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200],
          title: Text(
            'Rate the Homework (out of 20)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _ratingController,
                  decoration: InputDecoration(
                    hintText: 'Enter a rating (0-20)',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  maxLength: 2,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(height: 8),
                Text(
                  'Please enter a rating between 0 and 20.',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red, fontSize: 14),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Assuming you add rating to the list or perform any action needed
                  // homeworkList[index]['rating'] = int.tryParse(_ratingController.text);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Rating added for ${homeworkList[index]['studentName']}'),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text('Submit', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.teal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        );
      },
    );
  }
}
