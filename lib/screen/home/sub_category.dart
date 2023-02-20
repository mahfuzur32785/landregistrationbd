import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:landregistrationbdios/model_for_static_data/category_model.dart';
import 'package:landregistrationbdios/model_for_static_data/post_category_model.dart';
import 'package:landregistrationbdios/screen/home/post_category.dart';
import 'package:page_transition/page_transition.dart';

import '../../const_data/const_data.dart';

class SubCategoryPage extends StatefulWidget {
  SubCategoryPage({Key? key,this.subcategoryList, this.categoryStaticModel}) : super(key: key);
  List? subcategoryList;
  CategoryStaticModel? categoryStaticModel;

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryStaticModel!.title}",style: getStyle16(color: Theme.of(context).primaryColor)),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
          // Navigator.pop(context,PageTransition(child: AddQuestionDetails(), type: PageTransitionType.leftToRight,duration: Duration(milliseconds: 400)));
        }, icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor,)),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.5,
        toolbarHeight: 57.h,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Center(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: List.generate(widget.subcategoryList!.length, (index){

              return GestureDetector(

                onTap: (){
                  var categoryId = widget.categoryStaticModel!.id;
                  var subcategoryId = widget.subcategoryList![index].id;
                  var subcategoryList = PostCategoryStaticModel.getPostCategory(categoryId: categoryId, subCategoryId: subcategoryId);

                  Navigator.push(context, PageTransition(child: PostCategoryPage(
                    subCategoryStaticModel: widget.subcategoryList![index],
                    postcategory: subcategoryList,
                  ), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400)));
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("${widget.subcategoryList![index].icon}"),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        "${widget.subcategoryList![index].title}",
                        style: getStyle14(fontWeight: FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
