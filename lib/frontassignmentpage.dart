import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class AssignmentPage extends StatefulWidget {
  static const String routeName = 'AssignmentPage';

  @override
  _AssignmentPageState createState() => _AssignmentPageState();
}

class _AssignmentPageState extends State<AssignmentPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedFile;
  String _assignmentType = 'Assignment'; // Default assignment type
  DateTime? _selectedDeadline; // To store selected deadline

  Future<void> _pickFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDeadline(BuildContext context) async {
    // Customize date picker with theme
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Color(0xFF345FB4), // Header background color
            hintColor: Color(0xFF345FB4), // Color for selected items
            colorScheme: ColorScheme.light(primary: Color(0xFF345FB4)),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Color(0xFF345FB4),
              hintColor: Color(0xFF345FB4),
              timePickerTheme: TimePickerThemeData(
                dialHandColor: Color(0xFF345FB4),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDeadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFile == null || _selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a file and set a deadline'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final uri = Uri.parse(
          'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/upload_assignment.php'); // Replace with your server URL

      // Convert deadline to string format (yyyy-MM-dd HH:mm:ss)
      String deadlineString = _selectedDeadline!.toIso8601String();

      final request = http.MultipartRequest('POST', uri)
        ..fields['subject'] = _subjectController.text
        ..fields['class'] = _classController.text
        ..fields['level'] = _levelController.text
        ..fields['notes'] = _notesController.text
        ..fields['assignment_type'] = _assignmentType
        ..fields['deadline'] = deadlineString
        ..files.add(
            await http.MultipartFile.fromPath('file', _selectedFile!.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File uploaded successfully!'),
            backgroundColor: Color(0xFF345FB4),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload file'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error uploading file: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignments', style: TextStyle(fontSize: 18)),
        backgroundColor: Color(0xFF345FB4),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create New Assignment',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF345FB4),
                    fontSize: 20),
              ),
              SizedBox(height: 12),
              _buildTextField(_subjectController, 'Subject'),
              SizedBox(height: 12),
              _buildTextField(_classController, 'Class'),
              SizedBox(height: 12),
              _buildTextField(_levelController, 'Level'),
              SizedBox(height: 12),
              _buildDropdown(),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity, // Make button full width
                child: ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF345FB4),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Upload File',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 12),
              _selectedFile != null
                  ? Text(
                      'Selected File: ${_selectedFile!.path}',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )
                  : Text(
                      'No File Selected',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity, // Make button full width
                child: ElevatedButton(
                  onPressed: () => _pickDeadline(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF345FB4),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Set Deadline',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 12),
              _selectedDeadline != null
                  ? Text(
                      'Selected Deadline: ${_selectedDeadline!.toLocal().toString()}',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    )
                  : Text(
                      'No Deadline Selected',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
              SizedBox(height: 12),
              _buildTextField(_notesController, 'Notes', maxLines: 3),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity, // Make button full width
                child: ElevatedButton(
                  onPressed: _uploadFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF345FB4),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Send Assignment',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFF345FB4), fontSize: 14),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      ),
      maxLines: maxLines,
      style: TextStyle(fontSize: 14, color: Colors.black), // Black text
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _assignmentType,
      decoration: InputDecoration(
        labelText: 'Assignment Type',
        labelStyle: TextStyle(color: Color(0xFF345FB4), fontSize: 14),
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      ),
      items: <String>['Assignment', 'Homework', 'Project'].map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _assignmentType = value!;
        });
      },
    );
  }
}
