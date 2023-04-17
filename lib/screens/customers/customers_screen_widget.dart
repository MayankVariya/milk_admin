import 'package:flutter/material.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';

Widget customerHeaderTitle() => Text(
      labelAddCustomer,
      style: addCustomerTextStyle(),
    );

Widget customerListTile(
    {IconData? leadingIcon,
    String titleText = "",
    VoidCallback? onClicked,
    String subTitle = "",
    bool isTreeLine = false}) {
  return ListTileWidget(
      leading: Icon(leadingIcon),
      title: titleText,
      onTap: onClicked,
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      subTitle: subTitle,
      isTreeLine: isTreeLine);
}
