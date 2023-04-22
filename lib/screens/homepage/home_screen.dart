import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/user.dart';
import 'package:milk_admin_panel/network/share_preferences.dart';
import 'package:milk_admin_panel/screens/customers/customer_screen.dart';
import 'package:milk_admin_panel/screens/homepage/body.dart';
import 'package:milk_admin_panel/screens/loginpage/login_screen.dart';
import 'package:milk_admin_panel/screens/products/products_screen.dart';
import 'package:milk_admin_panel/screens/reports/report_screen.dart';
import 'package:milk_admin_panel/screens/share_app.dart';
import 'package:milk_admin_panel/screens/viewprofile/viewprofile.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';
import 'package:provider/provider.dart';

import '../../dark_theme_provider.dart';
import '../payments_history/payments_history.dart';
import '../settings/settings_screen.dart';
import 'home_screen_widget.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  UserModel user;
  HomePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
     Provider.of<DarkThemeProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: indigo700),
    );
    SizeConfig().init(context);
    return AdvancedDrawer(
      backdropColor: indigo700,
      controller: advancedDrawerController,
      animationCurve: Curves.easeInOutBack,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          iconColor: white,
          textColor: white,
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            physics: const BouncingScrollPhysics(),
            children: [
              customProfileCircle(context, widget.user.profilePic!),
              Center(
                child: Text(
                  widget.user.name.toString(),
                  style: drawerUserNameTextStyle(),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.01,
              ),
              Center(
                child: Text(
                  widget.user.userId.toString(),
                  style: drawerUserIdTextStyle(),
                ),
              ),
              const Divider(
                indent: 15,
                color: white,
              ),
              NavListTileWidget(
                  leading: const Icon(icProfile),
                  title: labelProfile,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            user: widget.user,
                          ),
                        )).then((value) {
                      setState(() {
                        widget.user = value;
                      });
                    });
                  }),
              NavListTileWidget(
                  leading: const Icon(icProduct),
                  title: labelProduct,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductScreen(),
                        ));
                  }),
              NavListTileWidget(
                  leading: const Icon(icCustomer),
                  title: labelCustomer,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerScreen(
                              adminName: widget.user.name.toString()),
                        ));
                  }),
              NavListTileWidget(
                  leading: const Icon(icReport),
                  title: labelReport,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ReportScreen(),
                        ));
                  }),
              NavListTileWidget(
                  leading: const Icon(icPayment),
                  title: labelPayment,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentHistoryScreen(),
                        ));
                  }),
              NavListTileWidget(
                  leading: const Icon(icSetting),
                  title: labelSetting,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingScreen(),
                        ));
                  }),
              const Divider(
                indent: 15,
                color: white,
              ),
              NavListTileWidget(
                  leading: const Icon(icShareApp),
                  title: labelShareApp,
                  onTap: () {
                    shareApp();
                  }),
              NavListTileWidget(
                  leading: const Icon(icLogout),
                  title: labelLogout,
                  onTap: () async {
                    await removeLoginCredentials();
                    // ignore: use_build_context_synchronously
                    //  Navigator.popUntil(context, (route) => route.isFirst);
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  })
            ],
          ),
        ),
      ),
      child: Scaffold(
        appBar: customAppBar(widget.user.name.toString()),
        body: HomePageBodyWidget(user: widget.user),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    super.dispose();
  }
}

