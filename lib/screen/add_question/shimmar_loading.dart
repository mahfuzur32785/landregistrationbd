import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmarLoadingIndicator extends StatefulWidget {
  const ShimmarLoadingIndicator({Key? key}) : super(key: key);

  @override
  State<ShimmarLoadingIndicator> createState() =>
      _ShimmarLoadingIndicatorState();
}

class _ShimmarLoadingIndicatorState
    extends State<ShimmarLoadingIndicator> {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      // color: Colors.red,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
      Expanded(
      child: ListView.separated(
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFFF0F1F5),
            ),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(80),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.shade300,
                              radius: 25,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                width: 150.w,
                                height: 15.h,
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Container(
                                width: 150.w,
                                height: 15.h,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150.w,
                          height: 15.h,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          width: 150.w,
                          height: 15.h,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 8,
                        child: Container(
                          height: 25.h,
                          //width: 54.w,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 11,
                        child: Container(
                          height: 25.h,
                          //width: 80.w,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                        flex: 1,
                      ),
                      Expanded(
                        flex: 10,
                        child: Container(
                          alignment: Alignment.center,
                          height: 25.h,
                          //width: 70.w,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 10.h,
          );
        },
      ),
    )
    ]
      )
    );
  }
}