import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/customer.dart';
import 'package:milk_admin_panel/models/monthname.dart';
import 'package:milk_admin_panel/models/report.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';
import 'package:provider/provider.dart';

import '../../dark_theme_provider.dart';

class ReportDetailsScreen extends StatefulWidget {
  const ReportDetailsScreen({
    super.key,
    required this.customer,
  });
  final CustomerModel customer;

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  String currantYear = DateTime.now().year.toString();
  String currantMonth = DateTime.now().month.toString();
  List headerTable = ["Date", "Morning", "Evening"];

  int selectedMonth = 0;
  double totalPrice = 0;

  List<String> month = [];

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: appBar(title: widget.customer.cName, actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(
              icon: const Icon(icFilter),
              onPressed: () {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.screenHeight! * 0.025,
                          horizontal: SizeConfig.screenWidth! * 0.02),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                labelSelectMonth,
                                style: selectMonthTextStyle(),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: DropdownButton<int>(
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(10),
                                  value: selectedMonth,
                                  hint: Text(labelSelectMilkType),
                                  items: List.generate(
                                      month.length,
                                      (index) => DropdownMenuItem(
                                          value: index,
                                          child: Text(month[index]))),
                                  onChanged: (int? newValue) {
                                    setState(
                                      () {
                                        selectedMonth = newValue!;
                                      },
                                    );
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
        )
      ]),
      body: StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref("AdminName/${widget.customer.cid}/$currantYear")
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<MonthDataModel> months = [];

          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data!.snapshot.value != null) {
              final jsonString = json.encode(snapshot.data!.snapshot.value);
              final values = json.decode(jsonString) as Map<String, dynamic>;

              month.clear();

              values.forEach((key, value) {
                List<DateData> dates = [];
                value.forEach(
                  (key, value) {
                    if (value != "") {
                      if (value != "" &&
                          key != "totalMilk" &&
                          key != "totalAmount" &&
                          key != "payment") {
                        dates.add(DateData(
                            day: value["Date"].toString(),
                            morning: value["morning"].toString(),
                            evening: value["evening"].toString()));
                        dates.sort(
                          (a, b) => a.day!.compareTo(b.day.toString()),
                        );
                      }
                    }
                  },
                );
                if (value["totalMilk"] != null) {
                  dates.insert(
                      dates.length,
                      DateData(
                          day: value["totalMilk"]["Date"].toString(),
                          morning: value["totalMilk"]["morning"].toString(),
                          evening: value["totalMilk"]["evening"].toString()));
                }
                if (value["totalAmount"] != null) {
                  dates.insert(
                      dates.length,
                      DateData(
                          day: value["totalAmount"]["Date"].toString(),
                          morning: value["totalAmount"]["morning"].toString(),
                          evening: value["totalAmount"]["evening"].toString()));
                }
                if (value["payment"] != null) {
                  dates.insert(
                      dates.length,
                      DateData(
                          day: value["payment"]["title"].toString(),
                          morning:
                              value["payment"]["isPaymentMethod"].toString(),
                          evening:
                              value["payment"]["isPaymentStatus"].toString()));
                }
                if (value != "") {
                  month.add(monthNames(int.parse(key)));
                  months.add(MonthDataModel(
                      monthName: monthNames(int.parse(key)), dates: dates));
                }
              });
            } else {
              return const Center(
                child: Text("Not Any Data"),
              );
            }
          }

          return months.isNotEmpty
              ? SafeArea(
                  child: ListView(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth! * 0.07,
                      vertical: SizeConfig.screenHeight! * 0.02),
                  children: [
                    Text.rich(TextSpan(children: [
                      TextSpan(
                          text: labelCurrentData,
                          style: TextStyle(
                              fontWeight: bold,
                              color: themeChange.darkTheme ? grey700 : black,
                              fontSize: 16)),
                      TextSpan(
                          text: "${months[selectedMonth].monthName}/2023",
                          style: TextStyle(
                              fontWeight: bold,
                              color: themeChange.darkTheme ? white : indigo700,
                              fontSize: 16)),
                    ])),
                    const SizedBox(
                      height: 5,
                    ),
                    DataTable(
                        dataRowHeight: SizeConfig.screenHeight! * 0.05,
                        showBottomBorder: true,
                        headingRowColor: MaterialStateProperty.all(indigo700),
                        headingTextStyle: const TextStyle(
                            color: white, fontWeight: FontWeight.bold),
                        columnSpacing: 30,
                        columns: const [
                          DataColumn(label: Text("Date")),
                          DataColumn(label: Text("Morning")),
                          DataColumn(label: Text("Evening")),
                        ],
                        rows: List.generate(
                            months[selectedMonth].dates!.length,
                            (index) => DataRow(
                                    color: themeChange.darkTheme
                                        ? (MaterialStateColor.resolveWith((states) =>
                                            (months[selectedMonth].dates![index].day ==
                                                        "TotalMilk") ||
                                                    (months[selectedMonth].dates![index].day ==
                                                        "TotalAmount")
                                                ? Colors.white12
                                                : black))
                                        : (MaterialStateColor.resolveWith((states) =>
                                            (months[selectedMonth].dates![index].day ==
                                                        "TotalMilk") ||
                                                    (months[selectedMonth].dates![index].day ==
                                                        "TotalAmount")
                                                ? grey300
                                                : white)),
                                    cells: [
                                      DataCell(
                                        Text(
                                          months[selectedMonth]
                                                  .dates![index]
                                                  .day ??
                                              "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: themeChange.darkTheme
                                                ? ((months[selectedMonth]
                                                                .dates![index]
                                                                .day ==
                                                            "TotalMilk") ||
                                                        (months[selectedMonth]
                                                                .dates![index]
                                                                .day ==
                                                            "TotalAmount")
                                                    ? indigo700
                                                    : white)
                                                : ((months[selectedMonth]
                                                                .dates![index]
                                                                .day ==
                                                            "TotalMilk") ||
                                                        (months[selectedMonth]
                                                                .dates![index]
                                                                .day ==
                                                            "TotalAmount")
                                                    ? indigo700
                                                    : black),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Center(
                                          child: Text(
                                            months[selectedMonth]
                                                    .dates![index]
                                                    .morning ??
                                                "",
                                            style: TextStyle(
                                                color: themeChange.darkTheme
                                                    ? ((months[selectedMonth].dates![index].day ==
                                                                "TotalMilk") ||
                                                            (months[selectedMonth].dates![index].day ==
                                                                "TotalAmount")
                                                        ? indigo700
                                                        : white)
                                                    : ((months[selectedMonth].dates![index].day ==
                                                                "TotalMilk") ||
                                                            (months[selectedMonth]
                                                                    .dates![
                                                                        index]
                                                                    .day ==
                                                                "TotalAmount")
                                                        ? indigo700
                                                        : black),
                                                fontWeight: (months[selectedMonth]
                                                                .dates![index]
                                                                .day ==
                                                            "TotalMilk") ||
                                                        (months[selectedMonth]
                                                                .dates![index]
                                                                .day ==
                                                            "TotalAmount")
                                                    ? FontWeight.bold
                                                    : FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                      DataCell(Center(
                                          child: Text(
                                              months[selectedMonth]
                                                      .dates![index]
                                                      .evening ??
                                                  "",
                                              style: TextStyle(
                                                  color: themeChange.darkTheme
                                                      ? ((months[selectedMonth].dates![index].day ==
                                                                  "TotalMilk") ||
                                                              (months[selectedMonth].dates![index].day ==
                                                                  "TotalAmount")
                                                          ? indigo700
                                                          : (months[selectedMonth].dates![index].evening ==
                                                                  "pending")
                                                              ? red
                                                              : white)
                                                      : ((months[selectedMonth].dates![index].day ==
                                                                  "TotalMilk") ||
                                                              (months[selectedMonth].dates![index].day ==
                                                                  "TotalAmount")
                                                          ? indigo700
                                                          : (months[selectedMonth]
                                                                      .dates![
                                                                          index]
                                                                      .evening ==
                                                                  "pending")
                                                              ? red
                                                              : black),
                                                  fontWeight: (months[selectedMonth]
                                                                  .dates![index]
                                                                  .day ==
                                                              "TotalMilk") ||
                                                          (months[selectedMonth]
                                                                  .dates![index]
                                                                  .day ==
                                                              "TotalAmount")
                                                      ? FontWeight.bold
                                                      : FontWeight.normal))))
                                    ]))),
                  ],
                ))
              : const Center(
                  child: Text("Not Any Data"),
                );
        },
      ),
    );
  }
}
