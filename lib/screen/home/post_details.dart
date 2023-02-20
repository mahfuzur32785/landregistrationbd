import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:landregistrationbdios/model_for_static_data/post_category_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../const_data/const_data.dart';

class PostDetailsPage extends StatefulWidget {
  PostDetailsPage({Key? key, this.postCategoryStaticModel}) : super(key: key);

  PostCategoryStaticModel? postCategoryStaticModel;

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  WebViewController? webViewController;
  double webProgress = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.postCategoryStaticModel!.title}",
            style: getStyle16(color: Theme.of(context).primaryColor)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor),
        ),
        actions: [
          widget.postCategoryStaticModel?.id == 36 ||
                  widget.postCategoryStaticModel?.id == 37 ||
                  widget.postCategoryStaticModel?.id == 38 ||
                  widget.postCategoryStaticModel?.id == 40 ||
                  widget.postCategoryStaticModel?.id == 41
              ? IconButton(
                  onPressed: () async {
                    PermissionStatus storagePermission =
                        await Permission.storage.request();
                    // print(status);
                    if (storagePermission == PermissionStatus.granted) {
                      print(storagePermission);
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        await saveFile(
                          url: widget.postCategoryStaticModel?.id == 36
                              ? "https://landregistrationbd.com/wp-content/uploads/2022/10/3-sub_kobla_dan_Potro_hebar_ghosona_daner_ghosona_ptro_hebabil_Ayaz_binimoi_formet.pdf"
                              : widget.postCategoryStaticModel?.id == 37
                                  ? "https://landregistrationbd.com/wp-content/uploads/2022/10/4-power_of_aterny.pdf"
                                  : widget.postCategoryStaticModel?.id == 38
                                      ? "https://landregistrationbd.com/wp-content/uploads/2022/10/5-bideshi_power_of_aterny_formet.pdf"
                                      : widget.postCategoryStaticModel?.id == 40
                                          ? "https://landregistrationbd.com/wp-content/uploads/2022/10/6-tollashoporidorshoner_abedon_form-converted.pdf"
                                          : widget.postCategoryStaticModel
                                                      ?.id ==
                                                  41
                                              ? "https://landregistrationbd.com/wp-content/uploads/2022/10/7-dolilNokolerAbedonForm-converted.pdf"
                                              : null,
                          fileName:
                              "${widget.postCategoryStaticModel!.title!.split(" ").first}.pdf",
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'success',
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
                    } else if (storagePermission ==
                        PermissionStatus.permanentlyDenied) {
                      openAppSettings();
                    }
                  },
                  icon: Icon(
                    Icons.download,
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : Container(),
        ],
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.5,
        toolbarHeight: 57.h,
      ),
      body: widget.postCategoryStaticModel?.id == 36
          ? SfPdfViewer.asset('assets/pdf/sab_kobla.pdf')
          : widget.postCategoryStaticModel?.id == 37
              ? SfPdfViewer.asset('assets/pdf/power_of_aterny.pdf')
              : widget.postCategoryStaticModel?.id == 38
                  ? SfPdfViewer.asset('assets/pdf/bideshi_power_of_aterny.pdf')
                  : widget.postCategoryStaticModel?.id == 40
                      ? SfPdfViewer.asset('assets/pdf/tollas_o_poridorshon.pdf')
                      : widget.postCategoryStaticModel?.id == 41
                          ? SfPdfViewer.asset(
                              'assets/pdf/dolil_nokol_application.pdf')
                          : WillPopScope(
                              onWillPop: () async {
                                if (await webViewController!.canGoBack()) {
                                  webViewController!.goBack();
                                  return false;
                                } else {
                                  return true;
                                }
                              },
                              child: Column(
                                children: [
                                  webProgress < 1
                                      ? SizedBox(
                                          height: 5,
                                          child: LinearProgressIndicator(
                                            value: webProgress,
                                            color: Color(0xFF142D5D),
                                            backgroundColor: Colors.white,
                                          ),
                                        )
                                      : SizedBox(),
                                  Expanded(
                                    child: WebView(
                                      onWebViewCreated: (controller) {
                                        webViewController = controller;
                                        _loadHtmlFromAssets();
                                      },
                                      javascriptMode:
                                          JavascriptMode.unrestricted,
                                      onProgress: (progress) {
                                        setState(() {
                                          this.webProgress = progress / 100;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
    );
  }
  _loadHtmlFromAssets() async {
    webViewController?.loadUrl(Uri.dataFromString(
            "${widget.postCategoryStaticModel!.desc}",
            mimeType: 'text/html',
            encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
