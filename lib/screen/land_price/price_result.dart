import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const_data/const_data.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class LandPriceResult extends StatefulWidget {
  LandPriceResult({Key? key, required this.url}) : super(key: key);

  String? url;

  @override
  State<LandPriceResult> createState() => _LandPriceResultState();
}

class _LandPriceResultState extends State<LandPriceResult> {

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
      body: SfPdfViewer.network(widget.url??'')
    );
  }
}
