import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class TeacherMessagingPage extends StatefulWidget {
  static const routeName = '/teacher_messagerie';

  @override
  _TeacherMessagingPageState createState() => _TeacherMessagingPageState();
}

class _TeacherMessagingPageState extends State<TeacherMessagingPage> {
  late int idUser;
  late int idEtablissement;
  bool isArgsLoaded = false;
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null ||
        args['iduser'] == null ||
        args['idetablissement'] == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error: Missing parameters.'),
        ),
      );
    }

    final int idUser = args['iduser'];
    final int idEtablissement = args['idetablissement'];

    return Scaffold(
      backgroundColor: Colors.blue[50]?.withOpacity(0.5),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 320.0, // Increased height to 320.0
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Messages",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "You have got 3 new mails",
                              style: TextStyle(
                                  color: Colors.blue[50], fontSize: 14.0),
                            ),
                          ],
                        ),
                        //
                      
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Expanded(
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                            bottom: 0.0,
                            child: Container(
                              height: 80.0, // Increased height to 80.0
                              width: 300.0,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10.0,
                            child: Container(
                              height: 80.0, // Increased height to 80.0
                              width: 330.0,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20.0,
                            child: Container(
                              height: 105.0, // Increased height to 105.0
                              width: 350.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blueGrey,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      // child: Padding(
                                      // padding: const EdgeInsets.all(3.0),
                                      // child: Image.asset(
                                      // "assets/boy.png",
                                      // height: 60.0,
                                      // width: 60.0,
                                      // ),
                                      // ),
                                      child: Icon(Icons.person,
                                          color: Colors.white),
                                    ),
                                    SizedBox(width: 8.0),
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  "Protorix Code",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16.0),
                                                ),
                                                Spacer(),
                                                Text(
                                                  "8:16 AM",
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12.0),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "Your opinion matters",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14.0),
                                            ),
                                            SizedBox(
                                              height: 3.0,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  "You have a mail. Check it!",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0),
                                                ),
                                                Spacer(),
                                                Icon(
                                                  Icons.star_border,
                                                  color: Colors.orange,
                                                  size: 20.0,
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.0),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "RECENTS",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "(634 mails)",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            InkWell(
              onTap: () {
                openBottomSheet();
              },
              child: Container(
                height: 100.0,
                width: 350.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          /* child: Image.asset(
                            "assets/boy.png",
                            height: 60.0,
                            width: 60.0,
                          ),*/
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Protorix Code",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  Spacer(),
                                  Text(
                                    "8:16 AM",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12.0),
                                  ),
                                ],
                              ),
                              Text(
                                "Your opinion matters",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14.0),
                              ),
                              SizedBox(
                                height: 3.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "You have a mail. Check it!",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12.0),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.star_border,
                                    color: Colors.orange,
                                    size: 20.0,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 140.0,
              width: 350.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            /* child: Image.asset(
                              "assets/boy.png",
                              height: 60.0,
                              width: 60.0,
                            ),*/
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Nwoye Akachi",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    Spacer(),
                                    Text(
                                      "8:16 AM",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12.0),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Wireframe for hotel booking app",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0),
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Please check the attachment",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12.0),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.star_border,
                                      color: Colors.orange,
                                      size: 20.0,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 140.0,
              width: 350.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            /* child: Image.asset(
                              "assets/boy.png",
                              height: 60.0,
                              width: 60.0,
                            ),*/
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Booking.com",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    Spacer(),
                                    Text(
                                      "8:16 AM",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12.0),
                                    ),
                                  ],
                                ),
                                Text(
                                  "Ticket confirmation",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0),
                                ),
                                SizedBox(
                                  height: 3.0,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Please check the ticket",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12.0),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.star_border,
                                      color: Colors.orange,
                                      size: 20.0,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 100.0,
            ),
          ],
        ),
      ),
    );
  }

  void openBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 500.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            /* child: Image.asset(
                              "assets/boy.png",
                              height: 60.0,
                              width: 60.0,
                            ),*/
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Protorix Code",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.blue[700],
                                    ),
                                    Icon(
                                      Icons.more_vert,
                                      color: Colors.blue[700],
                                    ),
                                  ],
                                ),
                                Text(
                                  "Your opinion matters",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.0),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Code,",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "To add custom fonts to your application, and a ",
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Thank you,",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Protorix Code",
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Reply..",
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 18.0),
                            ),
                            Spacer(),
                            CircleAvatar(
                              backgroundColor: Colors.blue[600],
                              child: Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}


/*
class TeacherMessagingPage extends StatelessWidget {
  static const routeName = '/teacher_messagerie';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null ||
        args['iduser'] == null ||
        args['idetablissement'] == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Error: Missing parameters.'),
        ),
      );
    }

    final int idUser = args['iduser'];
    final int idEtablissement = args['idetablissement'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Messagerie'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //form  admin ou enseignent 
            //from eleve choix 
            //form message
            //button envoyer 








            Text('ID User: $idUser'),
            Text('ID Etablissement: $idEtablissement'),
            
          ],
        ),
      ),
    );
  }
}
*/