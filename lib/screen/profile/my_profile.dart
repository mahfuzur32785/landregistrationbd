import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:landregistrationbdios/custom_things/btm_nav/cstm_btm_nav.dart';
import 'package:landregistrationbdios/custom_things/txt_feild/custom_textfeild.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:page_transition/page_transition.dart';

import '../../api_service/api_service.dart';
import '../../const_data/const_data.dart';
import '../../model_for_api/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.u_data, this.signupTokenData})
      : super(key: key);

  final U_Data? u_data;
  final String? signupTokenData;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  XFile? profileImage;
  String? imageUrl;
  String selected = "";
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.signupTokenData);
    nameController.text = "${widget.u_data!.name}";
    phoneController.text = "${widget.u_data!.mobile}";
    addressController.text = "${widget.u_data!.presentAddress}";
    selected = "${widget.u_data!.gender}";
    // print(selected);
  }

  imagePickerOption() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: Center(child: Text('Select an option')),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: getStyle12(color: Colors.white)
                ),
              style: TextButton.styleFrom(
                fixedSize: Size(150.w, 30.h),
                backgroundColor: Color(0xFF142D5D),
              ),
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: GestureDetector(
                      onTap: () {
                        _getFromCamera();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          color: Color(0xFFDAD9D9),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [Icon(Icons.camera_alt), Text('Camera')],
                          )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    flex: 5,
                    child: GestureDetector(
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      },
                      child: Container(
                          alignment: Alignment.center,
                          color: Color(0xFFDAD9D9),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [Icon(Icons.photo), Text('Gallery')],
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //GET IMAGE FROM GALLERY+++++++++++++++
  _getFromGallery() async {
    ImagePicker _picker = ImagePicker();
    profileImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  //GET IMAGE FROM GALLERY+++++++++++++++
  _getFromCamera() async {
    ImagePicker _picker = ImagePicker();
    profileImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        Navigator.pushAndRemoveUntil(context, PageTransition(child: CstmBtmNavBar(), type: PageTransitionType.leftToRight,duration:Duration(milliseconds: 400)), (route) => false);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Update your profile", style: getStyle16(color: Theme.of(context).primaryColor)),
          leading: IconButton(
              onPressed: () {
                //Navigator.pop(context);
                // Navigator.push(context, MaterialPageRoute(builder: (context) => CstmBtmNavBar(),)).then((value) => Navigator.pop(context));
                Navigator.pushAndRemoveUntil(context, PageTransition(child: CstmBtmNavBar(),type: PageTransitionType.leftToRight,duration: Duration(milliseconds: 400)), (route) => false);
              },
              icon: Icon(Icons.arrow_back,color: Theme.of(context).primaryColor)),
          backgroundColor: Theme.of(context).backgroundColor,
          foregroundColor: Colors.black,
          elevation: 0.5,
          toolbarHeight: 57.h,
        ),
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          blur: 2,
          progressIndicator: showSpinKitLoad(),
          child: Container(
            padding: EdgeInsets.all(25),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150.h,
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            imagePickerOption();
                          },
                          child: Center(
                              child: profileImage != null
                                  ? Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Color(0xFF006847),
                                          backgroundImage:
                                              FileImage(File(profileImage!.path)),
                                        ),
                                        Positioned(
                                          bottom: 20,
                                          right: 20,
                                          child: Icon(
                                            Icons.add_a_photo,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 60,
                                          backgroundColor: Color(0xFF006847),
                                          backgroundImage: NetworkImage(
                                              "${widget.u_data!.profileImageUrl}"),
                                        ),
                                        Positioned(
                                          bottom: 20,
                                          right: 20,
                                          child: Icon(
                                            Icons.add_a_photo,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        )
                                      ],
                                    ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                      Text(
                        "Full Name",
                        style: getStyle16(color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      CustomTextFeild(
                        controller: nameController,
                        validator: (value) {
                          if (value.toString().isEmpty || value == null) {
                            return "Enter your name";
                          }
                        },
                        isObsecure: false,
                        hintext: "Enter your name",
                        style: getStyle14(color: Colors.black),
                        fillColor: Theme.of(context).splashColor,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Mobile Number",
                        style: getStyle16(color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      CustomTextFeild(
                        controller: phoneController,
                        validator: (value) {
                          if (value.toString().isEmpty || value == null) {
                            return "Enter your phone";
                          }
                        },
                        isObsecure: false,
                        hintext: "Enter your mobile",
                        style: getStyle14(color: Colors.black),
                        fillColor: Theme.of(context).splashColor,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Gender",
                        style: getStyle16(color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = "male";
                              });
                            },
                            child: Container(
                              height: 30.h,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: selected == "male"
                                    ? Color(0xFF142D5D)
                                    : Theme.of(context).splashColor,
                              ),
                              child: Text(
                                "Male",
                                style: getStyle14(
                                    color: selected == "male"
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = "female";
                              });
                            },
                            child: Container(
                              height: 30.h,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: selected == "female"
                                    ? Color(0xFF142D5D)
                                    : Theme.of(context).splashColor,
                            ),
                              child: Text(
                                "Female",
                                style: getStyle14(
                                    color: selected == "female"
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selected = "others";
                              });
                            },
                            child: Container(
                              height: 30.h,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: selected == "others"
                                    ? Color(0xFF142D5D)
                                    : Theme.of(context).splashColor,
                              ),
                              child: Text(
                                "Others",
                                style: getStyle14(
                                    color: selected == "others"
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "Address",
                        style: getStyle16(color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      CustomTextFeild(
                        controller: addressController,
                        validator: (value) {
                          if (value.toString().isEmpty || value == null) {
                            return "Enter your address";
                          }
                        },
                        isObsecure: false,
                        hintext: "Enter your address",
                        style: getStyle14(color: Colors.black),
                        fillColor: Theme.of(context).splashColor,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());

                          if (selected != '' || selected.isNotEmpty) {
                            if (_formKey.currentState!.validate()) {
                              if (connectivityResult == ConnectivityResult.mobile ||
                                  connectivityResult == ConnectivityResult.wifi) {

                                setState(() {
                                  isLoading = true;
                                });
                                var result = await ApiHttpService()
                                    .updateProfileWithoutPicture(tokenData: widget.signupTokenData,id: widget.u_data!.sId,
                                    body: {
                                      "name": nameController.text.toString(),
                                      "mobile": int.parse(phoneController.text).toString(),
                                      "presentAddress": addressController.text.toString(),
                                      "gender": selected.toString(),
                                    });
                                var data = jsonDecode(result!.body);
                                if (result.statusCode == 200) {
                                  showInToast(
                                      msg: data['message'],
                                      toastGravity: ToastGravity.BOTTOM,
                                      color: Color(0xFF142D5D));
                                  setState(() {
                                    isLoading = false;
                                  });
                                  //Navigator.pushAndRemoveUntil(context, PageTransition(child: CstmBtmNavBar(),type: PageTransitionType.leftToRight,duration: Duration(milliseconds: 400)), (route) => false);
                                }
                                else{
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showInToast(
                                      msg: data['message'],
                                      toastGravity: ToastGravity.TOP,
                                      color: Color(0xFF142D5D));
                                }
                                //For Post A Profile Iamge+++++++++++++++
                                if(profileImage?.path==null||profileImage?.path==''){
                                  print('Img null');
                                }
                                else{
                                  print('Img not null');
                                  ApiHttpService().updateProfileWithPicture(tokenData: widget.signupTokenData, proImage: profileImage?.path);
                                }
                              } else {
                                showInToast(
                                    msg: "You are not connected with internet");
                              }
                            }
                          } else {
                            showInToast(msg: "Please select gender");
                          }
                        },
                        icon: Icon(Icons.save,color: Colors.white,),
                        label: Text(
                          "Save",
                          style: getStyle16(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(MediaQuery.of(context).size.width, 50.h),
                          backgroundColor: Color(0xFF142D5D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
