import 'package:flutter/cupertino.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';

const FontWeight bold = FontWeight.bold;

/// AppBar
TextStyle appBarTitleTextStyle() =>
    const TextStyle(color: white, fontWeight: bold, fontSize: 17);

/// Login Page
TextStyle headerTextStyle() =>
    const TextStyle(fontSize: 25, fontWeight: bold, color: white);

TextStyle headerAppNameTextStyle() =>
    TextStyle(fontSize: 25, fontWeight: bold, color: blue200);

TextStyle forgotPasswordTextStyle() => const TextStyle(fontWeight: bold);

TextStyle headerLoginNowTextStyle() =>
    const TextStyle(fontSize: 30, color: white);

/// Forgot Password Page
TextStyle dropDownItemsTextStyle() => const TextStyle(fontWeight: bold);

TextStyle btnSubmitTextStyle() => const TextStyle(color: white);

TextStyle buildUserIdTextStyle() =>
    const TextStyle(fontSize: 16, fontWeight: bold);

TextStyle buildForgotPasswordHeadLine() =>
    TextStyle(fontWeight: bold, fontSize: 17, color: grey700);
TextStyle buildForgotPasswordHeader() =>
    const TextStyle(color: white, fontSize: 30, fontWeight: bold);

/// Home Page
TextStyle appbarTitleTextStyle() => const TextStyle(color: white,fontSize: 19,fontWeight: FontWeight.bold);

TextStyle drawerUserNameTextStyle() =>
    const TextStyle(fontSize: 20, color: white);

TextStyle drawerUserIdTextStyle() =>
    const TextStyle(color: white54, fontSize: 14);

TextStyle totalMilkTextStyle() =>
    const TextStyle(fontWeight: bold, fontSize: 20, color: white);

///profile
TextStyle userIdTextStyle() =>
    const TextStyle(color: black, fontSize: 14, fontWeight: bold);

/// product page
TextStyle productIdTextStyle() =>
    const TextStyle(color: white, fontWeight: bold, fontSize: 18);

TextStyle productNameTextStyle() =>
    const TextStyle(fontWeight: bold, fontSize: 17);

TextStyle productPriceTextStyle() =>
    const TextStyle(color: grey, fontWeight: bold);

TextStyle addProductHeaderTextStyle() =>
    const TextStyle(fontWeight: bold, fontSize: 20);

TextStyle priceLabelTextStyle() =>
    const TextStyle(fontSize: 18, fontWeight: bold);

TextStyle perLtrTextStyle() => const TextStyle(fontSize: 13);

TextStyle typeLabelTextStyle() =>
    const TextStyle(fontSize: 18, fontWeight: bold);

/// customer page
TextStyle addCustomerTextStyle() =>
    const TextStyle(fontSize: 20, fontWeight: bold);

TextStyle customerNameTextStyle() =>
    const TextStyle(fontSize: 16, fontWeight: bold);

/// report page
TextStyle selectMonthTextStyle() =>
    const TextStyle(fontWeight: bold, fontSize: 15);

TextStyle currentDataTextStyle() => const TextStyle(fontWeight: bold,fontSize: 16);

TextStyle currentMonthTextStyle() =>
    TextStyle(fontWeight: bold, color: indigo700, fontSize: 16);

TextStyle tableHeadingTextStyle() =>
    const TextStyle(color: white, fontWeight: bold);

TextStyle tableDateTextStyle() => const TextStyle(fontWeight: bold);

///Customer list
TextStyle customerIdTitleTextStyle() =>
    const TextStyle(color: white, fontWeight: bold, fontSize: 16);

TextStyle customerNameTitleTextStyle() =>
    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17);

TextStyle customerMobileNumberTitleTextStyle() =>
    const TextStyle(color: grey, fontWeight: bold);
