import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/text_form_assets.dart';
import 'home_page.dart';

class UpdateEmployee extends StatefulWidget {
  final String employeeId;
  final String oldName;
  final String oldAge;

  const UpdateEmployee({super.key, required this.employeeId, required this.oldName, required this.oldAge});


  @override
  State<UpdateEmployee> createState() => _UpdateEmployeeState();
}

class _UpdateEmployeeState extends State<UpdateEmployee> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController editEmployeeNameController = TextEditingController();
  TextEditingController editEmployeeAgeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  child: Center(
                    child: Text(
                      "Update the Employee data",
                      style: TextStyle(
                        fontSize: 24.r,
                        fontFamily: "SourceSansPro",
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  child: TextFormAssets(
                    obscureText: false,
                    controller: editEmployeeNameController,
                    textHint: widget.oldName,
                    str: "Employee Name",
                    suffixText: true,
                    numKeyBoardType: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter the name";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  child: TextFormAssets(
                    obscureText: false,
                    controller: editEmployeeAgeController,
                    textHint:  widget.oldAge,
                    str: "Employee Age",
                    suffixText: true,
                    numKeyBoardType: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter the name";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 32.h),
                Center(
                  child: GestureDetector(
                    onTap: editEmployee,
                    child: Container(
                      height: 52.h,
                      width: 328.w,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Submit",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Future<void>  editEmployee() async{
  if(!_formKey.currentState!.validate()){
    return;
  }
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    DocumentReference employeeRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('employees')
        .doc(widget.employeeId);
        // .doc(Employees.uid);

    await employeeRef.update({
      'name': editEmployeeNameController.text.trim(),
      'age': editEmployeeAgeController.text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    if (kDebugMode) {
      print("Employee updated successfully");
    }


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }


}

}
