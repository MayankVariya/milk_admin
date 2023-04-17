import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';

void handleMenuButtonPressed() {
  advancedDrawerController.showDrawer();
}

PreferredSizeWidget customAppBar(String title) => AppBar(
      elevation: 1,
      backgroundColor: indigo700,
      title: Text(
        title,
        style: appbarTitleTextStyle(),
      ),
      leading: IconButton(
        color: white,
        iconSize: 28,
        onPressed: handleMenuButtonPressed,
        icon: ValueListenableBuilder<AdvancedDrawerValue>(
          valueListenable: advancedDrawerController,
          builder: (_, value, __) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: Icon(
                value.visible ? icClear : icMenu,
                key: ValueKey<bool>(
                  value.visible,
                ),
              ),
            );
          },
        ),
      ),
    );

Widget customProfileCircle(context, String path) => Padding(
    padding: const EdgeInsets.only(
      left: 50,
      right: 50,
      top: 40,
      bottom: 20,
    ),
    child: GestureDetector(
      onTap: () {
        buildDialog(context,
            cHPadding: SizeConfig.screenWidth! * 0.01,
            cVPadding: SizeConfig.screenHeight! * 0.002,
            children: [
              Stack(
                children: [
                  Image(
                      height: SizeConfig.screenHeight! * 0.3,
                      width: SizeConfig.screenWidth! * 0.75,
                      fit: BoxFit.cover,
                      image: NetworkImage(path == ""
                          ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
                          : path)),
                  Padding(
                    padding: const EdgeInsets.only(left: 220),
                    child: BtnIcon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icons.cancel_outlined),
                  ),
                ],
              )
            ]);
      },
      child: CircleAvatar(
        radius: 65,
        backgroundColor: white,
        backgroundImage: NetworkImage(path == ""
            ? "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"
            : path),
      ),
    ));

showTable(context, List<DataColumn> columns, List<DataCell> cells,
    {double headingFontSize = 16,
    double dataFontSize = 18,
    Color? headingTitleColor}) {
  return DataTable(
      headingTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: headingFontSize,
          color: headingTitleColor ?? black),
      dataTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: dataFontSize,
          color: indigo700),
      dividerThickness: 0,
      columnSpacing: MediaQuery.of(context).size.height / 35,
      dataRowHeight: MediaQuery.of(context).size.height / 25,
      headingRowHeight: MediaQuery.of(context).size.height / 30,
      horizontalMargin: MediaQuery.of(context).size.height / 40,
      columns: columns,
      rows: [DataRow(cells: cells)]);
}
