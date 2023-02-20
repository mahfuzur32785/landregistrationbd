import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:landregistrationbdios/api_service/api_service.dart';
import 'package:landregistrationbdios/const_data/const_data.dart';
import 'package:landregistrationbdios/screen/add_question/edit_all_question.dart';
import 'package:landregistrationbdios/provider/token_provider.dart';
import 'package:landregistrationbdios/screen/add_question/add_question_dtls.dart';
import 'package:landregistrationbdios/screen/add_question/shimmar_loading.dart';
import 'package:landregistrationbdios/screen/auth_page/sign_in_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../model_for_api/question_model.dart';
import '../../provider/user_profile_provider.dart';
import '../comment/view_comments.dart';

class AddQuestionPage extends StatefulWidget {
  const AddQuestionPage({Key? key}) : super(key: key);

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  final PagingController<int, Q_Data> _pagingController = PagingController(
    firstPageKey: 0,
  );

  bool isLoading = false;
  bool isLiked = false;
  int page = 1;
  int pageSize = 10;

  String signUpProviderdata = "";

  List dropDownListData = [];

  String? selectedValue;

  // List<MyQ_Data> myQuestionProviderList = [];

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    dropDownListData = await ApiHttpService().getFilteringCategoriesData();
    /*SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("userTokenInSignUp");
    if(token ==''||token ==null || token.toString().isEmpty){
      print("Token is empty");
    }else{
      print("Token is not empty");
      myQuestionProviderList = await ApiHttpService().getAllMyQuestion(
          tokenData: token
      );
    }
    setState(() {});*/
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TokenProvider>(context, listen: false).getSignUpToken();
    Provider.of<UserProfileProvider>(context, listen: false)
        .getUserProfileData();

    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey: pageKey + 1);
      // print("pageKey is $pageKey");
    });
  }

  Future<void> _fetchPage({int? pageKey}) async {
    var newItems;
    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        if (signUpProviderdata.isEmpty ||
            signUpProviderdata == '') {
          if (selectedValue == null || selectedValue.toString().isEmpty) {
            newItems =
                await ApiHttpService.getAllQuestionsDataWithOutAuthentication(
              searchFilterKey: '',
              page: pageKey,
              pageSize: pageSize,
            );
          } else {
            newItems =
                await ApiHttpService.getAllQuestionsDataWithOutAuthentication(
              searchFilterKey: selectedValue,
              page: pageKey,
              pageSize: pageSize,
            );
          }
        } else {
          if (selectedValue == null || selectedValue.toString().isEmpty) {
            newItems =
                await ApiHttpService.getAllQuestionsDataWithAuthentication(
              searchFilterKey: '',
              tokenData: signUpProviderdata,
              page: pageKey,
              pageSize: pageSize,
            );
          } else {
            newItems =
                await ApiHttpService.getAllQuestionsDataWithAuthentication(
              searchFilterKey: selectedValue,
              page: pageKey,
              tokenData: signUpProviderdata,
              pageSize: pageSize,
            );
          }
        }
      } else {
        showInToast(msg: "You are not connected with internet");
      }
      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey; // newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pagingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    signUpProviderdata =
        Provider.of<TokenProvider>(context, listen: true).signupTokendata;
    final userDataList =
        Provider.of<UserProfileProvider>(context, listen: true).userdataList;

    return Scaffold(
      appBar: AppBar(
        title: Text("All questions",
            style: getStyle16(color: Theme.of(context).primaryColor)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon:
                Icon(Icons.arrow_back, color: Theme.of(context).primaryColor)),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0.5,
        toolbarHeight: 57.h,
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            //ADD Question button+++++++++++++++++++
            ElevatedButton(
              onPressed: () {
                if (signUpProviderdata.isEmpty ||
                    signUpProviderdata == '') {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const SignInPage(),
                          duration: const Duration(milliseconds: 400)));
                } else {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child:
                              AddQuestionDetails(isAllquestion: "allQuestion"),
                          duration: const Duration(milliseconds: 400)));
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF142D5D),
                  fixedSize: Size(double.maxFinite, 50.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
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
                  const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 25,
                  )
                ],
              ),
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
                  'Question',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),

                //Filter button click open bottomModalSheet++++++++++++++++
                GestureDetector(
                  onTap: () {
                    showFilterOption();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.filter_list_alt,
                          color: Color(0xFF142D5D),
                          size: 18,
                        ),
                        Text(
                          'Filter',
                          style: TextStyle(
                            color: const Color(0xFF000000),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w200,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.sync(
                  () => _pagingController.refresh(),
                ),
                color: Colors.white,
                backgroundColor: const Color(0xFF142D5D),
                child: PagedListView<int, Q_Data>.separated(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Q_Data>(
                    animateTransitions: true,
                    transitionDuration: const Duration(milliseconds: 500),
                    firstPageProgressIndicatorBuilder: (context) =>
                        const ShimmarLoadingIndicator(),
                    newPageProgressIndicatorBuilder: (context) =>
                        const ShimmarLoadingIndicator(),
                    firstPageErrorIndicatorBuilder: (context) =>
                        const ShimmarLoadingIndicator(),
                    noMoreItemsIndicatorBuilder: (context) => Center(
                      child: Text(
                        "No more data...",
                        style: getStyle14(),
                      ),
                    ),
                    itemBuilder: (context, item, index) {
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(80),
                                        /*image: DecorationImage(
                                          image:  NetworkImage('${snapshot.data![index].userId!.profileImageUrl}')*/
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          '${item.userId?.profileImageUrl}',
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
                                        SizedBox(
                                          width: 150.w,
                                          // color: Colors.red,
                                          child: AutoSizeText(
                                            "${item.userId?.name}",
                                            style: getStyle12(
                                                fontWeight: FontWeight.w500),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          "${item.createdAt}",
                                          style: getStyle10(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                (signUpProviderdata == '' ||
                                        signUpProviderdata.isEmpty)
                                    ? Container()
                                    : (item.userId?.id == userDataList[0].id)
                                        ? GestureDetector(
                                            onTap: () async {
                                              Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child: EditAllQuestion(
                                                        q_Data: item,
                                                      ),
                                                      type: PageTransitionType
                                                          .rightToLeft,
                                                      duration: const Duration(
                                                          milliseconds: 400)));
                                            },
                                            child: const Icon(Icons.more_vert,
                                                color: Colors.black),
                                          )
                                        : Container()
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${item.title}",
                                      style: getStyle16(color: Colors.black)),
                                  Text('${item.description}',
                                      style: getStyle14(color: Colors.black)),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: GestureDetector(
                                    onTap: () async {
                                      if (signUpProviderdata != '' ||
                                          signUpProviderdata.isNotEmpty) {
                                        setState(() {
                                          item.like =
                                              item.like == true ? false : true;
                                        });
                                        //print('Like is : ${item.like}');

                                        ApiHttpService()
                                            .postLikeOrDisLikeQuestion(
                                          tokenData: signUpProviderdata,
                                          body: {
                                            "questionId": item.sId.toString(),
                                            "likes": item.like.toString(),
                                          },
                                        );
                                      } else {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                child: const SignInPage(),
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                duration: const Duration(
                                                    milliseconds: 400)));
                                      }
                                    },
                                    child: Container(
                                      height: 25.h,
                                      //width: 54.w,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            item.like == true
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: const Color(0xFF142D5D),
                                            size: 12.h,
                                          ),
                                          SizedBox(
                                            width: 2.w,
                                          ),
                                          AutoSizeText(
                                            "${item.likeCount}",
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
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                Expanded(
                                  flex: 11,
                                  child: Container(
                                    height: 25.h,
                                    //width: 80.w,
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.question_answer,
                                          size: 12.h,
                                          color: const Color(0xFF142D5D),
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        AutoSizeText(
                                          "${item.answerCount}",
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
                                  flex: 1,
                                  child: Container(),
                                ),
                                Expanded(
                                  flex: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(PageTransition(
                                          child: signUpProviderdata == '' ||
                                                  signUpProviderdata
                                                      .toString()
                                                      .isEmpty
                                              ? const SignInPage()
                                              : ViewAnswers(
                                                  question: item.description,
                                                  questionId: item.sId,
                                                ),
                                          type: PageTransitionType.rightToLeft,
                                          duration:
                                              const Duration(milliseconds: 400)));
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 25.h,
                                      //width: 70.w,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: const Color(0xFF142D5D),
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
                  ),
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: 10.h,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showFilterOption() async {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30))),
      context: context,
      isDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30))),
                height: 220.h,
                padding: const EdgeInsets.all(25),
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Category',
                          style: TextStyle(
                            color: const Color(0xFF000000),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 50.h,
                          width: double.infinity,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFF5F7FB),
                              border: Border.all(
                                color: Colors.grey.shade200,
                                width: 2,
                              )),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: const Text('Select One'),
                              isDense: true,
                              isExpanded: true,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedValue = value;
                                  //print("selected $value");
                                });
                              },
                              value: selectedValue,
                              items: List.generate(
                                dropDownListData.length,
                                (index) {
                                  return DropdownMenuItem(
                                    value: "${dropDownListData[index].sId}",
                                    child: AutoSizeText(
                                        "${dropDownListData[index].name}",
                                        style: getStyle12(),
                                        minFontSize: 18),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(142.w, 48.h),
                          backgroundColor: const Color(0xFF142D5D),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Text(
                        'Apply',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins',
                            color: Theme.of(context).primaryColor),
                      ),
                      onPressed: () async {
                        //searchQuestionCategoryItems(filterKey: selectedValue);
                        if (selectedValue == '' || selectedValue == null) {
                          showInToast(msg: "Please select a category");
                        } else {
                          _pagingController.refresh();
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {});
    });
  }
}
