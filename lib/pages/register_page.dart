import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_authendication/pages/home_page.dart';
import 'package:email_authendication/widgets/text_form_assets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController rePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 16.w,
                  ),
                  child: Center(
                    child: Text(
                      "Register Form",
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
                    controller: emailController,
                    textHint: "Enter your Email",
                    str: "Email",
                    suffixText: true,
                    numKeyBoardType: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter the email";
                      } else if (!RegExp(
                        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                      ).hasMatch(value)) {
                        return "enter a valid email id";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  child: TextFormAssets(
                    obscureText: false,
                    controller: nameController,
                    textHint: "Enter your Name",
                    str: "Name",
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
                    controller: mobileNumberController,
                    textHint: "Enter your Mobile Number",
                    str: "Mobile Number",
                    suffixText: true,
                    numKeyBoardType: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter the mobile number";
                      } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return "please enter correct mobile number";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  child: TextFormAssets(
                    obscureText: true,
                    controller: passwordController,
                    textHint: "EX:Qwerty1@",
                    str: "Password",
                    suffixText: true,
                    numKeyBoardType: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter the Password";
                      } else if (!RegExp(
                        r'^[A-Z][a-z]+\d+[@$!%*?&]$',
                      ).hasMatch(value)) {
                        return "Password must initial letter uppercase then small must contain one number and spl char";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  child: TextFormAssets(
                    obscureText: true,
                    controller: rePasswordController,
                    textHint: "Enter your Password Again",
                    str: "Re-Password",
                    suffixText: true,
                    numKeyBoardType: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter the password again";
                      } else if (!RegExp(
                        r'^[A-Z][a-z]+\d+[@$!%*?&]$',
                      ).hasMatch(value)) {
                        return "Password must initial letter uppercase then small must contain one number and spl char";
                      } else if (passwordController.text !=
                          rePasswordController.text) {
                        return "Please enter the Correct password";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 32.h),
                Center(
                  child: GestureDetector(
                    onTap: register,
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
                SizedBox(height: 16.h),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Already a user? ",
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                          TextSpan(
                            text: " Login here",
                            style: TextStyle(
                              fontFamily: 'SourceSansPro',
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
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

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        'username': nameController.text.trim(),
        'email': emailController.text.trim(),
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      if (kDebugMode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ), // Correct way to show a SnackBar
        );
        print(e); // Logs the error in debug mode
      }
    }
  }
}
