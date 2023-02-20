import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:landregistrationbdios/model_for_static_data/category_model.dart';
import 'package:landregistrationbdios/model_for_static_data/sub_category_model.dart';
import 'package:landregistrationbdios/screen/home/post_details.dart';
import 'package:page_transition/page_transition.dart';

import '../../const_data/const_data.dart';

class PostCategoryPage extends StatefulWidget {
  PostCategoryPage({Key? key,this.postcategory, this.subCategoryStaticModel,this.categoryStaticModel}) : super(key: key);
  List? postcategory;
  SubCategoryStaticModel? subCategoryStaticModel;
  CategoryStaticModel? categoryStaticModel;

  @override
  State<PostCategoryPage> createState() => _PostCategoryPageState();
}

class _PostCategoryPageState extends State<PostCategoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.subCategoryStaticModel!=null?Text("${widget.subCategoryStaticModel!.title}",style: getStyle16(color: Theme.of(context).primaryColor))
            :Text("${widget.categoryStaticModel!.title}",style: getStyle16(color: Theme.of(context).primaryColor)),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
          // Navigator.pop(context,PageTransition(child: AddQuestionDetails(), type: PageTransitionType.leftToRight,duration: Duration(milliseconds: 400)));
        }, icon: Icon(Icons.arrow_back,color: Theme.of(context).primaryColor)),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.5,
        toolbarHeight: 57.h,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Center(
          child: ListView.separated(
            itemCount: widget.postcategory!.length,
            // physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => SizedBox(height: 10.h,),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, PageTransition(child: PostDetailsPage(
                    postCategoryStaticModel: widget.postcategory![index],
                  ), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400)));
                },
                child: Container(
                  height: 80.h,
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).splashColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 70.w,
                            alignment: Alignment.center,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF142D5D),
                            ),
                            child: Text("${index+1}",
                                style: getStyle14(fontWeight: FontWeight.normal,color: Colors.white),
                                textAlign: TextAlign.center),
                          ),
                          SizedBox(width: 10.w,),
                          Container(
                            // color: Colors.red,
                            // alignment: Alignment.centerLeft,
                            width: 210.w,
                            child: Text(
                              "${widget.postcategory![index].title}",
                              style: getStyle14(fontWeight: FontWeight.normal),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              // minFontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
