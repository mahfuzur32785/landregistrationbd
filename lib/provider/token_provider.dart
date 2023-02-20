import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider with ChangeNotifier{

  String signupTokendata='';

  Future<void> getSignUpToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    signupTokendata = sharedPreferences.getString('userTokenInSignUp') ?? "";
    notifyListeners();
    print('my signupTokendata is: $signupTokendata');
  }
}