import 'package:flutter_first_project/constante.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/screens/home_screen/home_screen.dart';
import 'package:sizer/sizer.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/constante.dart';
import 'package:flutter_first_project/screens/home_screen/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/screens/home_screen/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sizer/sizer.dart';

//the get work butthe ui is like shit

class MyProfileScreen extends StatefulWidget {
  static const String routeName = 'MyProfileScreen';

  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late Map<String, dynamic> teacherDetails;
  late TextEditingController emailController;
  late TextEditingController telephoneController;
  late TextEditingController adresseController;
  late TextEditingController dateNaissanceController;
  late TextEditingController lieuNaissanceController;
  late String id;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    teacherDetails = {};
    emailController = TextEditingController();
    telephoneController = TextEditingController();
    adresseController = TextEditingController();
    dateNaissanceController = TextEditingController();
    lieuNaissanceController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch teacher details based on route arguments
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    id = args?['id'] ?? '';
    fetchTeacherDetails();
  }

  @override
  void dispose() {
    emailController.dispose();
    telephoneController.dispose();
    adresseController.dispose();
    dateNaissanceController.dispose();
    lieuNaissanceController.dispose();
    super.dispose();
  }

  Future<void> fetchTeacherDetails() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost/Tunisia_Learning_backend/TunisiaLearningPhp/get_profil_teacher.php?id=$id'),
      );

      if (response.statusCode == 200) {
        setState(() {
          teacherDetails = json.decode(response.body)['data'];
          emailController.text = teacherDetails['email'] ?? '';
          telephoneController.text = teacherDetails['telephone'] ?? '';
          adresseController.text = teacherDetails['adresse'] ?? '';
          dateNaissanceController.text = teacherDetails['date_naissance'] ?? '';
          lieuNaissanceController.text = teacherDetails['lieu_naissance'] ?? '';

          // Initialize selectedDate with the fetched date_naissance
          selectedDate =
              DateTime.tryParse(teacherDetails['date_naissance'] ?? '');
        });
      } else {
        throw Exception('Failed to load teacher details');
      }
    } catch (e) {
      print('Exception while fetching teacher details: $e');
      // Handle error as needed
    }
  }

  //
// Define a custom SnackBar
  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.white),
          SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 73, 172, 76),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //
  //methode calendrier
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          //DateTime.now(), // Replace with the initial date you want to show
          selectedDate ?? DateTime.now(),

      firstDate:
          DateTime(1900), // Replace with the earliest date you want to allow
      lastDate:
          DateTime(2100), // Replace with the latest date you want to allow
      //
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF345FB4), // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Color(0xFF313131), // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF345FB4) // Button text color
                  ),
            ),
          ),
          child: child!,
        );
      },
    );
    //
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateNaissanceController.text =
            "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //app bar theme for tablet
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: Text('Information Personnel',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            )),
        actions: [
          InkWell(
            onTap: () {
              // Implement your logic for sending a report
              print('Sending report to school management');
              // in case if you want some changes to your profile
            },
            child: Container(
              padding: EdgeInsets.only(right: kDefaultPadding / 2),
              child: Row(
                children: [
                  Icon(Icons.report_gmailerrorred_outlined),
                  kHalfWidthSizedBox,
                  Text(
                    'Report',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      //5aleha badelna kan pop

      body: Container(
        color: kOtherColor,
        child: Column(
          children: [
            Container(
              //profile header
              width: 100.w,
              height: SizerUtil.deviceType == DeviceType.tablet ? 19.h : 15.h,
              decoration: BoxDecoration(
                color: Color(0xFF345FB4),
                borderRadius: kBottomBorderRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius:
                        SizerUtil.deviceType == DeviceType.tablet ? 12.w : 13.w,
                    backgroundColor: Color.fromARGB(255, 229, 231, 196),
                    backgroundImage:
                        AssetImage('assets/images/teacher_profil.png'),
                  ),
                  kWidthSizedBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${teacherDetails['nom']} ${teacherDetails['prenom']}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: Color.fromARGB(255, 236, 237, 217)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            //profile detail

            sizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              //
              children: [
                ProfileDetailRow(
                  title: 'Nom',
                  value: teacherDetails['nom'] ?? '',
                  editable: true,
                ),
                ProfileDetailRow(
                  title: 'Prènom',
                  value: teacherDetails['prenom'] ?? '',
                  editable: true,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileDetailRow(
                  title: 'Date de naissance',
                  value: selectedDate != null
                      ? "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}"
                      : teacherDetails['date_naissance'] ?? 'Select date',
                  editable: true,
                  icon: Icons.calendar_today,
                  onIconTap: () => _selectDate(context),
                ),
                ProfileDetailRow(
                  title: 'Lieu de naissance',
                  value: teacherDetails['lieu_naissance'] ?? '',
                  editable: true,
                ),
              ],
            ),

            sizedBox,
            ProfileDetailColumn(
              title: 'Email',
              value: teacherDetails['email'] ?? '',
              editable: true,
            ),
            ProfileDetailColumn(
              title: 'Mot de passe',
              value: teacherDetails['motdepasse'] ?? '',

              editable: false, // Make it uneditable
            ),
            ProfileDetailColumn(
              title: 'Téléphone',
              value: teacherDetails['telephone'] ?? '',
              editable: true,
            ),
            ProfileDetailColumn(
              title: 'Adresse',
              value: teacherDetails['adresse'] ?? '',
              editable: true,
            ),
            //button enregister
            sizedBox,
//

//

            ElevatedButton(
              onPressed: () {
                // Save changes action
                // Implement your logic to save changes here
                // This button will trigger the action to save the modified data
                // Make sure to implement the save functionality as per your requirements
                // ScaffoldMessenger.of(context)
                // .showSnackBar(

                // SnackBar(content: Text('Changes saved successfully')),
                _showSnackBar(context, 'Changes saved successfully');

                // );
              },

              //
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF345FB4), // Text color
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //

              child: Text('Enregistrer'),
            ),
            //
          ],
        ),
      ),
    );
  }
}

class ProfileDetailRow extends StatefulWidget {
  const ProfileDetailRow({
    Key? key,
    required this.title,
    required this.value,
    this.icon,
    this.onIconTap,
    this.editable = true,
  }) : super(key: key);
  final String title;
  final String value;
  final IconData? icon;
  final VoidCallback? onIconTap;
  final bool editable;

  @override
  State<ProfileDetailRow> createState() => _ProfileDetailRowState();
}

class _ProfileDetailRowState extends State<ProfileDetailRow> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  //
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //
  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

//
  void _saveChanges() {
    setState(() {
      _isEditing = false;
      // Implement logic to save _controller.text
      print('Saved: ${_controller.text}');
      // You can add logic here to update the data model or send changes to backend
    });
  }

// mizelet }
//narj3o non modif
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Color(0xFF313131),
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 7.sp
                          : 9.sp,
                    ),
              ),
              //
              kHalfSizedBox,

              //shenzydo gesture detector
              GestureDetector(
                onTap:
                    //widget.editable ? _startEditing : null,
                    widget.editable && widget.title != 'Mot de passe'
                        ? _startEditing
                        : null,
                child: widget.title == 'Mot de passe'
                    ? Row(
                        children: [
                          Text(
                            widget.value,
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                ?.copyWith(
                                  fontSize: 20, // Customize the value text size
                                ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.lock_outline,
                            size: 14.sp,
                          ),
                        ],
                      )
                    : _isEditing
                        ? SizedBox(
                            width: 100.w - 60.w, // Adjust width as needed
                            child: TextFormField(
                              controller: _controller,
                              style: Theme.of(context).textTheme.caption,
                              cursorColor: Colors.blue,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 8.sp, horizontal: 12.sp),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.sp)),
                              ),
                              keyboardType: TextInputType
                                  .text, // Adjust keyboardType as needed
                              autofocus: true,
                              maxLines: 1, // Adjust maxLines as needed
                              textAlign: TextAlign.start,
                              readOnly: !widget.editable,
                              onFieldSubmitted: (_) => _saveChanges(),
                            ),
                          )

                        //nzydo : fema) ne9es
                        : Row(
                            children: [
                              Text(
                                widget.value,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        fontSize: 19,
                                        color: Color.fromARGB(255, 99, 98, 98)),
                              ),
                              if (widget.title == 'Date de naissance') ...[
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: widget.onIconTap,
                                  child: Icon(
                                    Icons.calendar_today,
                                    size: 14.sp,
                                  ),
                                ),
                              ]
                            ],
                          ),
