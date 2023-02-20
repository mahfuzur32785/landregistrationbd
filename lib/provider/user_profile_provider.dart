import 'package:flutter/cupertino.dart';
import 'package:landregistrationbdios/api_service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model_for_api/user_model.dart';

class UserProfileProvider with ChangeNotifier{

  List<U_Data> userdataList = [];

  Future<void> getUserProfileData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.getString('userTokenInSignUp');
    userdataList = await ApiHttpService().getUserInfo(tokenData: token);
    notifyListeners();
    print('my signupTokendata is: $userdataList');
  }
}