import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../api_service/api_service.dart';
import '../../../const_data/const_data.dart';
import '../../../custom_things/txt_feild/custom_textfeild.dart';
import '../../../provider/category_provider.dart';
import '../../../provider/token_provider.dart';
import '../../model_for_api/my_question_model.dart';
import 'my_question.dart';

class EditMyQuestion extends StatefulWidget {
  EditMyQuestion({Key? key, this.myQ_Data}) : super(key: key);

  MyQ_Data? myQ_Data;

  @override
  State<EditMyQuestion> createState() => _EditMyQuestionState();
}

class _EditMyQuestionState extends State<EditMyQuestion> {

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
    Provider.of<TokenProvider>(context, listen: false).signupTokendata;
    titleController.text = "${widget.myQ_Data!.title}";
    describtionController.text = "${widget.myQ_Data!.description}"; 
    selectedValue = widget.myQ_Data!.categoryId;
  }

  @override
  Widget build(BuildContext context) {
    signUpProviderdata =
        Provider.of<TokenProvider>(context, listen: true).signupTokendata;
    final dropDownListData =
        Provider.of<CategoryProvider>(context, listen: true).categoryDataList;

    return Scaffold(
      appBar: AppBar(
        title: Text("Update your question",style: getStyle16(color: Theme.of(context).primaryColor)),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Theme.of(context).primaryColor,)),
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
                    hintext: 'Write in 100 words',
                    style: getStyle14(color: Colors.black),
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
                        style: getStyle14(color: Colors.black),
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
                              'Update',
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
                                      print('token found');
                                      //Call API for add question
                                      var result = await ApiHttpService()
                                          .updateAQuestion(
                                          tokenData: signUpProviderdata,
                                          id: widget.myQ_Data!.id,
                                          body: {
                                            "categoryId":
                                            selectedValue.toString(),
                                            "description":
                                            describtionController.text,
                                            "title": titleController.text
                                          });
                                      var data = jsonDecode(result!.body);
                                      if (result.statusCode == 200) {
                                        showInToast(
                                            msg: data['message'],
                                            color: Color(0xFF142D5D));
                                        selectedValue = null;
                                        titleController.text = '';
                                        describtionController.text = '';
                                        setState(() {
                                          isLoading = false;
                                          Navigator.pushReplacement(
                                              context,
                                              PageTransition(child: MyQuestionPage(), type: PageTransitionType.leftToRight,duration: Duration(milliseconds: 400)));
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
                                      print('no token found');
                                      setState(() {
                                        isLoading = false;
                                      });
                                      /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => MyQuestionPage(),
                                          ));*/
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
