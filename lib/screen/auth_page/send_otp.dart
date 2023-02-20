import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:landregistrationbdios/screen/auth_page/reset_password.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../api_service/api_service.dart';
import '../../const_data/const_data.dart';
import '../../custom_things/txt_feild/custom_textfeild.dart';
import '../../provider/token_provider.dart';

class SendOTPPage extends StatefulWidget {
  const SendOTPPage({Key? key}) : super(key: key);

  @override
  State<SendOTPPage> createState() => _SendOTPPageState();
}

class _SendOTPPageState extends State<SendOTPPage> {
  String countryCode = "880", flagIcon = "🇧🇩", countryName = "Bangladesh";

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();

  String signUpProviderdata = "";
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TokenProvider>(context, listen: false).getSignUpToken();
  }

  @override
  Widget build(BuildContext context) {
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
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Have you forgotten your password?',
                    style: getStyle16(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "Enter your mobile number to receive OTP through SMS.",
                    style: getStyle12(color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(
                    height: 30.h,
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
                                //print('Select country: ${country.flagEmoji}');
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${flagIcon}',
                                      style: TextStyle(fontSize: 16.sp,color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Text(
                                      '+$countryCode',
                                      style: TextStyle(fontSize: 12.sp,color: Colors.black),
                                    ),
                                    SizedBox(
                                      width: 3.w,
                                    ),
                                    Icon(Icons.arrow_drop_down,color: Colors.black),
                                  ],
                                ),
                                SizedBox(
                                  height: 3.h,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${countryName}',
                                    style: TextStyle(fontSize: 12.sp,color: Colors.black),
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
                        flex: 20,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  ElevatedButton(
                    onPressed: () async {
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
                              .sendOtp(tokenData: signUpProviderdata, body: {
                            "countryCode": countryCode.toString(),
                            "mobileNo":
                                int.parse(phoneController.text).toString(),
                          });
                          var data = jsonDecode(result!.body);
                          print(result.statusCode);
                          if (result.statusCode == 200) {
                            print('working And OTP is ${data['data']['testOtp']}');
                            setState(() {
                              isLoading = false;
                            });
                            showInToast(
                                msg: data['message'], color: Color(0xFF142D5D));

                            Navigator.push(
                              context,
                              PageTransition(child: ResetPassword(countryCode: countryCode, mobile: phoneController.text), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400),
                              ),
                            );
                          }
                          else{
                            print('not working');
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
                    child: AutoSizeText(
                      'Send OTP',
                      minFontSize: 12,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF142D5D),
                        foregroundColor: Colors.white,
                        fixedSize:
                            Size(MediaQuery.of(context).size.width * 1.w, 50.h)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
