import 'package:flutter/cupertino.dart';
import 'package:landregistrationbdios/api_service/api_service.dart';

import '../model_for_api/category_model.dart';

class CategoryProvider with ChangeNotifier{

  List<C_Data> categoryDataList = [];

  Future<List<C_Data>>getCategoryData({tokendata, searchFilterKey, page})async{
    categoryDataList = await ApiHttpService().getFilteringCategoriesData();
    print('Categories are : $categoryDataList');
    notifyListeners();
    return categoryDataList;
  }
}