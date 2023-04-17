import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/customer.dart';
import 'package:milk_admin_panel/models/user.dart';
import 'package:milk_admin_panel/screens/customers/customer_screen.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';
import 'package:provider/provider.dart';

import '../../dark_theme_provider.dart';

class HomePageBodyWidget extends StatefulWidget {
  final UserModel user;
  const HomePageBodyWidget({super.key, required this.user});

  @override
  State<HomePageBodyWidget> createState() => _HomePageBodyWidgetState();
}

class _HomePageBodyWidgetState extends State<HomePageBodyWidget> {
  List<CustomerModel> customers = [];
  bool delivered = false;
  List type = ["Cow", "Bufallo"];
  double cowTotalMilk = 0;
  double buffaloTotalMilk = 0;

  bool isTimeInRange() {
    var currentTime = DateTime.now().hour;
    if (currentTime > 12) {
      return false;
    } else {
      return true;
    }
  }

  totalMilk(
    List<CustomerModel> customers,
  ) {
    cowTotalMilk = 0;
    buffaloTotalMilk = 0;

    if (isTimeInRange()) {
      //morning
      for (CustomerModel customer in customers) {
        if (customer.myproduct[0]["type"] == type[0]) {
          cowTotalMilk += customer.myproduct[0]["morningQ"];
        } else {
          buffaloTotalMilk += customer.myproduct[0]["morningQ"];
        }
      }
    } else {
      //evening
      for (CustomerModel customer in customers) {
        if (customer.myproduct[0]["type"] == type[0]) {
          cowTotalMilk += customer.myproduct[0]["eveningQ"];
        } else {
          buffaloTotalMilk += customer.myproduct[0]["eveningQ"];
        }
      }
    }
    setState(() {});
  }

  users() async {
    List<CustomerModel> customer = [];
    final ref = FirebaseFirestore.instance.collection("users").get();
    await ref.then((snapshot) {
      customer = snapshot.docs
          .map((doc) => CustomerModel.fromJson(doc.data()))
          .toList();
    });
    for (var cus in customer) {
      if (cus.myproduct.isNotEmpty) {
        customers.add(cus);
      }
    }
    totalMilk(customers);
    setState(() {});
  }

  date(String currantDate) {
    if (currantDate.length != 2) {
      return "0$currantDate";
    } else {
      return currantDate;
    }
  }

  @override
  void initState() {
    super.initState();
    users();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<DarkThemeProvider>(context);
    SizeConfig().init(context);
    return RefreshIndicator(
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
            () {
              if ((DateTime.now().hour > 1 && DateTime.now().hour < 12) ||
                  (DateTime.now().hour > 12 && DateTime.now().hour < 16)) {
                customers.clear();
                users();
              }
            },
          );
        },
        child: customers.isEmpty
            ? GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomerScreen(
                          adminName: widget.user.name.toString()),
                    )),
                child: const Center(
                  child: Text("Please Add Customer"),
                ))
            : Stack(
                children: [
                  ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth! * 0.03,
                        vertical: SizeConfig.screenHeight! * 0.02),
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ListTileWidget(
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: indigo700,
                              child: Text(
                                "${index + 1}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, color: white),
                              ),
                            ),
                            title: customers[index].cName,
                            subTitle: customers[index].cContactNumber,
                            trailing: customers[index].delivered
                                ? const Icon(Icons.done)
                                : Container(
                                    height: SizeConfig.screenHeight! * 0.065,
                                    width: SizeConfig.screenWidth! * 0.2,
                                    // color:themeChange.darkTheme?Colors.white12: white,
                                    child: Column(
                                      children: [
                                        Text(
                                          customers[index].myproduct[0]["type"],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          isTimeInRange()
                                              ? customers[index]
                                                  .myproduct[0]["morningQ"]
                                                  .toString()
                                              : customers[index]
                                                  .myproduct[0]["eveningQ"]
                                                  .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: indigo700),
                                        )
                                      ],
                                    ),
                                  ),
                            onLongPressed: () async {
                              setState(() {
                                customers[index].delivered = true;
                              });
                              String currantYear =
                                  DateTime.now().year.toString();
                              String currantMonth =
                                  DateTime.now().month.toString();
                              String currantDate =
                                  date(DateTime.now().day.toString());

                              final refDoc = FirebaseDatabase.instance
                                  .ref("AdminName/${customers[index].cid}")
                                  .child(
                                      "$currantYear/$currantMonth/$currantDate");

                              isTimeInRange()
                                  ? await refDoc.set({
                                      "Date": "$currantDate/$currantMonth",
                                      "morning": customers[index]
                                          .myproduct[0]["morningQ"]
                                          .toString(),
                                      "evening": ""
                                    })
                                  : await refDoc.update({
                                      "evening": customers[index]
                                          .myproduct[0]["eveningQ"]
                                          .toString(),
                                    });
                              // isTimeInRange()
                              //     ? await ref
                              //         .collection("data")
                              //         .doc("2023")
                              //         .collection("march")
                              //         .doc(currantDate.toString())
                              //         .set(morningMap)
                              //     : await ref
                              //     .collection("data")
                              //     .doc("2023")
                              //     .collection("march")
                              //         .doc(currantDate.toString())
                              //         .update(eveningMap);
                            }),
                      );
                    },
                  ),
                  customers.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.screenHeight! * 0.75,
                              left: SizeConfig.screenWidth! / 90,
                              right: SizeConfig.screenWidth! / 90),
                          alignment: Alignment.centerRight,
                          height: SizeConfig.screenHeight! / 10,
                          decoration: BoxDecoration(
                              color: grey,
                              borderRadius: BorderRadius.circular(25)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(labelTotalMilk, style: totalMilkTextStyle()),
                              DataTable(
                                  dividerThickness: 0,
                                  columnSpacing:
                                      MediaQuery.of(context).size.height / 35,
                                  dataRowHeight:
                                      MediaQuery.of(context).size.height / 25,
                                  headingRowHeight:
                                      MediaQuery.of(context).size.height / 30,
                                  horizontalMargin:
                                      MediaQuery.of(context).size.height / 40,
                                  headingTextStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: black),
                                  dataTextStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: indigo700),
                                  columns: type
                                      .map((types) =>
                                          DataColumn(label: Text(types)))
                                      .toList(),
                                  rows: [
                                    DataRow(cells: [
                                      DataCell(Center(
                                        child: Text(cowTotalMilk.toString()),
                                      )),
                                      DataCell(Center(
                                        child:
                                            Text(buffaloTotalMilk.toString()),
                                      ))
                                    ])
                                  ])
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ));
  }
}
