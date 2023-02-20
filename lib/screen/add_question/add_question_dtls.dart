import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:landregistrationbdios/const_data/const_data.dart';
import 'package:landregistrationbdios/custom_things/txt_feild/custom_textfeild.dart';
import 'package:landregistrationbdios/provider/category_provider.dart';
import 'package:landregistrationbdios/screen/add_question/all_question.dart';
import 'package:landregistrationbdios/screen/auth_page/sign_in_page.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../api_service/api_service.dart';
import '../../provider/token_provider.dart';
import '../my_question/my_question.dart';

class AddQuestionDetails extends StatefulWidget {
  AddQuestionDetails({Key? key, this.isAllquestion}) : super(key: key);

  String? isAllquestion;

  @override
  State<AddQuestionDetails> createState() => _AddQuestionDetailsState();
}

class _AddQuestionDetailsState extends State<AddQuestionDetails> {

  TextEditingController titleController = TextEditingController();
  TextEditingController describtionController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? selectedValue;

  var signUpProviderdata;

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CategoryProvider>(context, listen: false).getCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    signUpProviderdata =
        Provider.of<TokenProvider>(context, listen: true).signupTokendata;
    final dropDownListData =
        Provider.of<CategoryProvider>(context, listen: true).categoryDataList;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add new question",style: getStyle16(color: Theme.of(context).primaryColor)),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
          //Navigator.push(context,PageTransition(child: MyQuestionPage(),type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 400)));
        }, icon: Icon(Icons.arrow_back,color: Theme.of(context).primaryColor)),
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Colors.black,
        elevation: 0.5,
        toolbarHeight: 57.h,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: SpinKitDoubleBounce(
          itemBuilder: (context, index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.grey : Colors.white,
              ),
            );
          },
          size: 40,
        ),
        child: Container(
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category',
                      style: getStyle16(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 10.h,
                  ),

                  //SELECT CATEGORIES FROM DROPDOWN OPTION HERE++++++++++++++++++++++
                  Container(
                    alignment: Alignment.center,
                    height: 50.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).splashColor,
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        )),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text('Select One',style: TextStyle(color: Colors.black)),
                        isDense: true,
                        isExpanded: true,
                        onChanged: (dynamic value) {
                          setState(() {
                            selectedValue = value;
                            print("selected $value");
                          });
                        },
                        value: selectedValue,
                        items: List.generate(
                          dropDownListData.length,
                              (index) {
                            return DropdownMenuItem(
                              child: AutoSizeText(
                                  "${dropDownListData[index].name}",
                                  style: getStyle12(),
                                  minFontSize: 18),
                              value: "${dropDownListData[index].sId}",
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),

                  Text('Title of Question',
                      style: getStyle16(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 5.h,
                  ),
                  CustomTextFeild(
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Please add some description';
                      }
                    },
                    keyboardType: TextInputType.text,
                    controller: titleController,
                    isObsecure: false,
                    hintext: 'Write in 255 words',
                    // maxLength: 255,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(255)
                    ],
                    fillColor: Theme.of(context).splashColor,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Description of Question',
                      style: getStyle16(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 10.h,
                  ),

                  //ASK QUESTION DETAILS HERE+++++++++++++++++++
                  Container(
                      height: 210.h,
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'Please add some description';
                          }
                        },
                        controller: describtionController,
                        minLines:
                            6, // any number you need (It works as the rows for the textarea)
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
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
                            hintText: 'What do you want to asked?',
                            hintStyle: getStyle14(),
                          filled: true,
                          fillColor: Theme.of(context).splashColor,
                        ),
                        cursorHeight: 25,
                        cursorColor: Colors.black38,
                      ),
                  ),

                  //CANCEL AND ASK BUTTON+++++++++++++++++++++
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(142.w, 48.h),
                              backgroundColor: Color(0xFFDEE3EB),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Color(0xFF142D5D),
                                    width: 2,
                                  )),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xFF142D5D),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              // Navigator.push(context,PageTransition(child: MyQuestionPage(),type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 400)));
                            },
                          ),
                          flex: 5,
                        ),
                        Expanded(
                          child: Container(),
                          flex: 1,
                        ),
                        Expanded(
                          flex: 5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(142.w, 48.h),
                                backgroundColor: Color(0xFF142D5D),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Text(
                              'Ask Now',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            onPressed: () async {
                              var connectivityResult =
                                  await (Connectivity().checkConnectivity());

                              if (formKey.currentState!.validate()) {
                                if (selectedValue.toString().isEmpty ||
                                    selectedValue == null ||
                                    selectedValue == '') {
                                  showInToast(msg: 'Please select a category');
                                } else {
                                  if (connectivityResult ==
                                          ConnectivityResult.mobile ||
                                      connectivityResult ==
                                          ConnectivityResult.wifi) {
                                    if (signUpProviderdata != '' ||
                                        signUpProviderdata
                                            .toString()
                                            .isNotEmpty) {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      //Call API for add question
                                      var result = await ApiHttpService()
                                          .postAQuestion(
                                              tokenData: signUpProviderdata,
                                              body: {
                                            "categoryId":
                                                selectedValue.toString(),
                                            "description":
                                                describtionController.text,
                                            "title": titleController.text
                                          });
                                      var data = jsonDecode(result!.body);
                                      if (result.statusCode == 200) {

                                        await FirebaseMessaging.instance.subscribeToTopic(data['data']["id"]);

                                        showInToast(
                                            msg: data['message'],
                                            color: Color(0xFF142D5D));
                                        selectedValue = null;
                                        titleController.text = '';
                                        describtionController.text = '';
                                        setState(() {
                                          isLoading = false;
                                          Navigator.pushReplacement(
                                              context,PageTransition(child: widget.isAllquestion == "allQuestion"? AddQuestionPage() : MyQuestionPage(), type: PageTransitionType.leftToRight,duration: Duration(milliseconds: 400)));
                                          // Navigator.pop(context);
                                        });
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showInToast(
                                            msg: data['message'],
                                            color: Color(0xFF142D5D));
                                      }
                                    } else {
                                      selectedValue = null;
                                      titleController.text = '';
                                      describtionController.text = '';
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.push(
                                          context, PageTransition(child: SignInPage(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400)));
                                    }
                                  } else {
                                    showInToast(
                                        msg:
                                            'You are not connected with internet');
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
