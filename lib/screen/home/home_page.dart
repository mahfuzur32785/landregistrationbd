import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:landregistrationbdios/const_data/const_data.dart';
import 'package:landregistrationbdios/screen/home/post_category.dart';
import 'package:landregistrationbdios/screen/home/sub_category.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model_for_static_data/category_model.dart';
import '../../model_for_static_data/post_category_model.dart';
import '../../model_for_static_data/sub_category_model.dart';
import '../add_question/all_question.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final List<CategoryStaticModel> categoryList =
      CategoryStaticModel.getCategoryData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Center(
          child: GridView.custom(
            shrinkWrap: true,
            gridDelegate: SliverQuiltedGridDelegate(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              pattern: [
                QuiltedGridTile(1, 1),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(1, 1),
                QuiltedGridTile(1, 2),
              ],
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
                if(index == 4){
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageTransition(child: AddQuestionPage(), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400)));
                    },
                    child: Container(
                      //padding: EdgeInsets.only(left: 10,right: 10,top: 25),
                      decoration: BoxDecoration(
                        color: Color(0xFF142D5D),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("${categoryList[index].icon}"),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "${categoryList[index].title}",
                            style: getStyle14(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if(index == 9){
                  return GestureDetector(
                    onTap: () async {
                      final Uri url = Uri.parse("https://play.google.com/store/search?q=com.landregistration&c=apps");
                      launchUrl(url);
                    },
                    child: Container(
                      //padding: EdgeInsets.only(left: 10,right: 10,top: 25),
                      decoration: BoxDecoration(
                        color: Color(0xFF142D5D),
                        borderRadius: BorderRadius.circular(20),

                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset("${categoryList[index].icon}"),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "${categoryList[index].title}",
                            style: getStyle12(fontWeight: FontWeight.normal, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: (){
                    var categoryId = categoryList[index].id;
                    var subcategoryList = SubCategoryStaticModel.getSubCategory(categoryId);

                    if(subcategoryList!.isNotEmpty||subcategoryList.length!=0){
                      Navigator.push(context, PageTransition(child: SubCategoryPage(
                        subcategoryList: subcategoryList,
                        categoryStaticModel: categoryList[index],
                      ), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400)));
                    }
                    else if(subcategoryList.isEmpty||subcategoryList.length==0){
                      var categoryId = categoryList[index].id;
                      var subcategoryList = PostCategoryStaticModel.getPostCategory(categoryId: categoryId);

                      Navigator.push(context, PageTransition(child: PostCategoryPage(
                        //subCategoryStaticModel: subcategoryList![index],
                        postcategory: subcategoryList,
                        categoryStaticModel: categoryList[index],
                      ), type: PageTransitionType.rightToLeft,duration: Duration(milliseconds: 400)));
                    }
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
                        SvgPicture.asset("${categoryList[index].icon}"),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          "${categoryList[index].title}",
                          style: getStyle14(fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: categoryList.length
            ),
          ),
        ),
      ),
    );
  }
}