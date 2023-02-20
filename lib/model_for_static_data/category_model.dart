class CategoryStaticModel {
  int? id;
  String? imgUrl, title, icon;
  var type;

  CategoryStaticModel({this.id, this.imgUrl, this.title, this.icon, this.type});

  static List<CategoryStaticModel> getCategoryData() {
    return [
      CategoryStaticModel(
        id: 1,
        title: 'দলিল',
        imgUrl: '',
        type: '',
        icon: 'assets/images/category_icon/dolil.svg',
      ),
      CategoryStaticModel(
        id: 2,
        title: 'খতিয়ান/রেকর্ড/পর্চা',
        imgUrl: '',
        type: '',
        icon: 'assets/images/category_icon/khotiyan.svg',
      ),
      CategoryStaticModel(
        id: 3,
        title: 'খারিজ/নামজারি',
        imgUrl: '',
        type: '',
        icon: 'assets/images/category_icon/kharij.svg',
      ),
      CategoryStaticModel(
        id: 4,
        title: 'ভূমি কর উন্নয়ন(খাজনা)',
        imgUrl: '',
        type: '',
        icon: 'assets/images/category_icon/vumi_kor.svg',
      ),
      CategoryStaticModel(
        id: 5,
        title: 'Question and Answer',
        icon: 'assets/images/category_icon/q_a.svg',
      ),
      CategoryStaticModel(
        id: 6,
        title: 'মৌজা ম্যাপ',
        imgUrl: '',
        type: '',
        icon: 'assets/images/category_icon/mowja.svg',
      ),
      CategoryStaticModel(
        id: 7,
        title: 'আইন ও বিধি',
        imgUrl: '',
        type: '',
        icon: 'assets/images/category_icon/ine.svg',
      ),
      CategoryStaticModel(
        id: 8,
        title: 'জমিজমার অনলাইন তথ্য ভান্ডার',
        imgUrl: '',
        type: '',
        icon: 'assets/images/category_icon/info.svg',
      ),
      CategoryStaticModel(
        id: 9,
        title: 'বিধি',
        imgUrl: '',
        type: '',
        icon: 'assets/images/category_icon/bidhi.svg',
      ),
      CategoryStaticModel(
        id: 10,
        title: 'More Apps',
        icon: 'assets/images/category_icon/more_app.svg',
      ),
    ];
  }
}
