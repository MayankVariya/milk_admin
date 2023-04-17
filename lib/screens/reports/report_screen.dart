import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milk_admin_panel/comman/customer.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/customer.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';

import 'report_screen_widget.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: indigo700),
    );
    return Scaffold(
      appBar: appBar(title: labelReport),
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
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.screenWidth! * 0.02,
                vertical: SizeConfig.screenHeight! * 0.02),
            itemCount: customers.length,
            itemBuilder: (context, index) {
              return CustomerIndex(
                index: index + 1,
                trailing: const Icon(
                  icright,
                  size: 20,
                ),
                customer: customers[index],
                onClicked: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReportDetailsScreen(customer: customers[index]),
                    )),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    super.dispose();
  }
}
