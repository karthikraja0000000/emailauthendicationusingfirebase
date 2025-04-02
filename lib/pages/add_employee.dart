import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/text_form_assets.dart';
import 'home_page.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController employeeNameController = TextEditingController();
  TextEditingController employeeAgeController = TextEditingController();

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
                      "Add the Employee data",
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
                    controller: employeeNameController,
                    textHint: "Enter the employee name",
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
                    controller: employeeAgeController,
                    textHint: "Enter the Age",
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
                    onTap: addEmployee,
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

 Future<void> addEmployee() async{
   if(!_formKey.currentState!.validate()){
     return;
   }
   User? user = FirebaseAuth.instance.currentUser;

   DocumentReference employeeRef = await FirebaseFirestore.instance
       .collection('users')
       .doc(user?.uid)
       .collection('employees')
       .add({
     'name': employeeNameController.text.trim(),
     'age': employeeAgeController.text.trim(),
     'timestamp': FieldValue.serverTimestamp(),
   });
   String employeeUid = employeeRef.id; // Get the auto-generated document ID
   if (kDebugMode) {
     print("Employee added with ID: $employeeUid");
   }

   Navigator.pushReplacement(
     context,
     MaterialPageRoute(builder: (context) => HomePage()),
   );
 }
}
