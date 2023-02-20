import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:landregistrationbdios/const_data/const_data.dart';

class CustomTextFeild extends StatelessWidget {
  CustomTextFeild({Key? key, this.keyboardType, this.fillColor, this.style, this.inputFormatters, this.hintext,this.suffixIcon,required this.isObsecure,this.controller,this.validator}) : super(key: key);

  String? hintext;
  IconButton? suffixIcon;
  bool isObsecure = false;
  TextEditingController? controller;
  dynamic validator;
  TextInputType? keyboardType;
  TextStyle? style;
  List<TextInputFormatter>? inputFormatters;
  Color? fillColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50.h,
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintStyle: getStyle14(),
          fillColor: fillColor,
          filled: true,
          hintText: hintext,
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(horizontal: 20.3,vertical: 15)
        ),
        obscureText: isObsecure,
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        style: style,
        inputFormatters: inputFormatters,
      ),
    );
  }
}
