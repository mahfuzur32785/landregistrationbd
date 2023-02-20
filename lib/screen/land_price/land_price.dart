import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:landregistrationbdios/api_service/api_service.dart';
import 'package:landregistrationbdios/screen/land_price/price_result.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../const_data/const_data.dart';
import '../../model_for_api/land_price_model/district_category_model.dart';
import '../../model_for_api/land_price_model/division_category_model.dart';
import '../../model_for_api/land_price_model/office_categgory_model.dart';

class LandPrice extends StatefulWidget {
  const LandPrice({Key? key}) : super(key: key);

  @override
  State<LandPrice> createState() => _LandPriceState();
}

class _LandPriceState extends State<LandPrice> {
  bool isLoading = true;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? selectDivisionValue;
  String? selectDistrictValue;
  String? selectOfficeValue;

  List<Div_Data> dropDownDivisionListData = [];
  List<Dis_Data> dropDownDistrictListData = [];
  List<Off_Data> dropDownOfficeListData = [];

  var url;
  var fileName;
  
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    dropDownDivisionListData = await ApiHttpService().getDivisionData();
    setState(() {
      isLoading = false;
      print(dropDownDivisionListData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Land Price",
            style: getStyle16(color: Theme.of(context).primaryColor)),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              //Navigator.push(context,PageTransition(child: MyQuestionPage(),type: PageTransitionType.leftToRight, duration: Duration(milliseconds: 400)));
            },
            icon:
                Icon(Icons.arrow_back, color: Theme.of(context).primaryColor)),
        backgroundColor: Theme.of(context).backgroundColor,
        foregroundColor: Colors.black,
        elevation: 0.5,
        toolbarHeight: 57.h,
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        blur: 0.5,
        progressIndicator: showSpinKitLoad(),
        child: Container(
          padding: EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Division',
                      style: getStyle16(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 5.h,
                  ),

                  //SELECT CATEGORIES FROM DROPDOWN OPTION HERE++++++++++++++++++++++
                  Container(
                    alignment: Alignment.center,
                    height: 50.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).splashColor,
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        )),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text('Select One',
                            style: TextStyle(color: Colors.black)),
                        isDense: true,
                        isExpanded: true,
                        onChanged: (value) async {
                          setState(() {
                            selectDivisionValue = value;
                            isLoading = true;
                            print("selected division: $value");
                          });

                          dropDownDistrictListData = await ApiHttpService()
                              .getDistrictData(selectDivisionValue);
                          setState(() {
                            isLoading = false;
                            print(dropDownDistrictListData);
                          });
                        },
                        value: selectDivisionValue,
                        items: List.generate(
                          dropDownDivisionListData.length,
                          (index) {
                            return DropdownMenuItem(
                              value: "${dropDownDivisionListData[index].sId}",
                              child: AutoSizeText(
                                  "${dropDownDivisionListData[index].name}",
                                  style: getStyle12(),
                                  minFontSize: 18),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10.h,
                  ),

                  Text('District',
                      style: getStyle16(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).splashColor,
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        )),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text('Select One',
                            style: TextStyle(color: Colors.black)),
                        isDense: true,
                        isExpanded: true,
                        onChanged: (value) async {
                          setState(() {
                            selectDistrictValue = value;
                            isLoading = true;
                            print("selected district: $value");
                          });

                          dropDownOfficeListData = await ApiHttpService()
                              .getOfficeData(selectDistrictValue);
                          setState(() {
                            isLoading = false;
                            print(dropDownOfficeListData);
                          });
                        },
                        value: selectDistrictValue,
                        items: List.generate(
                          dropDownDistrictListData.length,
                          (index) {
                            return DropdownMenuItem(
                              value: "${dropDownDistrictListData[index].sId}",
                              child: AutoSizeText(
                                  "${dropDownDistrictListData[index].name}",
                                  style: getStyle12(),
                                  minFontSize: 18),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10.h,
                  ),
                  Text('Office',
                      style: getStyle16(fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50.h,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).splashColor,
                        border: Border.all(
                          color: Colors.grey.shade200,
                          width: 1,
                        )),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: Text('Select One',
                            style: TextStyle(color: Colors.black)),
                        isDense: true,
                        isExpanded: true,
                        onChanged: (value) async {
                          setState(() {
                            selectOfficeValue = value;
                            isLoading = true;
                            print("selected office: $value");
                          });

                          var result = await ApiHttpService()
                              .getResultData(selectOfficeValue);

                          if (result?.statusCode == 200) {

                            setState(() {
                              isLoading = false;
                            });
                            print(result?.data);
                            print(
                                'Response status: ${result?.statusCode}');

                            url = result?.data['data']
                            ['jomirMulloFileUrl'];

                            fileName = result?.data['data']['id'];
                            print("File name should: ${fileName}");

                          } else {
                            showInToast(
                                msg: 'No data found',
                                color: Color(0xFF142D5D));
                          }
                        },
                        value: selectOfficeValue,
                        items: List.generate(
                          dropDownOfficeListData.length,
                          (index) {
                            return DropdownMenuItem(
                              value: "${dropDownOfficeListData[index].sId}",
                              child: AutoSizeText(
                                  "${dropDownOfficeListData[index].name}",
                                  style: getStyle12(),
                                  minFontSize: 18),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  //CANCEL AND ASK BUTTON+++++++++++++++++++++
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(142.w, 48.h),
                                  backgroundColor: Color(0xFFDEE3EB),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        color: Color(0xFF142D5D),
                                        width: 2,
                                      )),
                                ),
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Color(0xFF142D5D),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectDivisionValue = null;
                                    selectDistrictValue = null;
                                    selectOfficeValue = null;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: Container(),
                              flex: 1,
                            ),
                            Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(142.w, 48.h),
                                  backgroundColor: Color(0xFF142D5D),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        color: Color(0xFF142D5D),
                                        width: 2,
                                      )),
                                ),
                                child: Text(
                                  'Result',
                                  style: TextStyle(
                                    color: Color(0xFFDEE3EB),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                onPressed: () {
                                  if(url!=null){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LandPriceResult(url: url)));
                                  }
                                  else{
                                    showInToast(msg: "Please wait to load");
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(142.w, 48.h),
                                  backgroundColor: Color(0xFF142D5D),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: const BorderSide(
                                        color: Color(0xFF142D5D),
                                        width: 2,
                                      )),
                                ),
                                child: Text(
                                  'Download',
                                  style: TextStyle(
                                    color: Color(0xFFDEE3EB),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                onPressed: () async {
                                  if(url!=null){
                                    letsDownload();
                                  }
                                  else{
                                    showInToast(msg: "Please wait to load");
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  letsDownload() async {
    PermissionStatus storagePermission = await Permission.storage.request();
    // print(status);
    if (storagePermission == PermissionStatus.granted) {
      print(storagePermission);
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {

        print("Url is: ${fileName}");
        setState(() {
          isLoading = true;
        });
        await saveFile(url: url, fileName: "${fileName.split(" ").first}.pdf");
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Download Successfully',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      } else {
        showInToast(msg: 'You are not connected with internet');
      }
    } else if (storagePermission == PermissionStatus.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Storage Permission is required',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } else if (storagePermission == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  Future<bool> saveFile({String? url, String? fileName}) async {
    try {
      Directory? directory;
      directory = await getExternalStorageDirectory();
      String newPath = "";
      List<String> paths = directory!.path.split("/");

      for (int x = 1; x < paths.length; x++) {
        String folder = paths[x];
        if (folder != "Android") {
          newPath += "/" + folder;
        } else {
          break;
        }
      }
      newPath = newPath + "/Land_Download";
      directory = Directory(newPath);

      File saveFile = File(directory.path + "/$fileName");
      if (kDebugMode) {
        print(saveFile.path);
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        await Dio().download(
          url!,
          saveFile.path,
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
