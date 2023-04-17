import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milk_admin_panel/models/user.dart';
import 'package:milk_admin_panel/network/helper.dart';
import 'package:milk_admin_panel/screens/homepage/home_screen.dart';
import 'package:milk_admin_panel/screens/loginpage/login_screen.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  // check the user's login status using shared preferences
  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
    Timer(const Duration(seconds: 2), navigateToScreen);
  }

  // navigate to the appropriate screen based on login status
  void navigateToScreen() async {
    if (isLoggedIn == false) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    } else {
      UserModel? user = await FirebaseHelper.getUserModelByProfile();
      if(user!=null){
         // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          if (isLoggedIn) {
            return HomePage(
              user: user,
            );
          } else {
            return const LoginPage();
          }
        }),
      );
      }else{
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          )); 
      }
     
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark, statusBarColor: transparent),
    );
    return Scaffold(
      body: Stack(
        children: [
          Container(
              height: double.infinity,
              width: double.infinity,
              color: white,
              child: const Image(fit: BoxFit.cover, image: AssetImage(splash))),
          Padding(
            padding: EdgeInsets.only(
                top: SizeConfig.screenHeight! * 0.9,
                left: SizeConfig.screenWidth! * 0.45),
            child: CircularProgressIndicator(
              color: indigo700,
              strokeWidth: 3,
            ),
          ),
        ],
      ),
    );
    // return Scaffold(
    //   backgroundColor: grey100,
    //   body: Stack(
    //     children: [
    //       Positioned(
    //         top: SizeConfig.screenHeight! * -0.16, //-16,
    //         right: SizeConfig.screenWidth! * 0.7,
    //         child: CircleAvatar(
    //           radius: 135,
    //           backgroundColor: indigo700,
    //         ),
    //       ),
    //       Center(
    //         child: Image(
    //           image: const AssetImage(logo),
    //           height: SizeConfig.screenHeight! * 0.18,
    //         ),
    //       ),
    //       Positioned(
    //         bottom: SizeConfig.screenHeight! * -0.16, //-16,
    //         left: SizeConfig.screenWidth! * 0.7,
    //         child: CircleAvatar(
    //           radius: 135,
    //           backgroundColor: blue200,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    super.dispose();
  }
}
