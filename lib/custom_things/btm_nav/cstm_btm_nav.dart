import 'dart:io';

import 'package:fancy_bar/fancy_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:landregistrationbdios/custom_things/exit_app/exit_popup.dart';
import 'package:landregistrationbdios/provider/user_profile_provider.dart';
import 'package:landregistrationbdios/screen/comment/view_comments.dart';
import 'package:landregistrationbdios/screen/home/home_page.dart';
import 'package:landregistrationbdios/screen/profile/my_profile.dart';
import 'package:landregistrationbdios/screen/setting/setting_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../const_data/const_data.dart';
import '../../main.dart';
import '../../model_for_api/user_model.dart';
import '../../provider/token_provider.dart';
import '../../screen/auth_page/sign_in_page.dart';
import '../../screen/my_question/my_question.dart';

class CstmBtmNavBar extends StatefulWidget {
  const CstmBtmNavBar({Key? key}) : super(key: key);

  @override
  State<CstmBtmNavBar> createState() => _CstmBtmNavBarState();
}

class _CstmBtmNavBarState extends State<CstmBtmNavBar> {
  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  int currentIndex = 0;
  List<U_Data> userDataList = [];
  String? signUpToken;

  List page = [
    HomePage(),
    SettingPage(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<TokenProvider>(context, listen: false).getSignUpToken();
    Provider.of<UserProfileProvider>(context, listen: false)
        .getUserProfileData();
    getInitialFirebasePushNotification();

    //checkLatestVersion(context);
    checkVersion(context);
  }

  getInitialFirebasePushNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                color: Colors.blue, playSound: true, icon: "launch_background"),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new message opened');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewAnswers(
                  questionId: message.data['click_action'],
                  question: message.data['click_title'],
                )));
      }
    });
  }

  checkVersion(context) async {
    _checker.checkUpdate().then((value) {
      print(
          "Has update? ${value.canUpdate}"); //return true if update is available
      print(
          "Current app version: ${value.currentVersion}"); //return current app version
      print(
          "New app version: ${value.newVersion}"); //return the new app version
      print("App url: ${value.appURL}"); //return the app url
      print(
          'Error: ${value.errorMessage}'); //return error message if found else it will return null
      print(value.runtimeType);

      Version currentVersionnn = Version.parse(value.currentVersion);
      Version newVersionnn = Version.parse("${value.newVersion}");

      if (currentVersionnn < newVersionnn) {
        _showCompulsoryUpdateDialog(
            context, "দয়া করে আপনার অ্যাপটি আপডেট করুন");
      }
    });
  }

  final _checker = AppVersionChecker(
    appId: "com.landregistration.landregistrationbd",
    androidStore: AndroidStore.apkPure,
  );

  _showCompulsoryUpdateDialog(context, String message) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "নতুন ভার্সন চলে এসেছে";
        String btnLabel = "আপডেট";
        return WillPopScope(
          onWillPop: () async => exit(0),
          child: Platform.isIOS
              ? CupertinoAlertDialog(
                  title: Text(title),
                  content: Text(message),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text(
                        btnLabel,
                      ),
                      isDefaultAction: true,
                      onPressed: _onUpdateNowClicked,
                    ),
                  ],
                )
              : AlertDialog(
                  title: Text(
                    title,
                    style: TextStyle(fontSize: 22),
                  ),
                  content: Text(message),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text(btnLabel),
                      onPressed: _onUpdateNowClicked,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF142D5D)),
                    ),
                  ],
                ),
        );
      },
    );
  }

  _onUpdateNowClicked() {
    print('On update app clicked');
    final Uri url = Uri.parse(
        "https://play.google.com/store/apps/details?id=com.landregistration.landregistrationbd&hl=en&gl=US");
    launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    signUpToken =
        Provider.of<TokenProvider>(context, listen: true).signupTokendata;
    userDataList =
        Provider.of<UserProfileProvider>(context, listen: true).userdataList;

    return WillPopScope(
      onWillPop: () async {
        drawerKey.currentState?.closeDrawer();
        showExitPopup(context);
        return true;
      },
      child: Scaffold(
        key: drawerKey,
        drawer: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.height * 1,
          child: StatefulBuilder(
            builder: (context, setState) {
              return Drawer(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: DrawerHeader(
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                          ),
                          child: Center(
                            child: userDataList.isEmpty ||
                                    signUpToken.toString().isEmpty ||
                                    signUpToken == null ||
                                    signUpToken == ''
                                ? ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          PageTransition(
                                              child: SignInPage(),
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              duration:
                                                  Duration(milliseconds: 400)));
                                      // Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        fixedSize: Size(200.w, 50.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        backgroundColor: Color(0xFF6b7b8c)),
                                    child: Text(
                                      'Login/SignUp',
                                      style: getStyle14(color: Colors.white),
                                    ),
                                  )
                                : ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          "${userDataList[0].profileImageUrl}"),
                                    ),
                                    title: Text(
                                      "${userDataList[0].name}",
                                      style: getStyle12(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                    subtitle: Text(
                                      "0${userDataList[0].mobile}",
                                      style: getStyle10(
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: profileLable.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 10.h,
                            );
                          },
                          itemBuilder: (context, index) {
                            if (userDataList.isEmpty ||
                                signUpToken.toString().isEmpty ||
                                signUpToken == null ||
                                signUpToken == '') {
                              if (index == 0 || index == 6 || index == 5) {
                                return Container();
                              } else {
                                return ListTile(
                                  title: Text(profileLable[index]),
                                  leading: profileIcon[index],
                                  onTap: () {},
                                );
                              }
                            } else {
                              return ListTile(
                                title: Text(profileLable[index]),
                                leading: profileIcon[index],
                                onTap: () async {
                                  if (index == 0) {
                                    Navigator.push(
                                            context,
                                            PageTransition(
                                              child: ProfilePage(
                                                  u_data: userDataList[0],
                                                  signupTokenData: signUpToken),
                                              type: PageTransitionType
                                                  .rightToLeft,
                                              duration:
                                                  Duration(milliseconds: 400),
                                            ))
                                        .then(
                                            (value) => Navigator.pop(context));
                                  }
                                  if (index == 5) {
                                    Navigator.push(
                                            context,
                                            PageTransition(
                                                child: MyQuestionPage(),
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                duration: Duration(
                                                    milliseconds: 400)))
                                        .then(
                                            (value) => Navigator.pop(context));
                                    // print("signUpToken is $signUpToken");
                                  }
                                  if (index == 6) {
                                    SharedPreferences sharepreference =
                                        await SharedPreferences.getInstance();
                                    sharepreference.clear();
                                    showInToast(msg: 'You are log out');
                                    // Navigator.of(context).pop();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CstmBtmNavBar(),
                                        ),
                                        (route) => false);
                                  }
                                },
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        appBar: AppBar(
          toolbarHeight: 57.h,
          elevation: 0.5,
          backgroundColor: Theme.of(context).backgroundColor,
          foregroundColor: Colors.black,
          leading: IconButton(
            onPressed: () async {
              drawerKey.currentState?.openDrawer();
              //print(userDataList![0].name);
            },
            icon: FaIcon(FontAwesomeIcons.barsStaggered),
            color: Theme.of(context).primaryColor,
          ),
          title: Text(currentIndex == 0 ? 'Home' : 'Setting',
              style: getStyle16(color: Theme.of(context).primaryColor)),
        ),
        body: page[currentIndex],
        bottomNavigationBar: FancyBottomBar(
          type: FancyType.FancyV1, // Fancy Bar Type
          items: [
            FancyItem(
              textColor: Theme.of(context).primaryColor,
              title: 'Home',
              icon: Icon(Icons.home),
            ),
            FancyItem(
              textColor: Theme.of(context).primaryColor,
              title: 'Settings',
              icon: Icon(Icons.settings),
            ),
          ],
          onItemSelected: (index) {
            setState(() {
              currentIndex = index;
            });
            print("currentIndex is $currentIndex");
          },
        ),
      ),
    );
  }
}
