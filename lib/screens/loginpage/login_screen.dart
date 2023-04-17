// ignore_for_file: unrelated_type_equality_checks
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/login.dart';
import 'package:milk_admin_panel/models/user.dart';
import 'package:milk_admin_panel/network/share_preferences.dart';
import 'package:milk_admin_panel/screens/fillprofile/fillprofile_screen.dart';
import 'package:milk_admin_panel/screens/forgot_password/forgot_password.dart';
import 'package:milk_admin_panel/screens/homepage/home_screen.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';
import 'package:provider/provider.dart';

import '../../dark_theme_provider.dart';
import 'login_screen_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obscured = true;

  Future<UserModel> _fetchUserProfile() async {
    DocumentSnapshot userProfileSnapshot = await FirebaseFirestore.instance
        .collection('admin')
        .doc('profile')
        .get();
    Map<String, dynamic> data =
        userProfileSnapshot.data() as Map<String, dynamic>;
    UserModel userProfile = UserModel.fromJson(data);

    return userProfile;
  }

  Future<void> getValue(String pass, String id) async {
    try {
      final docRef = FirebaseFirestore.instance.collection("admin").doc("auth");
      DocumentSnapshot documentSnapshot = await docRef.get();
      //print(documentSnapshot.data());
      Map data = documentSnapshot.data() as Map;
      //print(data);
      LoginModel loginModel = LoginModel.fromMap(data);
      //print(loginModel.id);
      if (data.isNotEmpty && loginModel.id != null) {
        if (id == loginModel.id && pass == loginModel.pass) {
          await saveLoginCredentials(
              loginModel.id!, loginModel.pass!, loginModel.isprofilecomplited!);
          if (loginModel.isprofilecomplited == true) {
            UserModel userProfile = await _fetchUserProfile();
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(user: userProfile),
              ),
            );
          } else {
            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminProfile(uid: id),
                ));
          }
        } else {
          // ignore: use_build_context_synchronously
          showErrorAlertDialog(
              context, "Invalid Credentials", id == loginModel.id?"Please fill correct password":"Please fill correct Admin ID");
        }
      } else {
        // ignore: use_build_context_synchronously
        showErrorAlertDialog(context, "Invalid Credentials", "No Admin found");
      }
    } catch (e) {
      showErrorAlertDialog(context, "Error fetching login credentials", "$e");
      // print(e.toString());
    }
  }

  void checkValue() async {
    String id = userIdController.text.trim();
    String pass = passwordController.text.trim();
    if (formKey.currentState!.validate()) {
      await getValue(pass, id);
      userIdController.clear();
      passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: indigo700),
    );
    SizeConfig().init(context);

    return Scaffold(
        body: CirclesBackground(
      topMediumHight: SizeConfig.screenHeight! * 0.92, //700,
      topMediumWidth: SizeConfig.screenWidth! * 1.95,
      topMediumTop: SizeConfig.screenHeight! * -0.58,
      topMediumLeft: SizeConfig.screenWidth! * -0.65, //-223,
      backgroundColor: themeChange.darkTheme ? black : white,
      topSmallCircleColor: indigo700,
      topMediumCircleColor: indigo700,
      topRightCircleColor: blue200,
      bottomRightCircleColor: themeChange.darkTheme ? black : white,
      child: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.defaultSize! * 3.5,
            vertical: SizeConfig.defaultSize! * 2.0,
          ),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ///Top Header WELCOME TO KUDOS MILK
            const HeaderText(),

            ///Center Header Login Now
            const HeaderCenter(),
            SizedBox(
              height: SizeConfig.screenHeight! * 0.015,
            ),
            TextFormFieldWidget(
                controller: userIdController,
                label: labelUserId,
                keyboardType: TextInputType.number,
                hintText: "12345 67890",
                validator: (userId) {
                  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                  RegExp regExp = RegExp(pattern);
                  if (userId == null || userId.isEmpty) {
                    return "Please Enter Admin ID";
                  } else if (!regExp.hasMatch(userId)) {
                    return 'Admin ID field must contain only numbers';
                  } else if (userId.length != 10) {
                    return 'Admin ID must be of 10 digit';
                  }
                  return null;
                }),
            SizedBox(
              height: SizeConfig.defaultSize! * 2.0,
            ),
            TextFormFieldWidget(
              controller: passwordController,
              label: labelPassword,
              obscureText: obscured,
              hintText: "*******",
              keyboardType: TextInputType.number,
              suffixIcon: BtnIcon(
                  icon: obscured ? icVisibleOff : icVisible,
                  onPressed: () {
                    setState(() {
                      obscured = !obscured;
                    });
                  }),
              validator: (pass) {
                if (pass!.isEmpty) {
                  return 'Please enter Password';
                } else if (pass.length <= 6) {
                  return "Password must be at least 6 characters long.";
                } else {
                  return null;
                }
              },
            ),
            SizedBox(
              height: SizeConfig.defaultSize! * 2.5,
            ),

            // Forgot password Task
            ForgotPasswordText(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPassword(),
                  )),
            ),
            SizedBox(
              height: SizeConfig.defaultSize! * 2.0,
            ),

            ///Login Button
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize! * 6),
              child: BtnMaterial(
                  onPressed: () {
                    checkValue();
                  },
                  child: const Text(
                    txtLogin,
                    style: TextStyle(color: white),
                  )),
            ),
          ],
        ),
      ),
    ));
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    super.dispose();
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
//   final TextEditingController _phoneNumberController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     checkCredentials();
//   }