//haweha close gesture detectore )
              ),
              SizedBox(
                width: 35.w,
                child: Divider(
                  thickness: 1.0,
                ),
              ),
            ],
          ),
          if (widget.title == 'Mot de passe')
            // Only show lock icon for 'Mot de passe'
            Icon(
              Icons.lock_outline,
              size: 10.sp,
            ),
        ],
      ),
    );
  }
}

//ily fat tbdelesh

class ProfileDetailColumn extends StatefulWidget {
  const ProfileDetailColumn({
    Key? key,
    required this.title,
    required this.value,
    this.editable = true,
  }) : super(key: key);
  final String title;
  final String value;
  final bool editable;

  @override
  State<ProfileDetailColumn> createState() => _ProfileDetailColumnState();
}
//9bel mrigil

class _ProfileDetailColumnState extends State<ProfileDetailColumn> {
  //
  late TextEditingController _controller;
  bool _isEditing = false;
  //
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  //
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //
  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  //
  void _saveChanges() {
    setState(() {
      _isEditing = false;
      // Implement logic to save _controller.text
      print('Saved: ${_controller.text}');
      // You can add logic here to update the data model or send changes to backend
    });
  }

//
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Color(0xFF313131),
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 7.sp
                          : 11.sp,
                    ),
              ),
              //gesture detectur part
              kHalfSizedBox,
              GestureDetector(
                onTap: widget.editable ? _startEditing : null,
                child: _isEditing
                    ? SizedBox(
                        width: 100.w - 60.w, // Adjust width as needed
                        child: TextFormField(
                          controller: _controller,
                          style: Theme.of(context).textTheme.caption,
                          cursorColor: Colors.blue,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.sp, horizontal: 12.sp),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.sp)),
                          ),
                          keyboardType: TextInputType
                              .text, // Adjust keyboardType as needed
                          autofocus: true,
                          maxLines: 1, // Adjust maxLines as needed
                          textAlign: TextAlign.start,
                          readOnly: !widget.editable,
                          onFieldSubmitted: (_) => _saveChanges(),
                        ),
                      )
                    //ne9sa ) te3 gestur

                    : Text(
                        widget.value,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 19,
                            color: Color.fromARGB(255, 99, 98, 98)),
                      ),
                //gestur close
              ),
              //
              kHalfSizedBox,
              SizedBox(
                width: 92.w,
                child: Divider(
                  thickness: 1.0,
                ),
              )
            ],
          ),
          if (widget.title ==
              'Mot de passe') // Only show lock icon for 'Mot de passe'
            Icon(
              Icons.lock_outline,
              size: 10.sp,
            ),
        ],
      ),
    );
  }
}
