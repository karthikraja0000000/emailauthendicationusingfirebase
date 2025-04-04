import 'package:email_authendication/pages/home_page.dart';
import 'package:email_authendication/pages/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/text_form_assets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController loginRePasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool islogin = false;

  @override
  void dispose() {
    loginPasswordController.dispose();
    loginEmailController.dispose();
    loginRePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                      "Login Form",
                      style: TextStyle(
                        fontSize: 24.r,
                        fontFamily: "SourceSansPro",
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 16.w,
                  ),
                  child: TextFormAssets(
                    obscureText: false,
                    controller: loginEmailController,
                    textHint: "Enter your Email",
                    str: "Email",
                    suffixText: true,
                    numKeyBoardType: false,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "please enter the name";
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
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 16.w,
                  ),
                  child: TextFormAssets(
                    obscureText: true,
                    controller: loginPasswordController,
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

                SizedBox(height: 32.h),
                Center(
                  child: GestureDetector(
                    onTap: login,
                    child: Container(
                      height: 52.h,
                      width: 328.w,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child:
                            islogin
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                  "Submit",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                  ),
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
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Not a user? ",
                            style: GoogleFonts.poppins(color: Colors.black),
                          ),
                          TextSpan(
                            text: " Register here",
                            style: TextStyle(
                              fontFamily: 'SourceSansPro',
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ], //Children
                      ),
                    ),
                  ),
                ),
              ], //Children
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      islogin = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black.withAlpha(10)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withAlpha(10),
                      offset: Offset(0, 7),
                      blurRadius: 7
                  )
                ],
                borderRadius: BorderRadius.circular(12.r),
                color: Colors.white,
              ),
              child: Center(child: Text("User Doesn't exist Try Register",style: TextStyle(color: Colors.black),)),
            ),
          ), // Correct way to show a SnackBar
        );

        print(e);
      }
    } finally {
      setState(() {
        islogin = false;
      });
    }
  }
}
