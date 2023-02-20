import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:landregistrationbdios/api_service/api_service.dart';
import 'package:landregistrationbdios/custom_things/btm_nav/cstm_btm_nav.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../const_data/const_data.dart';
import '../../model_for_api/my_question_model.dart';
import '../add_question/add_question_dtls.dart';
import '../comment/view_comments.dart';
import 'edit_my_question.dart';

class MyQuestionPage extends StatefulWidget {
  MyQuestionPage({Key? key, this.signUpProviderdata}) : super(key: key);

  String? signUpProviderdata;

  @override
  State<MyQuestionPage> createState() => _MyQuestionPageState();
}

class _MyQuestionPageState extends State<MyQuestionPage> {
  List<MyQ_Data> myQuestionProviderList = [];

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    myQuestionProviderList = await ApiHttpService().getAllMyQuestion(
        tokenData: sharedPreferences.getString('userTokenInSignUp'));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detils of your questions",
            style: getStyle16(color: Theme.of(context).primaryColor)),
        leading: IconButton(
          onPressed: () {
            //Navigator.pop(context);
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CstmBtmNavBar(),)).then((value) => Navigator.pop(context));
            Navigator.pushAndRemoveUntil(
                context,
                PageTransition(
                    child: CstmBtmNavBar(),
                    type: PageTransitionType.leftToRight,
                    duration: Duration(milliseconds: 400)),
                (route) => false);
          },
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.5,
        toolbarHeight: 57.h,
      ),
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          children: [
            //ADD Question button+++++++++++++++++++
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child:
                                AddQuestionDetails(isAllquestion: "myQuestion"),
                            duration: Duration(milliseconds: 400)))
                    .then((value) {
                  setState(() {});
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Add new question',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w200,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 25,
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF142D5D),
                  fixedSize: Size(double.maxFinite, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
            ),
            SizedBox(
              height: 20.h,
            ),

            //Question text and filter option++++++++++++++
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'My Question',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            myQuestionProviderList.isEmpty
                ? Center(
                    child: Text("No data available",style: getStyle16(),),
                  )
                : Expanded(
                    child: MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Theme.of(context).splashColor,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(80),
                                              color: Colors.red,
                                              /*image: DecorationImage(
                                        image:  NetworkImage('${snapshot.data![index].userId!.profileImageUrl}')*/
                                            ),
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                '${myQuestionProviderList[index].userId!.profileImageUrl}',
                                              ),
                                              radius: 25,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 150.w,
                                                // color: Co lors.red,
                                                child: AutoSizeText(
                                                  "${myQuestionProviderList[index].userId!.name}",
                                                  style: getStyle12(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Text(
                                                "${myQuestionProviderList[index].createdAt}",
                                                style: getStyle10(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  child: EditMyQuestion(
                                                      myQ_Data:
                                                          myQuestionProviderList[
                                                              index]),
                                                  type: PageTransitionType
                                                      .rightToLeft,
                                                  duration: Duration(
                                                      milliseconds: 400)));
                                        },
                                        child: Icon(Icons.more_vert,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "${myQuestionProviderList[index].title}",
                                            style: getStyle16(
                                                color: Colors.black)),
                                        Text(
                                            '${myQuestionProviderList[index].description}',
                                            style: getStyle14(
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 8,
                                        child: Container(
                                          height: 25.h,
                                          //width: 54.w,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                myQuestionProviderList[index]
                                                            .likeCount !=
                                                        0
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: Color(0xFF142D5D),
                                                size: 12.h,
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              AutoSizeText(
                                                "${myQuestionProviderList[index].likeCount}",
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
                                      Expanded(
                                        child: Container(),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        flex: 11,
                                        child: Container(
                                          height: 25.h,
                                          //width: 80.w,
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.question_answer,
                                                size: 12.h,
                                                color: Color(0xFF142D5D),
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              AutoSizeText(
                                                "${myQuestionProviderList[index].answerCount}",
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
                                      Expanded(
                                        child: Container(),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        flex: 10,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                PageTransition(
                                                    child: ViewAnswers(
                                                      question:
                                                          myQuestionProviderList[
                                                                  index]
                                                              .description,
                                                      questionId:
                                                          myQuestionProviderList[
                                                                  index]
                                                              .sId,
                                                    ),
                                                    type: PageTransitionType
                                                        .rightToLeft,
                                                    duration: Duration(
                                                        milliseconds: 400)));
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 25.h,
                                            //width: 70.w,
                                            padding: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color(0xFF142D5D),
                                            ),
                                            child: AutoSizeText(
                                              'View Answers',
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  fontFamily: 'Poppins',
                                                  color: Colors.white),
                                              minFontSize: 8,
                                              maxFontSize: 18,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 10.h,
                            );
                          },
                          itemCount: myQuestionProviderList.length),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
