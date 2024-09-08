import 'package:flutter/material.dart';

class HomeworkTrackingPage extends StatelessWidget {
  static const String routeName = 'HomeworkTrackingPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homework Submissions', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 5, // Example count of submissions
          itemBuilder: (context, index) {
            return _buildSubmissionCard(index);
          },
        ),
      ),
    );
  }

  Widget _buildSubmissionCard(int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      color: Colors.white,
      child: ListTile(
        title: Text(
          'Submission ${index + 1}',
          style: TextStyle(color: Colors.green, fontSize: 16),
        ),
        subtitle: Text('Details about this submission',
            style: TextStyle(fontSize: 14)),
        trailing: IconButton(
          icon: Icon(Icons.download, color: Colors.green),
          onPressed: () {
            // Implement file download functionality
          },
        ),
        onTap: () {
          // Navigate to details or perform action
        },
      ),
    );
  }
}
