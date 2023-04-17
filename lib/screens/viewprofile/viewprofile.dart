import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/user.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';
import 'package:provider/provider.dart';

import '../../dark_theme_provider.dart';
import 'viewprofile_screen_widget.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    super.key,
    required this.user,
  });
  final UserModel user;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? imageFile;
  String imageUrl = "";

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
      // Upload image to Firebase Storage

      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_pics/${widget.user.userId}.jpg');

      TaskSnapshot task = await storageRef.putFile(croppedImage);

      imageUrl = await task.ref.getDownloadURL();

      setState(() {
        imageFile = croppedImage;
        widget.user.profilePic = imageUrl;
      });
    }
  }

  void showPhotoOptions() {
    showAlertDialog(context,
        barrierDismissible: true,
        title: labelPhotoOptionTitle,
        children: [
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

  Future<void> updateUser(key, value) async {
    await FirebaseFirestore.instance
        .collection("admin")
        .doc("profile")
        .update({key: value});
  }

  @override
  Widget build(BuildContext context) {
    final themeChange= Provider.of<DarkThemeProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: indigo700),
    );
    SizeConfig().init(context);

    return Scaffold(
      body: CirclesBackground(
        topMediumWidth: SizeConfig.screenWidth! * 1.76, //660,
        topMediumHight: SizeConfig.screenHeight! * 0.87, //660,
        topMediumTop: SizeConfig.screenHeight! * -0.570, //-432,
        topMediumLeft: SizeConfig.screenWidth! * -0.41, //-149,
        backgroundColor: themeChange.darkTheme?black:white,
        topSmallCircleColor: indigo700,
        topMediumCircleColor: indigo700,
        topRightCircleColor:  themeChange.darkTheme?black:white,
        bottomRightCircleColor: themeChange.darkTheme?black:white,
        child: ListView(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.06),
          children: [
            const SizedBox(
              height: 10,
            ),
            buildBackButton(context, icon: icBack, backButton: () {
              Navigator.of(context).pop(widget.user);
            }),
            Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.screenHeight! * 0.02,
                  bottom: SizeConfig.screenHeight! * 0.03),
              child: ProfileWidgets(
                imagePath: widget.user.profilePic!.isEmpty
                    ? ""
                    : widget.user.profilePic.toString(),
                fillProfile: false,
                onClicked: () {
                  showPhotoOptions();
                },
              ),
            ),
            Center(
              child: Text(
                widget.user.userId.toString(),
                style: userIdTextStyle(),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.016,
            ),
            ListTileWidget(
              leading: const Icon(icperson),
              title: labelFullName,
              titleStyle: const TextStyle(fontWeight: FontWeight.bold),
              subTitle: widget.user.name,
              onTap: () {
                showEditDialog(
                  context,
                  formKey: formKey,
                  children: [
                    TextFormFieldWidget(
                      label: labelEditName,
                      autoFocus: true,
                      controller: editNameController,
                      validator: (name) {
                        return name!.isEmpty ? "Please enter FullName" : null;
                      },
                    )
                  ],
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        widget.user.name = editNameController.text;
                      });
                      Navigator.of(context).pop();
                      updateUser("name", editNameController.text);
                      editNameController.clear();
                    }
                  },
                );
              },
              trailing: Icon(
                icEdit,
                color: themeChange.darkTheme? Colors.white70:indigo700,
              ),
            ),
            ListTileWidget(
                leading: const Icon(icPhone),
                title: labelMobileNumber,
                titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                subTitle: widget.user.contactNumber.toString(),
                onTap: () {
                  showEditDialog(
                    context,
                    formKey: formKey,
                    children: [
                      TextFormFieldWidget(
                        label: labelEditMobile,
                        autoFocus: true,
                        controller: editContactNumberController,
                        validator: (mobileNumber) {
                          return validateMobile(mobileNumber!);
                        },
                      )
                    ],
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          widget.user.contactNumber =
                              editContactNumberController.text;
                        });
                        Navigator.of(context).pop();
                        updateUser(
                            "contactNumber", editContactNumberController.text);
                        editContactNumberController.clear();
                      }
                    },
                  );
                },
                trailing: Icon(
                  icEdit,
                  color: themeChange.darkTheme? Colors.white70:indigo700,
                )),
            ListTileWidget(
              leading: const Icon(icEmail),
              title: labelEmail,
              titleStyle: const TextStyle(fontWeight: FontWeight.bold),
              subTitle: widget.user.email,
              trailing: Icon(
                icEdit,
                color: themeChange.darkTheme? Colors.white70:indigo700,
              ),
              onTap: () {
                showEditDialog(
                  context,
                  formKey: formKey,
                  children: [
                    TextFormFieldWidget(
                      label: labelEditEmail,
                      autoFocus: true,
                      controller: editEmailController,
                      validator: (email) {
                        return validateEmail(email!);
                      },
                    )
                  ],
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        widget.user.email = editEmailController.text;
                      });
                      Navigator.of(context).pop();
                      updateUser("email", editEmailController.text);
                      editEmailController.clear();
                    }
                  },
                );
              },
            ),
            ListTileWidget(
              leading: const Icon(icAddress),
              title: labelAddress,
              titleStyle: const TextStyle(fontWeight: FontWeight.bold),
              subTitle: widget.user.address,
              isTreeLine: true,
              trailing: Icon(
                icEdit,
                color: themeChange.darkTheme? Colors.white70:indigo700,
              ),
              onTap: () {
                showEditDialog(
                  context,
                  formKey: formKey,
                  children: [
                    TextFormFieldWidget(
                      label: labelEditAddress,
                      autoFocus: true,
                      maxLines: 4,
                      controller: editAddressroller,
                      validator: (address) {
                        return validateAddress(address!);
                      },
                    )
                  ],
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        widget.user.address = editAddressroller.text;
                      });
                      Navigator.of(context).pop();
                      updateUser("address", editAddressroller.text);
                      editAddressroller.clear();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Reset the status bar color when the widget is disposed
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    super.dispose();
  }
}
