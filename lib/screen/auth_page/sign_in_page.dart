import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:landregistrationbdios/api_service/api_service.dart';
import 'package:landregistrationbdios/custom_things/btm_nav/cstm_btm_nav.dart';
import 'package:landregistrationbdios/custom_things/txt_feild/custom_textfeild.dart';
import 'package:landregistrationbdios/screen/auth_page/send_otp.dart';
import 'package:landregistrationbdios/screen/auth_page/sign_up_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../const_data/const_data.dart';
import '../../provider/theme_provider/theme_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  SharedPreferences? sharedPreferences;

  String countryCode = "880", flagIcon = "🇧🇩", countryName = "Bangladesh";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool isObsecure = true;
  //bool isCheked = false;

  bool isLoading = false;

  getToken() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      sharedPreferences = await SharedPreferences.getInstance();
      var signuptoken = sharedPreferences!.getString('userTokenInSignUp');
      var signintoken = sharedPreferences!.getString('userTokenInSignIn');

      if (signuptoken != null ||
          signintoken != null ||
          signuptoken?.isNotEmpty == true ||
          signintoken?.isNotEmpty == true) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => CstmBtmNavBar()),(route) => false,);
      } else {
        print('No Token Found');
      }
    }
    else{
      showInToast(msg: "You are not connected with internet");
    }
  }

  @override
  void initState() {
    getToken();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Form(
      key: _formKey,
      child: Scaffold(
        // backgroundColor: Color(0xFFDEE3EB),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          blur: 0.5,
          progressIndicator: showSpinKitLoad(),
          child: Container(
            padding: EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 80.h,
                  ),

                  //Welcome Text++++++++++++++
                  Text(
                    'Welcome,',
                    style: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white : Color(0xFF142D5D),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sf_Pro',
                      fontStyle: FontStyle.normal,
                    ),
                  ),

                  //Sign In Text++++++++++++++
                  Text(
                    'Sign in to continue',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Sf_Pro',
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(
                    height: 38.h,
                  ),

                  //Phone Input Feild++++++++++++
                  Row(
                    children: [
                      //COUNTRY CODE PICKER+++++++++++++++++++++++++
                      Expanded(
                        flex: 9,
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              countryListTheme: CountryListThemeData(
                                borderRadius: BorderRadius.circular(5),
                                inputDecoration: InputDecoration(
                                  //labelText: 'Search',
                                  hintStyle: TextStyle(color: Colors.black),
                                  hintText: 'Start typing to search',
                                  fillColor: Theme.of(context).splashColor,
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xFF8C98A8).withOpacity(0.8),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8)
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8)
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: const Color(0xFF8C98A8)
                                          .withOpacity(0.2),
                                    ),
                                  ),
                                ),
                              ),
                              // optional. Shows phone code before the country name.
                              onSelect: (Country country) {
                                print('Select country: ${country.flagEmoji}');
                                setState(() {
                                  countryCode = country.phoneCode;
                                  flagIcon = country.flagEmoji;
                                  if (country.name.length > 9) {
                                    countryName =
                                        "${country.name.substring(0, 9)}...";
                                  } else {
                                    countryName = country.name;
                                  }
                                });
                              },
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).splashColor,
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${flagIcon}',
                                      style: TextStyle(fontSize: 16.sp,color: Colors.black),
                                    ),
                                    Text(
                                      '+$countryCode',
                                      style: TextStyle(fontSize: 12.sp,color: Colors.black),
                                    ),
                                    Icon(Icons.arrow_drop_down,size: 15.sp,color: Colors.black),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${countryName}',
                                    style: TextStyle(fontSize: 12.sp, color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 20,
                        child: CustomTextFeild(
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'Please enter your mobile number';
                            }
                          },
                          keyboardType: TextInputType.number,
                          controller: phoneController,
                          hintext: 'Enter mobile number',
                          isObsecure: false,
                          fillColor: Theme.of(context).splashColor,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),

                  //Password Input Feild++++++++++++
                  CustomTextFeild(
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Please enter your password';
                      }
                    },
                    controller: passController,
                    isObsecure: isObsecure,
                    hintext: 'Password',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObsecure = !isObsecure;
                          });
                        },
                        icon: isObsecure == true
                            ? Icon(
                                Icons.visibility_off,
                                color: Theme.of(context).primaryColor,
                              )
                            : Icon(
                                Icons.visibility,
                                color: Theme.of(context).primaryColor,
                              ),
                    ),
                    fillColor: Theme.of(context).splashColor,
                  ),
                  SizedBox(
                    height: 24.h,
                  ),

                  //Remember password and fForgot password++++++++++++++++
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Checkbox(value: isCheked, onChanged: (value) {
                            setState(() {
                              isCheked = !isCheked;
                            });
                          },
                          fillColor: MaterialStateProperty.all(Color(0xFF142D5D),
                          ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),

                          ),
                      GestureDetector(
                            onTap: () {
                              setState(() {
                                isCheked = !isCheked;
                              });
                            },
                            child: Container(
                              height: 22,
                              width: 22,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: isCheked == true
                                      ? Color(0xFF142D5D)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Color(0xFF142D5D), width: 2)),
                              child: isCheked == false
                                  ? null
                                  : Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'Keep me login',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Color(0xFF707070),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),*/
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageTransition(child: SendOTPPage(),type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400)));
                        },
                        child: Text(
                          'Recovery Password',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: themeProvider.isDarkMode ? Colors.grey : Color(0xFF707070),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),

                  //Sign Button+++++++++++++++++++
                  ElevatedButton(
                    onPressed: () async {
                      var connectivityResult = await (Connectivity().checkConnectivity());
                      if (_formKey.currentState!.validate()) {
                        // Remember password is  checked+++++++++++++++++++++++++++
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                          logInWithRememberPassword();
                        } else {
                          showInToast(
                              msg: 'You are not connected with internet');
                        }
                        /*if (isCheked == true) {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            logInWithRememberPassword();
                          } else {
                            showInToast(
                                msg: 'You are not connected with internet');
                          }
                        }*/
                        // Remember password is not checked+++++++++++++++++++++++++++
                        /*else {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            logInWithOutRememberPassword();
                          } else {
                            showInToast(
                                msg: 'You are not connected with internet');
                          }
                        }*/
                      }
                    },
                    child: AutoSizeText(
                      'Sign in',
                      minFontSize: 12,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF142D5D),
                        foregroundColor: Colors.white,
                        fixedSize: Size(
                            MediaQuery.of(context).size.width * 1.w, 50.h)),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),

                  //Or Sign up text+++++++++++++++
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 1.h,
                        width: 80.w,
                        color: Color(0xFF707070),
                      ),
                      Text(
                        'or sign up with',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: themeProvider.isDarkMode ? Colors.grey : Color(0xFF707070),
                          fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400),
                      ),
                      Container(
                        height: 1.h,
                        width: 80.w,
                        color: Color(0xFF707070),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),

                  //Social Icons++++++++++++++++++
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 50.h,
                        width: 95.w,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: Image.asset(
                          'assets/images/social_icon/facebook.png',
                        ),
                      ),
                      Container(
                          height: 50.h,
                          width: 95.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 14),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Image.asset(
                            'assets/images/social_icon/instagram.png',
                          )),
                      Container(
                          height: 50.h,
                          width: 95.w,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 14),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Image.asset(
                            'assets/images/social_icon/twitter.png',
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 28.h,
                  ),

                  //New member Sign in++++++++++++
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'New member? ',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Sf_Pro',
                            fontWeight: FontWeight.w400,
                            color: themeProvider.isDarkMode ? Colors.grey : Color(0xFF707070)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, PageTransition(child: SignUpPage(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400)));
                          //Navigator.pushAndRemoveUntil(context, PageTransition(child: SignUpPage(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400)),(route) => false,);
                        },
                        child: Text(
                          ' Sign Up',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'Sf_Pro',
                              fontWeight: FontWeight.w500,
                              color: themeProvider.isDarkMode ? Colors.white : Color(0xFF142D5D)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //log In With Remember Password++++++++++++++++++++++++++
  Future<void> logInWithRememberPassword() async {
    setState(() {
      isLoading = true;
    });

    var result = await ApiHttpService().logInUser({
      "mobileNo": int.parse(phoneController.text).toString(),
      "countryCode": countryCode.toString(),
      "password": passController.text
    });

    var data = jsonDecode(result!.body);
    if (result.statusCode == 200) {
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences!.setString("userTokenInSignUp", data["data"]["token"]);
      var signuptoken = sharedPreferences!.getString('userTokenInSignUp');
      print('token is: ${signuptoken}');

      showInToast(msg: data['message'], color: Color(0xFF142D5D));
      // Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => CstmBtmNavBar()));
    } else {
      showInToast(msg: data['message'], color: Color(0xFF142D5D));
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  //log In WithOut Remember Password++++++++++++++++++++++++++
  /*Future<void> logInWithOutRememberPassword() async {
    setState(() {
      isLoading = true;
    });

    var result = await ApiHttpService().logInUser({
      "mobileNo": int.parse(phoneController.text).toString(),
      "countryCode": countryCode.toString(),
      "password": passController.text
    });
    var data = jsonDecode(result!.body);
    if (result.statusCode == 200) {

      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences!.setString("userTokenInSignIn", data["data"]["token"]);
      var signintoken = sharedPreferences!.getString('userTokenInSignIn');
      print('signintoken is: ${signintoken}');

      showInToast(msg: data['message'], color: Color(0xFF142D5D));
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AddQuestionPage()));
    } else {
      showInToast(msg: data['message'], color: Color(0xFF142D5D));
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }*/
}
