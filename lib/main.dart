import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:landregistrationbdios/custom_things/btm_nav/cstm_btm_nav.dart';
import 'package:landregistrationbdios/provider/category_provider.dart';
import 'package:landregistrationbdios/provider/my_question_provider.dart';
import 'package:landregistrationbdios/provider/question_provider.dart';
import 'package:landregistrationbdios/provider/theme_provider/theme_provider.dart';
import 'package:landregistrationbdios/provider/token_provider.dart';
import 'package:landregistrationbdios/provider/user_profile_provider.dart';
import 'package:landregistrationbdios/screen/add_question/add_question_dtls.dart';
import 'package:landregistrationbdios/screen/add_question/all_question.dart';
import 'package:landregistrationbdios/server_maintain.dart';
import 'package:provider/provider.dart';

import 'api_service/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

// Firebase local notification plugin
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

//Firebase messaging
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title// description
  importance: Importance.high,
  playSound: true,
);

// flutter local notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// firebase background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A Background message just showed up :  ${message.messageId}');
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  var serverISDown;

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    try{
      var result = await ApiHttpService().getServerCondition();
      var data = jsonDecode(result!.data['data'][0]['serverIsDown']);
      if (result.statusCode == 200) {
        print(
            'Response status: ${result.statusCode}');
        print('Response body: $data');
        serverISDown = data;
      }
      else{
        print('Error');
      }
    }catch(e){
      print('Error${e}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => TokenProvider()),
            ChangeNotifierProvider(create: (context) => QuestionProvider()),
            ChangeNotifierProvider(create: (context) => CategoryProvider()),
            ChangeNotifierProvider(create: (context) => MyQuestionProvider()),
            ChangeNotifierProvider(create: (context) => UserProfileProvider()),
            ChangeNotifierProvider(
              create: (context) => ThemeProvider(),
              builder: (context, child) {
                final themeProvider = Provider.of<ThemeProvider>(context);
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'LandRegistrationBD',
                  theme: MyTheme.lightTheme,
                  themeMode: themeProvider.themeMode,
                  darkTheme: MyTheme.darkTheme,
                  //home: AddQuestionDetails(),
                  home: serverISDown == true ? ServerMaintain() :  CstmBtmNavBar(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
