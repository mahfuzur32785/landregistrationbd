import 'package:flutter/cupertino.dart';
import 'package:landregistrationbdios/api_service/api_service.dart';

import '../model_for_api/my_question_model.dart';

class MyQuestionProvider with ChangeNotifier{

  List<MyQ_Data> myQuestionProviderList = [];

  Future<List<MyQ_Data>> getmyQuestionData({tokenData})async{
    myQuestionProviderList = await ApiHttpService().getAllMyQuestion(tokenData: tokenData);
    notifyListeners();
    return myQuestionProviderList;
  }

}