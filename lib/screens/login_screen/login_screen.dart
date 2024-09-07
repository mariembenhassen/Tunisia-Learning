import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/constante.dart';
import 'package:flutter_first_project/components/custom_buttons.dart';
import 'package:flutter_first_project/screens/home_screen/home_screen.dart';
import 'package:flutter_first_project/screens/home_screen/parent_home_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

// Password visibility: declaration
late bool _passwordVisible;

class LoginScreen extends StatefulWidget {
  static String routeName = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Validate our form now
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields to get input values
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse(
            'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/login.php'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'email': email,
          'password': password,
        },
      );
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final Map<String, dynamic> responseData = json.decode(responseBody);

        if (responseData['success']) {
          if (responseData['role'] == 'parent') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              ParentHomeScreen.routeName,
              (route) => false,
              arguments: {
                'id': responseData['data']['id'],
                'nomprenom': responseData['data']['nomprenom'],
              },
            );
          } else if (responseData['role'] == 'teacher') {
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomeScreen.routeName,
              (route) => false,
              arguments: {
                'id': responseData['data']['id'],
                'nom': responseData['data']['nom'],
                'prenom': responseData['data']['prenom'],
              },
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData['message'])),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to login. Please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(kDefaultPadding),
          children: [
            // Logo and title section
            Container(
              height: MediaQuery.of(context).size.height / 2.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/splash.png',
                    height: 20.h,
                    width: 40.w,
                  ),
                  SizedBox(height: kDefaultPadding / 2),
                  Text(
                    'Tunisia Learning',
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(height: kDefaultPadding / 6),
                  Text(
                    'Platform login area',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontSize: 14.0,
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
            // Login Form Container with design
            Container(
              height: 550.0,
              decoration: BoxDecoration(
                color: kOtherColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(kDefaultPadding * 3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Input
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Email or Login',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: kDefaultPadding,
                              vertical: kDefaultPadding / 2),
                        ),
                        validator: (value) {
                          RegExp regExp = RegExp(emailPattern);
                          if (value == null || value.isEmpty) {
                            return "Please enter your email.";
                          } else if (!regExp.hasMatch(value)) {
                            return "Please enter a valid email address.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: kDefaultPadding),
                      // Password Input
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _passwordVisible,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: kDefaultPadding,
                              vertical: kDefaultPadding / 2),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            iconSize: 20.0,
                          ),
                        ),
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password must be at least 6 characters.";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: kDefaultPadding),
                      // Login Button
                      DefaultButton(
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        title: 'Login',
                        iconData: Icons.arrow_forward_outlined,
                      ),
                      SizedBox(height: kDefaultPadding),
                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Implement forgot password action
                          },
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: kDefaultPadding * 2),
                      // Support Information with improved UI
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(kDefaultPadding),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(kDefaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Support',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: kDefaultPadding / 2),
                            Row(
                              children: [
                                Icon(Icons.phone, color: Colors.blueAccent),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    '+216 95 093 111 / +216 73 214 701',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: kDefaultPadding / 4),
                            Row(
                              children: [
                                Icon(Icons.email, color: Colors.blueAccent),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    'deltawebit20@gmail.com',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: kDefaultPadding / 4),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.blueAccent),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    'Street Limam Boukhari - Khezama - 4051 - Sousse Tunisia',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: kDefaultPadding),
              child: Text(
                '© 2024 Tunisia Learning - Application created by Delta Web IT',
                style: TextStyle(
                  color: const Color.fromARGB(255, 248, 246, 246),
                  fontSize: 12.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
