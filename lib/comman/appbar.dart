import 'package:flutter/material.dart';
import 'package:milk_admin_panel/comman/styles.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';

PreferredSizeWidget appBar({String title = "", List<Widget>? actions}) =>
    AppBar(
      title: Text(title),
      
      titleTextStyle: appBarTitleTextStyle(),
      backgroundColor: indigo700,
      iconTheme: const IconThemeData(color: white),
      elevation: 1,
      actions: actions,
    );
