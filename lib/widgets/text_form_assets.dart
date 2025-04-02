import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFormAssets extends StatefulWidget {
  final String str;
  String textHint;
  final bool obscureText;
  final TextEditingController controller;
  final bool numKeyBoardType;
  bool suffixText;
  final String? Function(String?)? validator;


  TextFormAssets({
    super.key,
    required this.obscureText,
    required this.controller,
    required this.textHint,
    required this.str,
    required this.suffixText,
    required this.numKeyBoardType,
    this.validator,
  });

  @override
  State<TextFormAssets> createState() => _TextFormAssetsState();
}

class _TextFormAssetsState extends State<TextFormAssets> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.str,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(text: widget.suffixText ==true ?"*":"", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        TextFormField(
          keyboardType: widget.numKeyBoardType == true ? TextInputType.number : TextInputType.text,
          obscureText: _obscureText,
          validator: widget.validator,
          controller: widget.controller,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: widget.textHint,hintStyle: TextStyle(fontFamily: 'SourceSansPro'),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: widget.obscureText
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
        ),
      ],
    );
  }
}
