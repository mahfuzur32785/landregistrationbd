import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:landregistrationbdios/network/app_http.dart';
import '../const_data/const_data.dart';
import '../model_for_api/all_comment_model.dart';
import '../model_for_api/category_model.dart';
import '../model_for_api/land_price_model/district_category_model.dart';
import '../model_for_api/land_price_model/division_category_model.dart';
import '../model_for_api/land_price_model/office_categgory_model.dart';
import '../model_for_api/my_question_model.dart';
import '../model_for_api/question_model.dart';
import '../model_for_api/user_model.dart';

class ApiHttpService {

  //For Get Server Condition ++++++++++++++++++++++++
  Future<Response?> getServerCondition() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = '${baseUrl}serverMaintenance/638eccd0b33eda1e0ecc4f7b';
        var response = await Http.getHttpWithToken().get(url);

        return response;

      } catch (e) {
        print(e);
        //showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return null;
  }

  //For User Registration ++++++++++++++++++++++++++++++++
  Future<http.Response?> signupUser({body}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = Uri.parse(
          '${baseUrl}users/register',
        );
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(body),
        );
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return response;
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return null;
  }

  //For User Log In ++++++++++++++++++++++++++++++++
  Future<http.Response?> logInUser(body) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = Uri.parse(
          '${baseUrl}users/login',
        );
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(body),
        );
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        return response;
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return null;
  }

  //For User Profile Data Fetch+++++++++++++++++++++++++
  Future<List<U_Data>> getUserInfo({tokenData}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    List<U_Data> userDataList = [];

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var response;
        var url = '${baseUrl}users/get/info';
        if(tokenData==null||tokenData.toString().isEmpty||tokenData==''){
          response = await http.get(Uri.parse(url));
          print('status code: ${response.statusCode}');
          print(jsonDecode(response.body));
          var getdata = jsonDecode(response.body);
          //showInToast(msg: getdata['error']['message']);
        }else{
          response = await Http.getHttpWithToken(token: tokenData).get(url);
          print('status code: ${response.statusCode}');
          print(response.data);
          var getdata = response.data;
          U_Data data;
          data = U_Data.fromJson(getdata['data']);
          userDataList.add(data);

          return userDataList;
        }
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return userDataList;
  }

  //For Get Category Items+++++++++++++++++++++++++
  Future<List<C_Data>> getFilteringCategoriesData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    List<C_Data> categoryDataList = [];

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = '${baseUrl}categories';
        var response = await Http.getHttpWithToken().get(url);
        if (response.statusCode == 200) {
          var getData = response.data;
          C_Data data;
          for (var i in getData['data']) {
            data = C_Data.fromJson(i);
            categoryDataList.add(data);
          }
          return categoryDataList;
        }
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return categoryDataList;
  }

  //For Fetch ALl Question Data with User Token+++++++++++++++++++++++
  static Future<List<Q_Data>> getAllQuestionsDataWithAuthentication(
      {tokenData, searchFilterKey, page, pageSize}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    List<Q_Data> searchQuestionList = [];
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url =
            '${baseUrl}questions/authenticated/search/?q=$searchFilterKey&page=$page&limit=$pageSize';
        var response = await Http.getHttpWithToken(token: tokenData).get(url);
        //print(response.data);
        if (response.statusCode == 200) {
          var getData = response.data;
          Q_Data data;
          for (var i in getData['data']) {
            data = Q_Data.fromJson(i);
            searchQuestionList.add(data);
          }
          return searchQuestionList;
        }
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return searchQuestionList;
  }

  //For Fetch ALl Question Data with User Token+++++++++++++++++++++++
  static Future<List<Q_Data>> getAllQuestionsDataWithOutAuthentication(
      {searchFilterKey, page, pageSize}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    List<Q_Data> searchQuestionList = [];

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url =
            '${baseUrl}questions/search/?q=$searchFilterKey&page=$page&limit=$pageSize';
        var response = await Http.getHttpWithToken().get(url);
        //print(response.data);
        if (response.statusCode == 200) {
          var getData = response.data;
          Q_Data data;
          for (var i in getData['data']) {
            data = Q_Data.fromJson(i);
            searchQuestionList.add(data);
          }
          return searchQuestionList;
        }
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return searchQuestionList;
  }

  //For Fetch ALl Question Data with User Token+++++++++++++++++++++++
  Future<List<MyQ_Data>> getAllMyQuestion(
      {tokenData}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    List<MyQ_Data> myQuestionList = [];
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url =
            '${baseUrl}questions/myquestion';
        var response = await Http.getHttpWithToken(token: tokenData).get(url);
        //print(response.data);
        if (response.statusCode == 200) {
          var getData = response.data;
          MyQ_Data data;
          for (var i in getData['data']) {
            data = MyQ_Data.fromJson(i);
            myQuestionList.add(data);
          }
          return myQuestionList;
        }
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return myQuestionList;
  }

  //For Like And Dislike In a Question+++++++++++++++++++++++++++
  Future<void> postLikeOrDisLikeQuestion({tokenData, body}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = '${baseUrl}questionlike';
        var response = await Http.getHttpWithToken(token: tokenData).post(
          url,
          data: body,
        );
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.data}');
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
  }

  //For get All Comments +++++++++++++++++++++++++++
  Future<List<Comment_Data>> getAllCommentsData({tokenData, questionId}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    List<Comment_Data> commentsDataList = [];

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = '${baseUrl}comment/$questionId';
        var response = await Http.getHttpWithToken(token: tokenData).get(url);
        //print(response.data);
        if (response.statusCode == 200) {
          var getData = response.data;
          Comment_Data data;
          for (var i in getData['data']) {
            data = Comment_Data.fromJson(i);
            commentsDataList.add(data);
          }
          return commentsDataList;
        }
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return commentsDataList;
  }

  //For Post a Comment+++++++++++++++++++++++++++
  Future<http.Response?> postAComment({tokenData, body}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = Uri.parse('${baseUrl}comment');
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $tokenData',
          },
          body: jsonEncode(body),
        );
        /*var data = jsonDecode(response.body);
        print('Response status: ${response.statusCode}');
        print('Response body: ${data}');
        showInToast(msg: data['message']);*/
        return response;
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return null;
  }

  //For Like And Dislike In a Answer+++++++++++++++++++++++++++
  Future<void> postLikeOrDisLikeAnswer({tokenData, body}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = Uri.parse(
          '${baseUrl}commentlike',
        );
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $tokenData',
          },
          body: jsonEncode(body),
        );
        print('Response status: ${response.statusCode}');
        print('Response body: ${jsonDecode(response.body)}');
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    //return islike;
  }

  //For Like And Dislike In a Answer+++++++++++++++++++++++++++
  Future<http.Response?> postAQuestion({tokenData, body}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = Uri.parse(
          '${baseUrl}questions',
        );
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $tokenData',
          },
          body: jsonEncode(body),
        );
        return response;
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }

    return null;
  }

  //For Like And Dislike In a Answer+++++++++++++++++++++++++++
  Future<http.Response?> updateAQuestion({tokenData, body, id}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = Uri.parse(
          '${baseUrl}questions/$id',
        );
        var response = await http.put(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $tokenData',
          },
          body: jsonEncode(body),
        );
        print(response.statusCode);
        return response;
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return null;
  }

  //For Profile Update+++++++++++++++++++++++++++
  Future<http.Response?> updateProfileWithoutPicture({tokenData, body,id}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = Uri.parse(
          '${baseUrl}users/register/$id',
        );
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $tokenData',
          },
          body: jsonEncode(body),
        );
        return response;
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }

    return null;
  }

  //For Like And Dislike In a Answer+++++++++++++++++++++++++++
  Future<void> updateProfileWithPicture({tokenData, proImage}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = Uri.parse('${baseUrl}uploads/profile/picture');
        var request = http.MultipartRequest("PUT", url);
        request.headers.addAll(
          <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $tokenData',
          },
        );
        var image = await http.MultipartFile.fromPath('image', proImage);
        request.files.add(image);

        var response1 = await request.send();
        final response = await http.Response.fromStream(response1);
        if(response.statusCode == 200){
          print(response.statusCode);
          print(response.body);
        }

      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
  }

  /*
  Future<Response?> updateProfileWithPicture({tokenData, proImage}) async {

    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        FormData formData = FormData();
        String fileName = proImage.split('/').last;

        formData.files.add(MapEntry(
            "image",
            MultipartFile.fromFileSync(proImage,
                filename: fileName)));
       var response= await Http.getHttpWithToken(token: tokenData).put("${baseUrl}uploads/profile/picture", data: formData);

        print(response.statusCode);
        print(response.data);

        return response;
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return null;
  }
  */

  //For send otp to a number+++++++++++++++++++++++++++
  Future<http.Response?> sendOtp({tokenData, body}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = Uri.parse(
          '${baseUrl}users/forgot',
        );
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $tokenData',
          },
          body: jsonEncode(body),
        );
        return response;
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return null;
  }

  //For Update a password+++++++++++++++++++++++++++
  Future<http.Response?> recoverPassword({tokenData, body}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = Uri.parse(
          '${baseUrl}users/verify/password/otp',
        );
        var response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $tokenData',
          },
          body: jsonEncode(body),
        );
        return response;
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return null;
  }


  //FOR LAND PRICE +++++++++++++++++++++++++++++++++++

  //For Get Division Data Items+++++++++++++++++++++++++
  Future<List<Div_Data>> getDivisionData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    List<Div_Data> divisionDataList = [];

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = '${baseUrl1}division';
        var response = await Http.getHttpWithToken().get(url);
        if (response.statusCode == 200) {
          var getData = response.data;
          Div_Data data;
          for (var i in getData['data']) {
            data = Div_Data.fromJson(i);
            divisionDataList.add(data);
          }
          return divisionDataList;
        }
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return divisionDataList;
  }


  //For Get District Data Items+++++++++++++++++++++++++
  Future<List<Dis_Data>> getDistrictData(id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    List<Dis_Data> districtDataList = [];

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = '${baseUrl1}district/distName/${id}';
        var response = await Http.getHttpWithToken().get(url);
        if (response.statusCode == 200) {
          var getData = response.data;
          Dis_Data data;
          for (var i in getData['data']) {
            data = Dis_Data.fromJson(i);
            districtDataList.add(data);
          }
          return districtDataList;
        }
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return districtDataList;
  }

  //For Get Office Data Items+++++++++++++++++++++++++
  Future<List<Off_Data>> getOfficeData(id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    List<Off_Data> officeDataList = [];

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = '${baseUrl1}office/officesName/${id}';
        var response = await Http.getHttpWithToken().get(url);
        if (response.statusCode == 200) {
          var getData = response.data;
          Off_Data data;
          for (var i in getData['data']) {
            data = Off_Data.fromJson(i);
            officeDataList.add(data);
          }
          return officeDataList;
        }
      } catch (e) {
        showInToast(msg: '$e', color: Color(0xFF142D5D));
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return officeDataList;
  }

  //For Get Result Data Items+++++++++++++++++++++++++
  Future<Response?> getResultData(id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        var url = '${baseUrl1}jomirmullo/search/${id}';
        var response = await Http.getHttpWithToken().get(url);

        if(response.statusCode == 200){
          return response;
        }
        else if(response.statusCode == 400){
          return response;
        }
      } catch (e) {
        //showInToast(msg: '$e', color: Color(0xFF142D5D));
        print(e);
      }
    } else {
      showInToast(msg: 'You are not connected with internet');
    }
    return null;
  }

}
