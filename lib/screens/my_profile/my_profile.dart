import 'package:flutter_first_project/constante.dart';
import 'package:flutter/material.dart';
import 'package:flutter_first_project/screens/home_screen/home_screen.dart';
import 'package:sizer/sizer.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);
  static String routeName = 'MyProfileScreen';

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  //
  DateTime? selectedDate;
  //
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
              primary: kPrimaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: kTextBlackColor, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryColor, // Button text color
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
      });
    }
    //
    /*if (picked != null && picked != DateTime.now()) {
      // Handle the selected date (you might want to setState or similar in a StatefulWidget)
      print(picked.toLocal().toString());
    }*/
  }

  //5alyha
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
                color: kPrimaryColor,
                borderRadius: kBottomBorderRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius:
                        SizerUtil.deviceType == DeviceType.tablet ? 12.w : 13.w,
                    backgroundColor: kSecondaryColor,
                    backgroundImage:
                        AssetImage('assets/images/student_profile.jpeg'),
                  ),
                  kWidthSizedBox,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Aisha Mirza',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text('Class X-II A | Roll no: 12',
                          style: Theme.of(context).textTheme.subtitle2),
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
                  value: 'KNANI SOUII',
                  editable: true,
                ),
                ProfileDetailRow(
                  title: 'Prènom',
                  value: 'SIHEM',
                  editable: true,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ProfileDetailRow(
                  title: 'Date de naissance',
                  value:
                      //
                      selectedDate != null
                          ? "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}"
                          : 'Select date',
                  // '03/27/1979',
                  editable: true,
                  icon: Icons.calendar_today,
                  onIconTap: () => _selectDate(context),
                ),
                ProfileDetailRow(
                  title: 'Lieu de naissance',
                  value: 'sousse',
                  editable: true,
                ),
              ],
            ),

            sizedBox,
            ProfileDetailColumn(
              title: 'Email',
              value: 'aisha12@gmail.com',
              editable: true,
            ),
            ProfileDetailColumn(
              title: 'Mot de passe',
              value: 'RCo4CjKP11',
              editable: false, // Make it uneditable
            ),
            ProfileDetailColumn(
              title: 'Téléphone',
              value: '21230405',
              editable: true,
            ),
            ProfileDetailColumn(
              title: 'Adresse',
              value: 'Sousse',
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
                backgroundColor: kPrimaryColor, // Text color
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
//tbadel kan statefull

class _ProfileDetailRowState extends State<ProfileDetailRow> {
//tbadel hathou mzoz ne9sa }
  late TextEditingController _controller;
  bool _isEditing = false;
//
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
                      color: kTextBlackColor,
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 7.sp
                          : 9.sp,
                    ),
              ),
              //
              kHalfSizedBox,

              //shenzydo gesture detector
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

                    //nzydo : fema) ne9es
                    : Row(
                        children: [
                          Text(widget.value,
                              style: Theme.of(context).textTheme.caption),
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
                      color: kTextBlackColor,
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

                    : Text(widget.value,
                        style: Theme.of(context).textTheme.caption),
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