//   void checkCredentials() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? phoneNumber = prefs.getString('phoneNumber');
//     String? password = prefs.getString('password');

//     if (phoneNumber != null && password != null) {
//       // If phone number authentication credentials are available in SharedPreferences,
//       // auto-fill the phone number field and show only the password field for login
//       _phoneNumberController.text = phoneNumber;
//       setState(() {
//         _isLoading = true;
//       });
//       signInWithPhoneNumber(phoneNumber, password);
//     }
//   }

//   void saveCredentials(String phoneNumber, String password) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('phoneNumber', phoneNumber);
//     prefs.setString('password', password);
//   }

//   void signInWithPhoneNumber(String phoneNumber, String password) async {
//     // Use Firebase phone number authentication to sign in with the provided phone number
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       ConfirmationResult confirmationResult =
//           await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
//       setState(() {
//         _isLoading = false;
//       });
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Enter verification code"),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextFormField(
//                   controller: _passwordController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: "Verification code",
//                   ),
//                 ),
//               ],
//             ),
//             actions: [
//               TextButton(
//                 child: Text("Verify"),
//                 onPressed: () async {
//                   try {
//                     UserCredential credential = await confirmationResult
//                         .confirm(_passwordController.text);
//                     saveCredentials(phoneNumber, password);
//                     if (credential.user != null) {
//                       SharedPreferences prefs =
//                           await SharedPreferences.getInstance();
//                       prefs.setBool('isFirstTimeLogin', false);
//                       Navigator.pushReplacementNamed(context, '/home');
//                     }
//                   } catch (e) {
//                     print(e.toString());
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text("Error"),
//                           content: Text(e.toString()),
//                           actions: [
//                             TextButton(
//                               child: Text("OK"),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   }
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     } catch (e) {
//       print(e.toString());
//       setState(() {
//         _isLoading = false;
//       });
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Error"),
//             content: Text(e.toString()),
//             actions: [
//               TextButton(
//                 child: Text("OK"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   void submitForm() {
//     if (_formKey.currentState!.validate()) {
//       String phoneNumber = _phoneNumberController.text.trim();
//       String password = _passwordController.text.trim();
//       signInWithPhoneNumber(phoneNumber, password);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Login"),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: _isLoading
//             ? const Center(
//                 child: CircularProgressIndicator(),
//               )
//             : Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     TextFormField(
//                       controller: _phoneNumberController,
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                           labelText: "Contact Number",
//                           suffix: SizedBox(
//                             width: 80,
//                             child: TextButton(
//                                 onPressed: () {
//                                   String phoneNumber =
//                                       _phoneNumberController.text.trim();
//                                   if (phoneNumber.isNotEmpty) {
//                                     _auth.verifyPhoneNumber(
//                                       phoneNumber: phoneNumber,
//                                       verificationCompleted:
//                                           (phoneAuthCredential) async {
//                                         await _auth.signInWithCredential(
//                                             phoneAuthCredential);
//                                       },
//                                       verificationFailed: (error) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(SnackBar(
//                                                 content:
//                                                     Text(error.toString())));
//                                       },
//                                       codeSent: (verificationId,
//                                           forceResendingToken) {
//                                         showDialog(
//                                           context: context,
//                                           builder: (context) => AlertDialog(
//                                             title: const Text(
//                                                 "Enter Verification Code"),
//                                             content: Column(
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: [
//                                                 TextFormField(
//                                                   controller:
//                                                       _passwordController,
//                                                   keyboardType:
//                                                       TextInputType.number,
//                                                   decoration:
//                                                       const InputDecoration(
//                                                     labelText:
//                                                         "Verification code",
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             actions: [
//                                               TextButton(
//                                                   onPressed: () async {
//                                                     PhoneAuthCredential
//                                                         credential =
//                                                         PhoneAuthProvider
//                                                             .credential(
//                                                       verificationId:
//                                                           verificationId,
//                                                       smsCode:
//                                                           _passwordController
//                                                               .text,
//                                                     );
//                                                     await _auth
//                                                         .signInWithCredential(
//                                                             credential);
//                                                     saveCredentials(
//                                                         phoneNumber,
//                                                         _passwordController
//                                                             .text);
//                                                     // ignore: use_build_context_synchronously
//                                                     Navigator.pop(context);
//                                                   },
//                                                   child: const Text("Verify"))
//                                             ],
//                                           ),
//                                         );
//                                       },
//                                       codeAutoRetrievalTimeout:
//                                           (verificationId) {},
//                                     );
//                                   } else {
//                                     showDialog(
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return AlertDialog(
//                                           title: const Text("Error"),
//                                           content: const Text(
//                                               "Please enter a valid phone number"),
//                                           actions: [
//                                             TextButton(
//                                               child: Text("OK"),
//                                               onPressed: () {
//                                                 Navigator.pop(context);
//                                               },
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     );
//                                   }
//                                 },
//                                 child: const Text("verify")),
//                           )),
//                     )
//                   ],
//                 )),
//       ),
//     );
//   }
// return Scaffold(
// appBar: AppBar(
// title: Text("Login"),
// ),
// body: Padding(
// padding: EdgeInsets.all(16.0),
// child: _isLoading
// ? Center(child: CircularProgressIndicator())
// : Form(
// key: _formKey,
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.stretch,
// children: [
// TextFormField(
// controller: _phoneNumberController,
// keyboardType: TextInputType.phone,
// decoration: InputDecoration(
// labelText: "Contact Number",
// suffix: SizedBox(
// width: 80.0,
// child: ElevatedButton(
// child: Text("Verify"),
// onPressed: () {
// String phoneNumber = _phoneNumberController.text.trim();
// if (phoneNumber.isNotEmpty) {
// _auth.verifyPhoneNumber(
// phoneNumber: phoneNumber,
// verificationCompleted: (PhoneAuthCredential credential) async {
// await _auth.signInWithCredential(credential);
// },
// verificationFailed: (FirebaseAuthException e) {
// print(e.message);
// showDialog(
// context: context,
// builder: (BuildContext context) {
// return AlertDialog(
// title: Text("Error"),
// content: Text(e.message),
// actions: [
// TextButton(
// child: Text("OK"),
// onPressed: () {
// Navigator.pop(context);
// },
// ),
// ],
// );
// },
// );
// },);}
// codeSent: (String verificationId, int resendToken) {
// showDialog(
// context: context,
// builder: (BuildContext context) {
// return AlertDialog(
// title: Text("Enter verification code"),
// content: Column(
// mainAxisSize: MainAxisSize.min,
// children: [
// TextFormField(
// controller: _passwordController,
// keyboardType: TextInputType.number,
// decoration: InputDecoration(
// labelText: "Verification code",
// ),
// ),
// ],
// ),
// actions: [
// TextButton(
// child: Text("Verify"),
// onPressed: () async {
// PhoneAuthCredential credential = PhoneAuthProvider.credential(
// verificationId: verificationId,
// smsCode: _passwordController.text,
// );
// await _auth.signInWithCredential(credential);
// saveCredentials(phoneNumber, _passwordController.text);
// Navigator.pop(context);
// },
// ),
// ],
// );
// },
// );
// },
// codeAutoRetrievalTimeout: (String verificationId) {},
// );
// } else {
// showDialog(
// context: context,
// builder: (BuildContext context) {
// return AlertDialog(
// title: Text("Error"),
// content: Text("Please enter a valid phone number"),
// actions: [
// TextButton(
// child: Text("OK"),
// onPressed: () {
// Navigator.pop(context);
// },
// ),
// ],
// );
// },
// );



