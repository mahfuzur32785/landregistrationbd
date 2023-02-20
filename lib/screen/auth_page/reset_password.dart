import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:landregistrationbdios/custom_things/txt_feild/custom_textfeild.dart';
import 'package:landregistrationbdios/screen/auth_page/sign_in_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api_service/api_service.dart';
import '../../const_data/const_data.dart';
import '../../provider/theme_provider/theme_provider.dart';
import '../../provider/token_provider.dart';

class ResetPassword extends StatefulWidget {
  ResetPassword({Key? key, this.countryCode, this.mobile}) : super(key: key);

  String? mobile, countryCode;

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController otpController = TextEditingController();
  TextEditingController new_passController = TextEditingController();
  TextEditingController c_passController = TextEditingController();

  bool isLoading = false;
  bool isNewPassObsecure = true;
  bool isConPassObsecure = true;

  String signUpProviderdata = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TokenProvider>(context, listen: false).getSignUpToken();
  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    signUpProviderdata =
        Provider.of<TokenProvider>(context, listen: true).signupTokendata;

    return Scaffold(
      // backgroundColor: Color(0xFFDEE3EB),
      appBar: AppBar(
        title: Text("Recover your password", style: getStyle16(color: Theme.of(context).primaryColor)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,color: Theme.of(context).primaryColor,)),
        elevation: 0.5,
        toolbarHeight: 57.h,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        blur: 2,
        progressIndicator: showSpinKitLoad(),
        child: Container(
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),

                    //Reset up Text++++++++++++++
                    Text(
                      'Set a new password & enjoy',
                      style: TextStyle(
                        color: themeProvider.isDarkMode ? Colors.white : Color(0xFF142D5D),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Sf_Pro',
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    //Sign In Text++++++++++++++
                    Text(
                      'Enter your new password',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Sf_Pro',
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),

                    //Pre Password Input Feild++++++++++++
                    CustomTextFeild(
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Please enter your OTP';
                        }
                      },
                      controller: otpController,
                      isObsecure: false,
                      hintext: 'Enter your OTP',
                      fillColor: Theme.of(context).splashColor,

                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    //New Password Input Feild++++++++++++
                    CustomTextFeild(
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Please enter your password';
                        }
                      },
                      controller: new_passController,
                      isObsecure: isNewPassObsecure,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isNewPassObsecure = !isNewPassObsecure;
                          });
                        },
                        icon: isNewPassObsecure == true
                            ? Icon(
                          Icons.visibility_off,
                          color: Theme.of(context).primaryColor,
                        ): Icon(
                          Icons.visibility,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      hintext: 'Enter new password',
                      fillColor: Theme.of(context).splashColor,

                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    //Confirm Password Input Feild++++++++++++
                    CustomTextFeild(
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return 'Please enter your confirm password';
                        }
                        if(value.toString() != new_passController.text){
                          return 'Confirm password not matched';
                        }
                      },
                      controller: c_passController,
                      isObsecure: isConPassObsecure,
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isConPassObsecure = !isConPassObsecure;
                          });
                        },
                        icon: isConPassObsecure == true
                            ? Icon(
                          Icons.visibility_off,
                          color: Theme.of(context).primaryColor,
                        ):Icon(
                          Icons.visibility,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      hintext: 'Confirm Password',
                      fillColor: Theme.of(context).splashColor,

                    ),
                    SizedBox(
                      height: 15.h,
                    ),

                    //Change password Button+++++++++++++++++++
                    ElevatedButton(
                      onPressed: () async{
                        var connectivityResult =
                        await (Connectivity().checkConnectivity());
                        if (_formKey.currentState!.validate()) {
                          // Remember password is  checked+++++++++++++++++++++++++++
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            setState(() {
                              isLoading = true;
                            });
                            var result = await ApiHttpService()
                                .recoverPassword(tokenData: signUpProviderdata, body: {
                              "countryCode": widget.countryCode.toString(),
                              "mobileNo": int.parse("${widget.mobile}").toString(),
                              "otp": otpController.text,
                              "password": c_passController.text,
                            });
                            var data = jsonDecode(result!.body);
                            if (result.statusCode == 200) {
                              SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                              sharedPreferences.setString("userTokenInSignUp", data['data']['token']);
                              setState(() {
                                isLoading = false;
                              });
                              showInToast(
                                  msg: data['message'], color: Color(0xFF142D5D));

                              Navigator.push(
                                context,
                                PageTransition(child: SignInPage(), type: PageTransitionType.leftToRight,duration: Duration(milliseconds: 400),
                                ),
                              );
                            }
                            else{
                              setState(() {
                                isLoading = false;
                              });
                              showInToast(
                                  msg: data['message'], color: Color(0xFF142D5D));
                            }
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            showInToast(msg: 'You are not connected with internet');
                          }
                        }
                      },
                      child: AutoSizeText('Change password',minFontSize: 12,style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500
                      ),),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF142D5D),
                          foregroundColor: Colors.white,
                          fixedSize: Size(MediaQuery.of(context).size.width*1.w, 50.h)
                      ),
                    ),
                    SizedBox(height: 18.h,),

                    //New member Sign in++++++++++++
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No needed? ',style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Sf_Pro',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF707070)
                        ),),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pushAndRemoveUntil(PageTransition(child: SignInPage(),type: PageTransitionType.leftToRight,duration: Duration(milliseconds: 400)), (route) => false);
                          },
                          child: Text(' Sign In',style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'Sf_Pro',
                              fontWeight: FontWeight.w500,
                            color: themeProvider.isDarkMode ? Colors.white : Color(0xFF142D5D),

                          ),),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
