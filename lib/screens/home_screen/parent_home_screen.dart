import 'package:flutter/material.dart';
import 'package:flutter_first_project/screens/login_screen/login_screen.dart';
import 'package:flutter_first_project/constante.dart';
import 'package:sizer/sizer.dart';

class ParentHomeScreen extends StatelessWidget {
  static const String routeName = 'ParentHomeScreen';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null || args['id'] == null || args['nomprenom'] == null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid arguments')),
        );
      });
      return Scaffold();
    }

    final String id = args['id'];
    final String nomprenom = args['nomprenom'];
    // Simulating the list of children. You can fetch this data from the backend.
    final List<dynamic> children = [
      {'child_name': 'Child 1'},
      {'child_name': 'Child 2'},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Tunisia Learning',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15.5,
                color: Colors.white,
              ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 30),
            onPressed: () {
              // Handle bell icon press
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20.0),
            color: kPrimaryColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nom d'utilisateur :",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: 12.0,
                          ),
                    ),
                    Text(nomprenom,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              fontSize: 12.0,
                              color: Colors.white,
                            )),
                    Text(
                      "Nom d'établissement :",
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            fontSize: 12.0,
                          ),
                    ),
                    Text('School',
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              fontSize: 12.0,
                              color: Colors.white,
                            )),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: 100.w,
              decoration: BoxDecoration(
                color: Color(0xFFF4F6F7),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: GridView.builder(
                padding: EdgeInsets.all(20.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                ),
                itemCount: children.length,
                itemBuilder: (context, index) {
                  final child = children[index];
                  return HomeCard(
                    onPress: () {
                      _navigateToChildDetailScreen(context, child);
                    },
                    title: child['child_name'],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToChildDetailScreen(BuildContext context, dynamic child) {
    // Uncomment and update the navigation code according to your app structure
    // Navigator.pushNamed(
    //   context,
    //   ChildDetailScreen.routeName,
    //   arguments: {'child': child},
    // );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    Key? key,
    required this.onPress,
    required this.title,
  }) : super(key: key);

  final VoidCallback onPress;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }
}

