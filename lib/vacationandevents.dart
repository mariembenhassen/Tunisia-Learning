import 'package:flutter/material.dart';

class EventsVacationsPage extends StatefulWidget {
  @override
  _EventsVacationsPageState createState() => _EventsVacationsPageState();
}

class _EventsVacationsPageState extends State<EventsVacationsPage> {
  int _selectedIndex = 0;

  // Data for vacations (no voting)
  final List<Map<String, String>> vacations = [
    {
      'title': 'Summer Vacation',
      'date': 'June 15, 2024 - September 1, 2024',
      'description':
          'School closed for summer vacation. Enjoy the holidays and prepare for the next academic year.',
    },
    {
      'title': 'Winter Break',
      'date': 'December 20, 2024 - January 3, 2025',
      'description':
          'Winter holidays for students to enjoy the festive season with family.',
    },
  ];

  // Data for events (with voting)
  final List<Map<String, String>> events = [
    {
      'title': 'Parent-Teacher Meeting',
      'date': 'November 10, 2024',
      'description':
          'Annual parent-teacher meeting to discuss student progress and school updates.',
    },
    {
      'title': 'School Trip to Historical Sites',
      'date': 'March 30, 2024',
      'description':
          'A field trip to explore Tunisian historical landmarks with students.',
    },
    {
      'title': 'Museum Visit',
      'date': 'February 12, 2024',
      'description':
          'A day trip to visit a local museum and learn about Tunisian culture.',
    },
  ];

  // Controller for the idea submission form
  final TextEditingController _ideaController = TextEditingController();

  // Function to show event voting
  void _showEventDetails(BuildContext context, Map<String, String> event) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event['title']!,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              SizedBox(height: 10),
              Text(
                event['date']!,
                style: TextStyle(fontSize: 18, color: Colors.blueAccent),
              ),
              SizedBox(height: 10),
              Text(
                event['description']!,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      // Action for "Interested"
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'You marked yourself as interested in ${event['title']}!'),
                        ),
                      );
                    },
                    child: Text('Interested'),
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      // Action for "Not Interested"
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'You marked yourself as not interested in ${event['title']}.'),
                        ),
                      );
                    },
                    child: Text('Not Interested'),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Function to build vacation list (no voting)
  Widget _buildVacations() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: vacations.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(15),
            title: Text(
              vacations[index]['title']!,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  vacations[index]['date']!,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueAccent,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 10),
                Text(
                  vacations[index]['description']!,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            leading:
                Icon(Icons.beach_access, color: Colors.orangeAccent, size: 40),
          ),
        );
      },
    );
  }

  // Function to build event list (with voting)
  Widget _buildEvents() {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 10),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(15),
            title: Text(
              events[index]['title']!,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  events[index]['date']!,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.blueAccent,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 10),
                Text(
                  events[index]['description']!,
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            leading: Icon(Icons.event, color: Colors.orangeAccent, size: 40),
            trailing:
                Icon(Icons.arrow_forward_ios, color: Colors.deepOrangeAccent),
            onTap: () {
              _showEventDetails(context, events[index]);
            },
          ),
        );
      },
    );
  }

  // Function to build idea submission form
  Widget _buildSubmitIdeaForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'If you have any ideas that can benefit our future heroes, please share them with us! 🌟🤝✨',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold), // Slightly smaller font size
          ),
          SizedBox(height: 16), // Reduced space for better fit on mobile
          TextField(
            controller: _ideaController,
            maxLines: 5,
            decoration: InputDecoration(
              labelText: 'Write your idea here...',
              labelStyle: TextStyle(fontSize: 16), // Adjust label font size
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8), // Better padding inside the field
            ),
          ),
          SizedBox(height: 16), // Reduced space for better fit on mobile
          Center(
            child: ElevatedButton(
              onPressed: () {
                if (_ideaController.text.isNotEmpty) {
                  // Simulate submission of the idea
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Thank you for submitting your idea!'),
                    ),
                  );
                  _ideaController.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12), // Better button padding
                textStyle: TextStyle(fontSize: 18), // Adjust button text size
              ),
              child: Text('Submit Idea'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Events & Vacations',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF345FB4),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildVacations(),
          _buildEvents(),
          _buildSubmitIdeaForm(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.beach_access),
            label: 'Vacations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outline),
            label: 'Submit Idea',
          ),
        ],
      ),
    );
  }
}
