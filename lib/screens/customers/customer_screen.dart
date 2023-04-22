import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/main.dart';
import 'package:milk_admin_panel/models/customer.dart';
import 'package:milk_admin_panel/screens/customers/customers_screen_widget.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';
import 'package:share_plus/share_plus.dart';

class CustomerScreen extends StatefulWidget {
  final String adminName;
  const CustomerScreen({super.key, required this.adminName});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final CollectionReference customerCollection =
      FirebaseFirestore.instance.collection("users");

  Future<void> addCustomer(
      String cName, String cMobilenumber, cEmail, cAddress, cid) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("cContactNumber", isEqualTo: cMobilenumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Text("Error"),
            content: const Text("Customer Already exists"),
            actions: [
              BtnText(onPressed: () => Navigator.of(context).pop(), text: "OK")
            ],
          ),
        );
      } else {
        CustomerModel customer = CustomerModel(
            id: cMobilenumber,
            pass: cMobilenumber,
            cid: cid,
            cName: cName,
            cProfilePic: "",
            cContactNumber: cMobilenumber,
            cEmail: cEmail,
            myproduct: [],
            delivered: false,
            useNotDeleted: false,
            verified: false,
            cAddress: cAddress);
        final customerRef = customerCollection.doc(cid);

        ///add profile details
        await customerRef.set(customer.toMap());
      }
    } catch (e) {
      showErrorAlertDialog(context, "Error", "$e");
    }
  }

  checkValue() async {
    String cid = uuid.v1();
    String cName = customerNameController.text.trim();
    String cMobileNumber = customerMobileNumberController.text.trim();
    String cEmail = customerEmailIDController.text.trim();
    String cAddress = customerAddressController.text.trim();

    if (formKey.currentState!.validate()) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection("users")
            .where("cContactNumber", isEqualTo: cMobileNumber)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              title: const Text("Error"),
              content: const Text("Customer Already exists"),
              actions: [
                BtnText(onPressed: () => Navigator.of(context).pop(), text: "OK")
              ],
            ),
          );
        } else {
          CustomerModel customer = CustomerModel(
              id: cMobileNumber,
              pass: cMobileNumber,
              cid: cid,
              cName: cName,
              cProfilePic: "",
              cContactNumber: cMobileNumber,
              cEmail: cEmail,
              myproduct: [],
              delivered: false,
              useNotDeleted: false,
              verified: false,
              cAddress: cAddress);
          final customerRef = customerCollection.doc(cid);

          ///add profile details
          await customerRef.set(customer.toMap());

          // ignore: use_build_context_synchronously
          Navigator.of(context).pop();
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Customer Successfully Created"),
          ));
          showDialog(
            context: context,
            builder: (context) => Dialog(
              insetPadding:
              EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth! * 0.06),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                        color: indigo700,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Share the userName and password\n with the Customer",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, color: white),
                        ),
                        BtnIcon(
                            iconColor: white,
                            onPressed: () => Navigator.of(context).pop(),
                            icon: Icons.close)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.002,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.screenWidth! * 0.05,
                        vertical: SizeConfig.screenHeight! * 0.02),
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: widget.adminName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(
                        text: " has created your account in ",
                      ),
                      const TextSpan(
                          text: "$appName.",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(
                        text: "The username : ",
                      ),
                      TextSpan(
                          text: cMobileNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(
                        text: " and password : ",
                      ),
                      TextSpan(
                          text: cMobileNumber,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(
                        text:
                        " for logging in is this.Download the app today to track your milk.",
                      ),
                    ])),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.002,
                  ),
                  BtnIcon(
                      onPressed: () {
                        Share.share(

                            "${widget.adminName} has created your account in $appName.\nThe username : $cMobileNumber \npassword : $cMobileNumber \nfor logging in is this.Download the app today to track your milk: \n $appUrl");
                      },
                      icon: Icons.share)
                ],
              ),
            ),
          );
        }
      } catch (e) {
        showErrorAlertDialog(context, "Error", "$e");
      }



      customerNameController.clear();
      customerMobileNumberController.clear();
      customerEmailIDController.clear();
      customerAddressController.clear();
    }
  }

  deleteCustomer(CustomerModel customer) async {
    await customerCollection.doc(customer.cid).delete();
  }

  Future<void> updateCustomer(String key, String value, String cid) async {
    customerCollection.doc(cid).update({key: value});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: indigo700),
    );
    SizeConfig().init(context);

    return Scaffold(
        appBar: appBar(title: labelCustomer),
        floatingActionButton: FloatingActionButtonWidget(
            icon: icAdd,
            onPressed: () {
              buildDialog(
                context,
                formKey: formKey,
                children: [
                  customerHeaderTitle(),
                  const Divider(
                    color: black,
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.02,
                  ),
                  TextFormFieldWidget(
                    label: labelFullName,
                    controller: customerNameController,
                    keyboardType: TextInputType.name,
                    validator: (fullName) {
                      return fullName!.isEmpty
                          ? "Please enter Customer Name"
                          : null;
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.02,
                  ),
                  TextFormFieldWidget(
                    label: labelMobileNumber,
                    controller: customerMobileNumberController,
                    keyboardType: TextInputType.phone,
                    validator: (mobileNumber) {
                      return validateMobile(mobileNumber!);
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.02,
                  ),
                  TextFormFieldWidget(
                    label: labelEmail,
                    controller: customerEmailIDController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      return validateEmail(email!);
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.02,
                  ),
                  TextFormFieldWidget(
                    label: labelAddress,
                    controller: customerAddressController,
                    keyboardType: TextInputType.streetAddress,
                    maxLines: 4,
                    maxLength: 150,
                    validator: (address) {
                      return validateAddress(address!);
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.01,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const BtnCancel(),
                          SizedBox(
                            height: SizeConfig.screenHeight! * 0.01,
                          ),
                          BtnMaterial(
                            child: Text(
                              btnLabelAdd,
                              style: const TextStyle(color: white),
                            ),
                            onPressed: () async {
                              checkValue();
                            },
                          )
                        ],
                      );
                    },
                  )
                ],
              );
            }),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                .map((doc) =>
                    CustomerModel.fromJson(doc.data() as Map<String, dynamic>))
                .toList();

            if (customers.isEmpty) {
              return Center(
                child: Text(
                  labelEmptyCustomer,
                ),
              );
            }
            return ListView.builder(
              itemCount: customers.length,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth! * 0.03,
                  vertical: SizeConfig.screenHeight! * 0.02),
              itemBuilder: (context, index) {
                CustomerModel user = customers[index];
                return Card(
                  shape: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  elevation: 3,
                  child: ExpansionTile(
                    subtitle: Text(user.id),
                    title: Text(
                      user.cName,
                      style: customerNameTextStyle(),
                    ),
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundColor: indigo700,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: white),
                      ),
                    ),
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      customerListTile(
                          leadingIcon: icMobileNumber,
                          titleText: labelMobileNumber,
                          subTitle: user.cContactNumber),
                      customerListTile(
                        leadingIcon: icEmail,
                        titleText: labelEmail,
                        subTitle: user.cEmail,
                      ),
                      customerListTile(
                        leadingIcon: icAddress,
                        titleText: labelAddress,
                        subTitle: user.cAddress,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BtnIcon(
                            icon: icEdit,
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => AlertDialog(
                                  title: const Text("Edit"),
                                  content: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormFieldWidget(
                                          label: labelEditAddress,
                                          autoFocus: true,
                                          controller: editCustomerAddressroller,
                                          validator: (address) {
                                            return validateAddress(address!);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    const BtnCancel(),
                                    BtnText(
                                        onPressed: () async {
                                          if (formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              user.cAddress =
                                                  editCustomerAddressroller
                                                      .text;
                                            });
                                            Navigator.of(context).pop();
                                            await updateCustomer(
                                                "cAddress",
                                                editCustomerAddressroller.text,
                                                user.cid);
                                            editCustomerAddressroller.clear();
                                          }
                                        },
                                        text: btnSave)
                                  ],
                                ),
                              );
                            },
                          ),
                          BtnIcon(
                            iconColor: red,
                            icon: icDelete,
                            onPressed: () {
                              showConfirmDeleteDialog(context,
                                  title: labelDeleteCustomer,
                                  content: labelConfirmDeleteCustomer,
                                  btnPerform: btnLabelDelete, onClicked: () {
                                deleteCustomer(user);
                                Navigator.of(context).pop();
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight! * 0.02,
                      )
                    ],
                  ),
                );
              },
            );
          },
        ));
  }

  @override
  void dispose() {
    // Reset the status bar color when the widget is disposed
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    super.dispose();
  }
}
