import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool> showExitPopup(context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Container(
          height: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/warning.png'),
              ),
              SizedBox(height: 10.h),
              Text(
                'আপনি কি নিশ্চিত?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text("অ্যাপ থেকে বের হতে চান?"),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print('no selected');
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "না",
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF142D5D), onPrimary: Colors.white),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        print('yes selected');
                        exit(0);
                      },
                      child: Text("হ্যাঁ",style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF142D5D),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
