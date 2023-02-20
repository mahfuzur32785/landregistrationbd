import 'package:flutter/cupertino.dart';
import 'package:landregistrationbdios/api_service/api_service.dart';

import '../model_for_api/question_model.dart';

class QuestionProvider with ChangeNotifier{

  List<Q_Data> searchQuestionProviderList = [];

  Future<List<Q_Data>> getSearchData({tokendata, searchFilterKey, page, pageSize})async{
    searchQuestionProviderList = await ApiHttpService.getAllQuestionsDataWithAuthentication(tokenData: tokendata, searchFilterKey: searchFilterKey, page: page, pageSize:pageSize);
    notifyListeners();
    return searchQuestionProviderList;
  }

}