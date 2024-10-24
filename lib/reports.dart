import 'package:flutter/material.dart';

class ReportIssuePage extends StatefulWidget {
  @override
  _ReportIssuePageState createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final TextEditingController _issueController = TextEditingController();
  String? _selectedIssueType;

  final List<String> _issueTypes = [
    'Technical Issue',
    'Account Problem',
    'School Issue',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Report',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 130, 47, 57),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 13, 96, 156)!,
              Color.fromARGB(255, 188, 121, 165)!
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report Your Issue',
                      style: TextStyle(
                        fontSize: 24, // Increased font size for title
                        fontWeight: FontWeight.bold,
                        color: Colors
                            .blueGrey[900], // Darker color for better contrast
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedIssueType,
                      items: _issueTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(
                            type,
                            style: TextStyle(
                                color: Colors.blueGrey[800],
                                fontSize: 15 // Changed text color
                                ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedIssueType = value;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Select Issue Type',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      hint: Text(
                        'Choose an issue type',
                        style: TextStyle(
                            color: Colors.blueGrey[600],
                            fontSize: 20 // Changed hint color
                            ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _issueController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Describe the issue...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      style: TextStyle(
                        color: Colors.blueGrey[800], // Changed text color
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedIssueType != null &&
                              _issueController.text.isNotEmpty) {
                            // Simulate submission of the report
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Report submitted successfully!'),
                                backgroundColor:
                                    Colors.green[600], // Changed Snackbar color
                              ),
                            );
                            _issueController.clear();
                            setState(() {
                              _selectedIssueType =
                                  null; // Reset the selected issue type
                            });
                          } else {
                            // Show an error message if fields are empty
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please select an issue type and describe the issue.',
                                ),
                                backgroundColor:
                                    Colors.red[600], // Changed Snackbar color
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(
                              255, 123, 9, 102), // Changed button color
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          textStyle:
                              TextStyle(fontSize: 16), // Adjusted font size
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Submit Report',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
