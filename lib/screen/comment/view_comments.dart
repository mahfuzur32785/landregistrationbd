import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:landregistrationbdios/provider/theme_provider/theme_provider.dart';
import 'package:landregistrationbdios/screen/auth_page/sign_in_page.dart';
import 'package:provider/provider.dart';

import '../../api_service/api_service.dart';
import '../../const_data/const_data.dart';
import '../../model_for_api/all_comment_model.dart';
import '../../provider/token_provider.dart';

class ViewAnswers extends StatefulWidget {
  ViewAnswers({Key? key, this.question, this.questionId}) : super(key: key);

  String? question, questionId;

  @override
  State<ViewAnswers> createState() => _ViewAnswersState();
}

class _ViewAnswersState extends State<ViewAnswers> {
  TextEditingController commentController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TokenProvider>(context, listen: false).getSignUpToken();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var signUpProviderdata =
        Provider.of<TokenProvider>(context, listen: true).signupTokendata;
    return Scaffold(
      appBar: AppBar(
        title: Text("Answers of this question",
            style: getStyle16(color: Theme.of(context).primaryColor)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigator.pop(context,PageTransition(child: AddQuestionDetails(), type: PageTransitionType.leftToRight,duration: Duration(milliseconds: 400)));
            },
            icon:
                Icon(Icons.arrow_back, color: Theme.of(context).primaryColor)),
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Colors.black,
        elevation: 0.5,
        toolbarHeight: 57.h,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 25,right: 25,top: 25,bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: const Color(0xFFE2AE10),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  '${widget.question}',
                  style: getStyle16(),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 15),
                child: Text(
                  'Answers',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              Container(
                child: FutureBuilder<List<Comment_Data>>(
                  future: ApiHttpService().getAllCommentsData(
                      questionId: widget.questionId,
                      tokenData: signUpProviderdata),
                  builder: (context, snapshot) {
                    /*if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: SpinKitFadingCircle(
                    itemBuilder: (context, index) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: index.isEven ? Colors.red : Colors.black,
                        ),
                      );
                    },
                  ));
                }*/
                    if (snapshot.data == '' ||
                        snapshot.data == null ||
                        !snapshot.hasData ||
                        snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No answer found with this category'));
                    }
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          "You have something error!!!",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).splashColor,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 55,
                                    width: 55,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                    ),
                                    child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            '${snapshot.data![index].userId!.profileImageUrl}')),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${snapshot.data![index].userId!.name}',
                                        style: getStyle12(),
                                      ),
                                      Text(
                                        '${snapshot.data![index].createdAt}',
                                        style: getStyle10(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
                                child: Text('${snapshot.data![index].comment}',
                                    style: getStyle16(color: Colors.black)),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  if (signUpProviderdata != '' ||
                                      signUpProviderdata
                                          .toString()
                                          .isNotEmpty) {
                                    print(
                                        'Like is : ${snapshot.data![index].like}');
                                    setState(() {
                                      snapshot.data?[index].like =
                                      snapshot.data![index].like == true
                                          ? false
                                          : true;
                                    });
                                    print(
                                        'Like is : ${snapshot.data![index].like}');

                                    ApiHttpService().postLikeOrDisLikeAnswer(
                                      tokenData: signUpProviderdata,
                                      body: {
                                        "commentId": snapshot.data![index].sId
                                            .toString(),
                                        "likes": snapshot.data![index].like
                                            .toString(),
                                      },
                                    );
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SignInPage(),
                                        ));
                                  }
                                },
                                child: Container(
                                  height: 25.h,
                                  width: 80.w,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        snapshot.data![index].like == true
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: const Color(0xFF142D5D),
                                        size: 12.h,
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      AutoSizeText(
                                        "${snapshot.data![index].likeCount}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 9.sp,
                                            fontFamily: 'Poppins'),
                                        minFontSize: 8,
                                        maxFontSize: 18,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 15.h,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        width: double.infinity,
        height: 80.h,
        color: Theme.of(context).scaffoldBackgroundColor,
        alignment: Alignment.bottomCenter,
        child: Form(
          key: formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 35,
                child: TextFormField(
                  controller: commentController,
                  validator: (value) {
                    if (value.toString().isEmpty) {
                      return 'Please write something';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Write your answer..',
                    hintStyle: getStyle14(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    fillColor: Theme.of(context).splashColor,
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 0),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
                flex: 1,
              ),
              Expanded(
                flex: 5,
                child: IconButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (signUpProviderdata != "" ||
                          signUpProviderdata
                              .toString()
                              .isNotEmpty) {
                        setState(() {
                          isLoading = true;
                        });
                        var result =
                        await ApiHttpService().postAComment(
                          tokenData: signUpProviderdata,
                          body: {
                            "questionId":
                            widget.questionId.toString(),
                            "comment": commentController.text,
                          },
                        );
                        var data = jsonDecode(result!.body);
                        if (result.statusCode == 200) {
                          showInToast(msg: data['message']);
                          commentController.text = '';
                          setState(() {
                            isLoading = false;
                          });
                          print(
                              'Response status: ${result.statusCode}');
                          print('Response body: ${data}');
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          showInToast(
                              msg: data['message'],
                              color: const Color(0xFF142D5D));
                        }
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInPage(),
                            ));
                      }
                    }
                  },
                  icon: isLoading == true
                      ? CircularProgressIndicator(color: Theme.of(context).primaryColor,) : Icon(
                    Icons.send,
                    size: 25.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
