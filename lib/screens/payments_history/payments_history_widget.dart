import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/customer.dart';
import 'package:milk_admin_panel/models/monthname.dart';
import 'package:milk_admin_panel/models/payment.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';

class TransactionHistory extends StatefulWidget {
  final CustomerModel customer;
  const TransactionHistory({super.key, required this.customer});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  final collectAmountController = TextEditingController();
  double amount = 0.0;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        appBar: appBar(title: widget.customer.cName),
        body: StreamBuilder(
          stream: FirebaseDatabase.instance
              .ref("AdminName/${widget.customer.cid}/${DateTime.now().year}")
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

            List<TransactionMonthModel> transactionMonthModels = [];
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              final jsonString = json.encode(snapshot.data!.snapshot.value);
              final values = json.decode(jsonString) as Map<String, dynamic>;
              transactionMonthModels.clear();
              values.forEach((key, value) {
                List<TransactionModel> transactionModel = [];
                value.forEach(
                  (key, value) {
                    if (value != "" && key == "payment") {
                      transactionModel.add(TransactionModel(
                          title: value["title"],
                          transactionDate: value["transactionDate"],
                          isPaymentMethod: value["isPaymentMethod"],
                          isPaymentStatus: value["isPaymentStatus"],
                          transactionId: value["transactionId"]));
                    }
                    if (value != "" && key == "totalAmount") {
                      amount = double.parse(value["evening"]);
                    }
                  },
                );
                if (value != "" && value["payment"] != null) {
                  transactionMonthModels.add(TransactionMonthModel(
                      monthName: key, transactionModels: transactionModel));
                }
              });
            }

            return transactionMonthModels.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth! * 0.01,
                        vertical: SizeConfig.screenWidth! * 0.03),
                    itemCount: transactionMonthModels.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        shadowColor: indigo700,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTileWidget(
                          hPadding: SizeConfig.screenWidth! * 0.04,
                          leading: CircleAvatar(
                            child: Text("${index + 1}"),
                          ),
                          title: monthNames(int.parse(
                              transactionMonthModels[index]
                                  .monthName
                                  .toString())),
                          subTitle: (transactionMonthModels[index]
                                      .transactionModels![0]
                                      .isPaymentMethod ==
                                  "cash")
                              ? "\nDate:${transactionMonthModels[index].transactionModels![0].transactionDate}"
                              : "Tra. Id: ${transactionMonthModels[index].transactionModels![0].transactionId}"
                                  "\nDate:${transactionMonthModels[index].transactionModels![0].transactionDate} ",
                          subTitleStyle: const TextStyle(
                            fontSize: 12,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                amount.toString(),
                                style: TextStyle(
                                    color: transactionMonthModels[index]
                                                .transactionModels![0]
                                                .isPaymentStatus ==
                                            "pending"
                                        ? red
                                        : green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                transactionMonthModels[index]
                                            .transactionModels![0]
                                            .isPaymentMethod ==
                                        "cash"
                                    ? "Cash"
                                    : transactionMonthModels[index]
                                                .transactionModels![0]
                                                .isPaymentMethod ==
                                            "Online"
                                        ? "Online"
                                        : "",
                                style: TextStyle(
                                    color: transactionMonthModels[index]
                                                .transactionModels![0]
                                                .isPaymentStatus ==
                                            "pending"
                                        ? red
                                        : green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13),
                              ),
                            ],
                          ),
                          onTap: transactionMonthModels[index]
                                          .transactionModels![0]
                                          .isPaymentMethod ==
                                      "cash" &&
                                  transactionMonthModels[index]
                                          .transactionModels![0]
                                          .isPaymentStatus ==
                                      "pending"
                              ? () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      title: const Text("Collect Payment"),
                                      content: const Text(
                                          "Are You sure Collect Amount !"),
                                      actions: [
                                        const BtnCancel(),
                                        BtnText(
                                            onPressed: () async {
                                              await FirebaseDatabase.instance
                                                  .ref(
                                                      "AdminName/${widget.customer.cid}/${DateTime.now().year}/"
                                                      "${int.parse(transactionMonthModels[index].monthName.toString())}/payment")
                                                  .update({
                                                "isPaymentStatus": "done",
                                                "transactionDate":
                                                    DateFormat('dd-MM-yyyy')
                                                        .format(DateTime.now())
                                              });
                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).pop();
                                            },
                                            text: "Confirm")
                                      ],
                                    ),
                                  );
                                }
                              : null,
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text("Not Any Data Available"),
                  );
          },
        ));
  }
}
