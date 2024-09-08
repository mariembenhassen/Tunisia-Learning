import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  int _selectedIndex = 0; // For bottom navigation

  Future<void> _pickFile() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickDeadline(BuildContext context) async {
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
    // Placeholder for upload functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Success!'),
        backgroundColor: Color.fromARGB(255, 25, 184, 88),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Handle navigation based on selected index
      if (index == 1) {
        Navigator.pushNamed(
            context, 'HomeworkTrackingPage'); // Replace with your route name
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
        title: Text('Assignments',
            style: TextStyle(fontSize: 18, color: Colors.white)),
        backgroundColor: Color(0xFF345FB4),
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              _buildTextField(_subjectController, 'Subject'),
              SizedBox(height: 16),
              _buildTextField(_classController, 'Class'),
              SizedBox(height: 16),
              _buildTextField(_levelController, 'Level'),
              SizedBox(height: 16),
              _buildDropdown(),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconButton(Icons.upload_file, 'Upload File', _pickFile),
                  _buildIconButton(Icons.calendar_today, 'Set Deadline',
                      () => _pickDeadline(context)),
                ],
              ),
              SizedBox(height: 16),
              _selectedFile == null
                  ? Text(
                      'No file selected',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    )
                  : Text(
                      'Selected File: ${_selectedFile!.path.split('/').last}',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
              SizedBox(height: 16),
              _selectedDeadline != null
                  ? Text('Selected Deadline: ${_selectedDeadline.toString()}',
                      style: TextStyle(fontSize: 16, color: Colors.green))
                  : Text('No Deadline Selected',
                      style: TextStyle(fontSize: 16, color: Colors.red)),
              SizedBox(height: 16),
              _buildTextField(_notesController, 'Notes',
                  maxLines: 5), // Increased max lines
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _uploadFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF345FB4),
                  padding: EdgeInsets.symmetric(
                      vertical: 16), // Increased vertical padding
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12)), // Rounded corners
                  minimumSize: Size(double.infinity, 50), // Full width button
                ),
                child: Text('Send Assignment',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18)), // Increased font size
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, size: 30), // Increased size
            label: 'Assignments',
            tooltip: 'View Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_work, size: 30), // Increased size
            label: 'Homework',
            tooltip: 'View Homework',
          ),
        ],
        showUnselectedLabels: true,
        selectedLabelStyle:
            TextStyle(fontSize: 14), // Increased size of selected label
        unselectedLabelStyle:
            TextStyle(fontSize: 14), // Increased size of unselected label
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
            color: Color(0xFF345FB4), fontSize: 16), // Increased font size
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
            vertical: 16, horizontal: 12), // Increased padding
      ),
      maxLines: maxLines,
      style:
          TextStyle(fontSize: 16, color: Colors.black), // Increased font size
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _assignmentType,
      decoration: InputDecoration(
        labelText: 'Assignment Type',
        labelStyle: TextStyle(
            color: Color(0xFF345FB4), fontSize: 16), // Increased font size
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(
            vertical: 16, horizontal: 12), // Increased padding
      ),
      items: ['Assignment', 'Document', 'Course'].map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(
            type,
            style: TextStyle(
                color: Colors.black, fontSize: 16), // Increased font size
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _assignmentType = value!;
        });
      },
    );
  }

  Widget _buildIconButton(IconData icon, String label, VoidCallback onPressed) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icon, size: 30), // Increased icon size
          onPressed: onPressed,
        ),
        Text(label,
            style: TextStyle(
                fontSize: 14, color: Color(0xFF345FB4))) // Increased font size
      ],
    );
  }
}
