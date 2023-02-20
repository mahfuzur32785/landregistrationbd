
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

String baseUrl = 'http://matirpathshala.com:3002/api/v1/';
// String baseUrl= 'http://192.168.68.126:3002/api/v1/';
String baseUrl1 = 'https://ji4139zbah.execute-api.ap-south-1.amazonaws.com/api/v1/';


showInToast({String? msg, Color? color, ToastGravity? toastGravity = ToastGravity.BOTTOM}){
  return Fluttertoast.showToast(
      msg: '${msg}',
      toastLength: Toast.LENGTH_SHORT,
      gravity: toastGravity,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

List profileIcon=[
      Icon(Icons.person),
      Icon(Icons.info_outline),
      Icon(Icons.star_rate),
      Icon(Icons.privacy_tip_outlined),
      Icon(Icons.request_page_rounded),
      Icon(Icons.question_answer),
      Icon(Icons.logout),
    ];

List profileLable = [
    "Profile", "About us", "Rate us", "Privacy Policy", "Terms & Conditions", "My Qustions", "Log out"
  ];


getStyle10({Color color = Colors.black}){
  return TextStyle(
    color: color,
    fontFamily: 'Poppins',
    fontSize: 10.sp,
  );
}

getStyle12({Color color = Colors.black, FontWeight fontWeight = FontWeight.w400}){
  return TextStyle(
    color: color,
    fontFamily: 'Poppins',
    fontSize: 12.sp,
    fontWeight: fontWeight,
  );
}
getStyle14({Color color = Colors.black, FontWeight? fontWeight}){
  return TextStyle(
    fontSize: 14.sp,
    fontFamily: 'Poppins',
    color: color,
    fontWeight: fontWeight,
  );
}
getStyle16({FontWeight? fontWeight, Color? color}){
  return TextStyle(
    fontSize: 16.sp,
    fontWeight: fontWeight,
    fontFamily: 'Poppins',
    color: color,
  );
}
showSpinKitLoad(){
  return SpinKitDoubleBounce(
    itemBuilder: (context, index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.grey : Colors.white,
        ),
      );
    },
    size: 40,
  );
}
