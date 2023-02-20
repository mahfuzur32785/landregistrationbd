import 'dart:convert';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:landregistrationbdios/api_service/api_service.dart';
import 'package:landregistrationbdios/const_data/const_data.dart';
import 'package:landregistrationbdios/custom_things/btm_nav/cstm_btm_nav.dart';
import 'package:landregistrationbdios/custom_things/txt_feild/custom_textfeild.dart';
import 'package:landregistrationbdios/screen/auth_page/sign_in_page.dart';
import 'package:country_picker/country_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/theme_provider/theme_provider.dart';
import '../add_question/all_question.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SharedPreferences? sharedPreferences;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController c_passController = TextEditingController();

  bool isPassObsecure = true;
  bool isCPassObsecure = true;

  bool isLoading = false;

  String countryCode = "880", flagIcon = "🇧🇩", countryName = "Bangladesh";

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);

    return Form(
      key: _formKey,
      child: Scaffold(
        // backgroundColor: Color(0xFFDEE3EB),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          progressIndicator: showSpinKitLoad(),
          blur: 0.5,
          child: Container(
            padding: EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 80.h,
                  ),

                  //Sign up Text++++++++++++++
                  Text(
                    'Sign up',
                    style: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white : Color(0xFF142D5D),
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Sf_Pro',
                      fontStyle: FontStyle.normal,
                    ),
                  ),

                  //Sign Up Text++++++++++++++
                  Text(
                    'Sign up and enjoy',
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

                  //Name Input Feild++++++++++++
                  CustomTextFeild(
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Please enter your name';
                      }
                    },
                    controller: nameController,
                    hintext: 'Enter name',
                    isObsecure: false,
                    fillColor: Theme.of(context).splashColor,
                  ),
                  SizedBox(
                    height: 20.h,
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
                                  hintText: 'Start typing to search',
                                  hintStyle: TextStyle(color: Colors.black),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      '${flagIcon}',
                                      style: TextStyle(
                                          fontSize: 16.sp, color: Colors.black),
                                    ),
                                    Text(
                                      '+$countryCode',
                                      style: TextStyle(
                                          fontSize: 12.sp, color: Colors.black),
                                    ),
                                    Icon(Icons.arrow_drop_down,
                                        size: 15.sp, color: Colors.black),
                                  ],
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${countryName}',
                                    style: TextStyle(
                                        fontSize: 12.sp, color: Colors.black),
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
                    isObsecure: isPassObsecure,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPassObsecure = !isPassObsecure;
                        });
                      },
                      icon: isPassObsecure == true
                          ? Icon(
                              Icons.visibility_off,
                              color: Theme.of(context).primaryColor,
                            )
                          : Icon(
                              Icons.visibility,
                              color: Theme.of(context).primaryColor,
                            ),
                    ),
                    hintext: 'Password',
                    fillColor: Theme.of(context).splashColor,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),

                  //Confirm Password Input Feild++++++++++++
                  CustomTextFeild(
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Please enter your confirm password';
                      }
                      if (passController.text != c_passController.text) {
                        return 'Password not matched';
                      }
                    },
                    controller: c_passController,
                    isObsecure: isCPassObsecure,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isCPassObsecure = !isCPassObsecure;
                        });
                      },
                      icon: isCPassObsecure == true
                          ? Icon(
                              Icons.visibility_off,
                              color: Theme.of(context).primaryColor,
                            )
                          : Icon(
                              Icons.visibility,
                              color: Theme.of(context).primaryColor,
                            ),
                    ),
                    hintext: 'Confirm Password',
                    fillColor: Theme.of(context).splashColor,
                  ),
                  SizedBox(
                    height: 21.h,
                  ),

                  //SignUp Button+++++++++++++++++++
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (passController.text == c_passController.text) {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());
                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            goSignUp();
                          } else {
                            showInToast(
                                msg: 'You are not connected with internet');
                          }
                        } else {
                          print('Password not matched');
                        }
                      }
                    },
                    child: AutoSizeText(
                      'Sign up',
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
                    height: 18.h,
                  ),

                  //New member Sign in++++++++++++
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'Sf_Pro',
                            fontWeight: FontWeight.w400,
                            color: themeProvider.isDarkMode ? Colors.grey : Color(0xFF707070)),

                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            PageTransition(
                                child: SignInPage(),
                                type: PageTransitionType.rightToLeft,
                                duration: Duration(milliseconds: 400)),
                          );
                        },
                        child: Text(
                          ' Sign In',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontFamily: 'Sf_Pro',
                              fontWeight: FontWeight.w500,
                              color: themeProvider.isDarkMode ? Colors.white : Color(0xFF142D5D),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> goSignUp() async {
    setState(() {
      isLoading = true;
    });
    var result = await ApiHttpService().signupUser(body: {
      "name": nameController.text.toString(),
      "mobile": int.parse(phoneController.text).toString(),
      "countryCode": countryCode.toString(),
      "password": passController.text.toString()
    });

    var data = jsonDecode(result!.body);
    if (result.statusCode == 200) {
      sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences!.setString("userTokenInSignUp", data["data"]["token"]);
      var token = sharedPreferences!.getString('userTokenInSignUp');
      print('token is: ${token}');

      showInToast(
        msg: data['message'],
        color: Color(0xFF142D5D),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => CstmBtmNavBar()),
        (route) => false,
      );
    } else {
      showInToast(msg: data['message'], color: Color(0xFF142D5D));
    }
    setState(() {
      isLoading = false;
    });
  }
}
