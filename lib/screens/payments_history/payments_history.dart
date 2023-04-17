import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:milk_admin_panel/comman/customer.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/customer.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';

import 'payments_history_widget.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({
    super.key,
  });

  @override
  State<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final List<CustomerModel> customers = <CustomerModel>[];
  bool status = true;
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(title: labelPayment),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
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

          List<CustomerModel> customers = snapshot.data!.docs
              .map((doc) => CustomerModel.fromJson(doc.data()))
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            physics: const ScrollPhysics(),
            itemCount: customers.length,
            itemBuilder: (context, index) {
              return CustomerIndex(
                index: index + 1,
                customer: customers[index],
                trailing: const Icon(Icons.keyboard_arrow_right_rounded),
                
                onClicked: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionHistory(
                        customer: customers[index],
                      ),
                    )),
              );
            },
          );
        },
      ),
    );
  }


}
