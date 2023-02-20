class SubCategoryStaticModel{
  int? id,c_id;
  String? imgUrl, title, icon;

  SubCategoryStaticModel({this.id, this.imgUrl, this.title, this.icon, this.c_id});

  static List<SubCategoryStaticModel> getSubCategoryData() {
    return [
      SubCategoryStaticModel(id: 1, c_id: 1, title: 'দলিল রেজিস্ট্রি পদ্ধতি', imgUrl: '', icon: 'assets/images/category_icon/dolil.svg'),
      SubCategoryStaticModel(id: 2, c_id: 1, title: 'দলিল রেজিস্ট্রি ফি, কর ও শুল্ক', imgUrl: '', icon: 'assets/images/category_icon/dolil.svg'),
      SubCategoryStaticModel(id: 3,  c_id: 1, title: 'দলিলের ফরমেট', imgUrl: '', icon: 'assets/images/category_icon/dolil.svg'),
      SubCategoryStaticModel(id: 4, c_id: 1, title: 'দলিলের নকল তল্লাশ', imgUrl: '', icon: 'assets/images/category_icon/dolil.svg'),
      SubCategoryStaticModel(id: 5, c_id: 1, title: 'ভূমি/প্লট ক্রয়ের আগে ও পরে করনীয়', imgUrl: '', icon: 'assets/images/category_icon/dolil.svg'),

      SubCategoryStaticModel(id: 1, c_id: 7, title: 'আইন', imgUrl: '', icon: 'assets/images/category_icon/ine.svg'),
      SubCategoryStaticModel(id: 2, c_id: 7, title: 'বিধিমালা', imgUrl: '', icon: 'assets/images/category_icon/ine.svg'),

      SubCategoryStaticModel(id: 1, c_id: 9, title: 'সম্পত্তির উত্তরাধিকারের নিয়ম', imgUrl: '', icon: 'assets/images/category_icon/dolil.svg'),
      SubCategoryStaticModel(id: 2, c_id: 9, title: 'জমির পরিমাপ পদ্ধতি', imgUrl: '', icon: 'assets/images/category_icon/dolil.svg'),
      SubCategoryStaticModel(id: 3,  c_id: 9, title: 'গুরুত্বপূর্ণ শব্দের ব্যাখ্যা', imgUrl: '', icon: 'assets/images/category_icon/dolil.svg'),
      SubCategoryStaticModel(id: 4, c_id: 9, title: 'জমি-জমার মামলা-মোকদ্দমা', imgUrl: '', icon: 'assets/images/category_icon/dolil.svg'),
      SubCategoryStaticModel(id: 5, c_id: 9, title: 'প্রিএমশন', imgUrl: '', icon: 'assets/images/category_icon/dolil.svg'),
    ];
  }
  static List<SubCategoryStaticModel>? getSubCategory(categoryId){
    return getSubCategoryData().where((element) => element.c_id == categoryId).toList();
  }
}