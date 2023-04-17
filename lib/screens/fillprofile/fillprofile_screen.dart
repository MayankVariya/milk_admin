import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/user.dart';
import 'package:milk_admin_panel/network/helper.dart';
import 'package:milk_admin_panel/screens/homepage/home_screen.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fillprofile_screen_widget.dart';

class AdminProfile extends StatefulWidget {
  final String uid;
  const AdminProfile({super.key, required this.uid});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  File? imageFile;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      cropImage(pickedFile);
    }
  }

  void cropImage(XFile file) async {
    File? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 20);

    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

  void showPhotoOptions() {
    showAlertDialog(context, title: labelPhotoOptionTitle, children: [
      NavListTileWidget(
          onTap: () {
            Navigator.pop(context);
            selectImage(ImageSource.gallery);
          },
          leading: const Icon(icPhotoOptionGallary),
          title: labelPhotoOptionGallary),
      NavListTileWidget(
          onTap: () {
            Navigator.pop(context);
            selectImage(ImageSource.camera);
          },
          leading: const Icon(icPhotoOptionCamera),
          title: labelPhotoOptionCamera)
    ]);
  }

  Future<String> uploadImage(File imageFile) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('profile_pics/${widget.uid}.jpg');
    final UploadTask uploadTask = storageRef.putFile(imageFile);
    final TaskSnapshot downloadUrl = (await uploadTask);
    return await downloadUrl.ref.getDownloadURL();
  }

  valueCheck() async {
    if (imageFile == null) {
      return ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          shape: RoundedRectangleBorder(),
          content: Text("Please Select Profile Image")));
    }
    if (formKey.currentState!.validate()) {
      showLoadingDialog(context, "Uploading...");

      String imageUrl = await uploadImage(imageFile!);
      int userId = int.parse(widget.uid);
      String name = fullNameController.text;
      String mobilenumber = mobileNumberController.text;
      String email = emailController.text;
      String address = addressController.text;
      String profilePic = imageUrl;
      UserModel newUser = UserModel(
          userId: userId,
          name: name,
          profilePic: profilePic,
          contactNumber: mobilenumber,
          email: email,
          address: address);
      // ignore: use_build_context_synchronously

      try {
        DocumentReference<Map<String, dynamic>> docRef =
            FirebaseFirestore.instance.collection('admin').doc('profile');
        await docRef.set(newUser.toMap());
        // print('Profile completed value updated successfully');
      } catch (e) {
        // print('Error updating profile completed value: $e');
      }
      UserModel? user = await FirebaseHelper.getUserModelByProfile();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(user: user!),
          ));
      fullNameController.clear();
      mobileNumberController.clear();
      emailController.clear();
      addressController.clear();
    }
  }

  Future<void> isCheckProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isprofilecomplited", true);
    try {
      DocumentReference<Map<String, dynamic>> docRef =
          FirebaseFirestore.instance.collection('admin').doc('auth');
      await docRef.update({'isprofilecomplited': true});
      //print('Profile completed value updated successfully');
    } catch (e) {
     // print('Error updating profile completed value: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: indigo700),
    );
    SizeConfig().init(context);
    return Scaffold(
        body: CirclesBackground(
            topMediumWidth: SizeConfig.screenWidth! * 1.8, //660,
            topMediumHight: SizeConfig.screenHeight! * 0.87, //660,
            topMediumTop: SizeConfig.screenHeight! * -0.570, //-432,
            topMediumLeft: SizeConfig.screenWidth! * -0.41, //-149,
            backgroundColor: white,
            topSmallCircleColor: indigo700,
            topMediumCircleColor: indigo700,
            topRightCircleColor: white,
            bottomRightCircleColor: white,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth! * 0.08,
                  vertical: SizeConfig.screenHeight! * 0.03),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.026,
                  ),
                  ProfileWidget(
                    imagePath: imageFile == null ? "" : imageFile!.path,
                    isEdit: true,
                    fillProfile: true,
                    onClicked: () {
                      showPhotoOptions();
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.016,
                  ),
                  buildId(int.parse(widget.uid)),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.046,
                  ),
                  Expanded(
                    child: Form(
                      key: formKey,
                      child: ListView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          TextFormFieldWidget(
                            controller: fullNameController,
                            label: labelFullName,
                            keyboardType: TextInputType.text,
                            validator: (fullName) {
                              return fullName!.isEmpty
                                  ? "Please enter FullName"
                                  : null;
                            },
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight! * 0.02,
                          ),
                          TextFormFieldWidget(
                            controller: mobileNumberController,
                            label: labelMobileNumber,
                            keyboardType: TextInputType.phone,
                            suffixIcon:
                                BtnText(onPressed: () {}, text: "Verify"),
                            validator: (mobileNumber) {
                              return validateMobile(mobileNumber!);
                            },
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight! * 0.02,
                          ),
                          TextFormFieldWidget(
                            controller: emailController,
                            label: labelEmail,
                            keyboardType: TextInputType.emailAddress,
                            validator: (email) {
                              return validateEmail(email!);
                            },
                          ),
                          SizedBox(
                            height: SizeConfig.screenHeight! * 0.02,
                          ),
                          TextFormFieldWidget(
                            controller: addressController,
                            label: labelAddress,
                            keyboardType: TextInputType.streetAddress,
                            maxLength: 150,
                            maxLines: 5,
                            validator: (address) {
                              return validateAddress(address!);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.016,
                  ),
                  SizedBox(
                    width: SizeConfig.screenWidth! * 0.5,
                    child: BtnMaterial(
                        child: const Text(
                          btnDone,
                          style: TextStyle(color: white),
                        ),
                        onPressed: () {
                          isCheckProfile();
                          valueCheck();
                        }),
                  ),
                ],
              ),
            )));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    super.dispose();
  }
}
