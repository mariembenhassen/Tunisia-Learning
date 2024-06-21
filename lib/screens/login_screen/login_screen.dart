import 'package:flutter_first_project/components/custom_buttons.dart';
import 'package:flutter_first_project/screens/home_screen/home_screen.dart';
//import 'package:flutter_first_project/screens/selection_screen/selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_first_project/constante.dart';
import 'package:sizer/sizer.dart';

//fazet password visibile : déclaration
late bool _passwordVissible;

class LoginScreen extends StatefulWidget {
  static String routeName = 'LoginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //validate our form now
  final _formKey = GlobalKey<FormState>();

  //change current state
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVissible = true;
  }

  //
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //the keyboard hid when the user type out of the input
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: ListView(
          children: [
            Container(
              //fit all screen size : use MediaQuery
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.8,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/splash.png',
                      height: 20.h,
                      width: 40.w,
                    ),
                    SizedBox(
                      height: kDefaultPadding / 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Tunisia ',
                            style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          'Learning',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: kDefaultPadding / 6),
                    Text(
                      'Espace de connexion à la platforme',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 255, 255, 255),
                          ),
                    ),
                    sizedBox,
                  ]),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kDefaultPadding * 3),
                  topRight: Radius.circular(kDefaultPadding * 3),
                ),
                color: kOtherColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          TextFormField(
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(
                              color: kTextBlackColor,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Entrer votre adresse email ou login',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isDense: true,
                            ),
                            //control simple
                            validator: (value) {
                              //for validation
                              RegExp regExp = new RegExp(emailPattern);
                              if (value == null || value.isEmpty) {
                                return "Veuillez entrer du texte.";
                                //if it does not matches the pattern, like
                                //it not contains @
                              } else if (!regExp.hasMatch(value)) {
                                return "Veuillez entrer une adresse email valide.";
                              }
                            },
                          ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          TextFormField(
                            //fazet l3in
                            obscureText: _passwordVissible,
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(
                              color: kTextBlackColor,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                              labelText: 'Entrer votre mot de passe',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isDense: true,
                              //the password visibility when we press
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordVissible = !_passwordVissible;
                                  });
                                },
                                icon: Icon(
                                  _passwordVissible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                iconSize: kDefaultPadding,
                              ),
                            ),
                            validator: (value) {
                              if (value!.length < 5) {
                                return "Doit comporter plus de 5 caractères.";
                              }
                            },
                          ),
                          SizedBox(
                            height: kDefaultPadding,
                          ),
                          DefaultButton(
                            onPress: () {
                              if (_formKey.currentState!.validate()) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    HomeScreen.routeName, (route) => false);

                                //go to next page
                                /*Navigator.pushNamed(
                                  context,
                                  StudentsListScreen.routeName,
                                  arguments: {
                                
                                'parentName': 'John Doe',
                                'students': ['Alice', 'Bob', 'Charlie'],
                               
                                  /*  'parentName':
                                        'Actual Parent Name', // Replace with actual parent name
                                    'students': [
                                      'Student 1',
                                      'Student 2',
                                      'Student 3'
                                    ],*/ // Replace with actual list of students
                                  },
                                );*/
                              }
                            },
                            title: 'Connecter',
                            iconData: Icons.arrow_forward_outlined,
                          ),
                          sizedBox,
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              'Mot de passe oubliée',
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //b1
          ],
        ),
      ),
    );
  }
}
