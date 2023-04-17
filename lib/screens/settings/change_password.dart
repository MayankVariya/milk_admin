import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/login.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final changeOldPassController = TextEditingController();
  final changeNewPassController = TextEditingController();
  final changeConfirmPassController = TextEditingController();
  bool obscuredOldPass = true;
  bool obscuredNewPass = true;
  bool obscuredConfrimPass = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: labelChangePassword),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          children: [
            TextFormFieldWidget(
              label: labelEnterOldPassword,
              obscureText: obscuredOldPass,
              controller: changeOldPassController,
              keyboardType: TextInputType.number,
              validator: (oldPass) {
                if (oldPass!.isEmpty) {
                  return "Please Enter Password";
                }
                return null;
              },
              suffixIcon: BtnIcon(
                  icon: obscuredOldPass ? icVisibleOff : icVisible,
                  onPressed: () {
                    setState(() {
                      obscuredOldPass = !obscuredOldPass;
                    });
                  }),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormFieldWidget(
              label: labelNewPassword,
              obscureText: obscuredNewPass,
              controller: changeNewPassController,
              keyboardType: TextInputType.number,
              validator: (newPass) {
                if (newPass!.isEmpty) {
                  return "Please Enter Password";
                } else if (newPass.length <= 6) {
                  return "Please Enter more than 6 character Password";
                }
                return null;
              },
              suffixIcon: BtnIcon(
                  icon: obscuredNewPass ? icVisibleOff : icVisible,
                  onPressed: () {
                    setState(() {
                      obscuredNewPass = !obscuredNewPass;
                    });
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormFieldWidget(
              label: labelConfirmPassword,
              obscureText: obscuredConfrimPass,
              controller: changeConfirmPassController,
              keyboardType: TextInputType.number,
              validator: (oldPass) {
                if (oldPass!.isEmpty) {
                  return "Please Enter Password";
                }
                return null;
              },
              suffixIcon: BtnIcon(
                  icon: obscuredConfrimPass ? icVisibleOff : icVisible,
                  onPressed: () {
                    setState(() {
                      obscuredConfrimPass = !obscuredConfrimPass;
                    });
                  }),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth! * 0.1),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: indigo700,
                height: 45,
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final docRef = FirebaseFirestore.instance
                        .collection("admin")
                        .doc("auth");
                    DocumentSnapshot snapshot = await docRef.get();
                    if (snapshot.exists) {
                      final jsonString = json.encode(snapshot.data());
                      final values =
                          json.decode(jsonString) as Map<String, dynamic>;
                      LoginModel loginModel = LoginModel.fromMap(values);
                      if (changeOldPassController.text == loginModel.pass) {
                        if (changeNewPassController.text != loginModel.pass) {
                          if (changeNewPassController.text ==
                              changeConfirmPassController.text) {
                            await FirebaseFirestore.instance
                                .collection("admin")
                                .doc("auth")
                                .update({
                              "pass": changeConfirmPassController.text.trim()
                            });
                            changeOldPassController.clear;
                            changeNewPassController.clear();
                            changeConfirmPassController.clear();
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      title: const Text("Succsess"),
                                      content: const Text(
                                          "Password SuccsessFully Changed"),
                                      actions: [
                                        BtnText(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.of(context).pop();
                                            },
                                            text: "OK")
                                      ],
                                    ));
                          } else {
                            // ignore: use_build_context_synchronously
                            showErrorAlertDialog(
                                context, "Error", "Please Enter Same Password");
                          }
                        } else {
                          // ignore: use_build_context_synchronously
                          showErrorAlertDialog(context, "Error",
                              "Please Enter different Password");
                        }
                      } else {
                        // ignore: use_build_context_synchronously
                        showErrorAlertDialog(context, "Error",
                            "Please Enter valid Old Password");
                      }
                    }
                  }
                },
                child: const Text(
                  "Change Password",
                  style: TextStyle(color: white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:milk_admin_panel/comman/appbars.dart';
// import 'package:milk_admin_panel/comman/buttons.dart';
// import 'package:milk_admin_panel/comman/text_form_fields.dart';
// import 'package:milk_admin_panel/utils/icons.dart';
// import 'package:milk_admin_panel/utils/strings.dart';

// class ChangePassword extends StatefulWidget {
//   const ChangePassword({super.key});

//   @override
//   State<ChangePassword> createState() => _ChangePasswordState();
// }

// class _ChangePasswordState extends State<ChangePassword> {
//   bool obscured = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: appBar(title: labelChangePassword),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
//         children: [
//           textFormFieldWidget(
//             label: labelEnterOldPassword,
//             obscureText: obscured,
//             suffixIcon: buildIconButton(
//                 icon: obscured ? icVisibleOff : icVisible,
//                 onClicked: () {
//                   setState(() {
//                     obscured = !obscured;
//                   });
//                 }),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           textFormFieldWidget(
//             label: labelNewPassword,
//             obscureText: obscured,
//             suffixIcon: buildIconButton(
//                 icon: obscured ? icVisibleOff : icVisible,
//                 onClicked: () {
//                   setState(() {
//                     obscured = !obscured;
//                   });
//                 }),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           textFormFieldWidget(
//             label: labelConfirmPassword,
//             obscureText: obscured,
//             suffixIcon: buildIconButton(
//                 icon: obscured ? icVisibleOff : icVisible,
//                 onClicked: () {
//                   setState(() {
//                     obscured = !obscured;
//                   });
//                 }),
//           ),
//           const SizedBox(
//             height: 15,
//           ),
//           buildElevetedButton(
//               horizontalPadding: MediaQuery.of(context).size.width / 8,
//               text: btnChange,
//               onClicked: (() {})),
//         ],
//       ),
//     );
//   }
// }
