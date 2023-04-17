import 'package:flutter/material.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize! * 2.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(TextSpan(children: [
              TextSpan(text: txtLoginHader, style: headerTextStyle()),
              TextSpan(text: appName, style: headerAppNameTextStyle())
            ])),
          ],
        ),
      ),
    );
  }
}

class HeaderCenter extends StatelessWidget {
  const HeaderCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize! * 5.5),
      child: Text(
        txtLogin,
        style: headerLoginNowTextStyle(),
      ),
    );
  }
}

class ForgotPasswordText extends StatelessWidget {
  final VoidCallback? onTap;
  const ForgotPasswordText({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Align(
          alignment: Alignment.centerRight,
          child: Text(
            forgotPass,
            style: forgotPasswordTextStyle(),
          )),
    );
  }
}
