import 'package:flutter/material.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/customer.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';


class CustomerIndex extends StatelessWidget {
  const CustomerIndex(
      {super.key,
      required this.customer,
      this.onClicked,
        this.index,
      required this.trailing});
  final CustomerModel customer;
  final VoidCallback? onClicked;
  final Widget? trailing;
  final int? index;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: grey300,
      elevation: 4,
      shape: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        leading: CircleAvatar(
          backgroundColor: indigo,
          radius: 20,
          child: Text(
            index.toString(),
            style: customerIdTitleTextStyle(),
          ),
        ),
        title: Text(
          customer.cName,
          style: customerNameTitleTextStyle(),
        ),
        subtitle: Text(
          customer.cContactNumber,
          style: customerMobileNumberTitleTextStyle(),
        ),
        onTap: onClicked,
        trailing: trailing,
      ),
    );
  }
}