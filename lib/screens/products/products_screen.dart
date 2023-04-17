import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/product.dart';
import 'package:milk_admin_panel/size_config.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';
import 'package:provider/provider.dart';
import '../../dark_theme_provider.dart';
import 'products_screen_widget.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late String selectedValue;
  final List<String> types = ["Cow", "Buffalo"];
  final List<ProductModel> products = <ProductModel>[];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final CollectionReference productsCollection = FirebaseFirestore.instance
      .collection('admin')
      .doc('products')
      .collection('product');

  @override
  void initState() {
    super.initState();
    selectedValue = types[0];
  }

  addProduct(String type, double price) async {
    try {
      QuerySnapshot querySnapshot = await productsCollection
          .where('type', isEqualTo: type)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        // ignore: use_build_context_synchronously
        return showErrorAlertDialog(context, "Error", "Product Already exists");
      }

      String key = productsCollection.doc().id;
      ProductModel product = ProductModel(key: key, type: type, price: price);
      await productsCollection.doc(key).set(product.toMap());
    } catch (e) {
      showErrorAlertDialog(context, "error", "$e");
    }
  }

  deleteProduct(ProductModel product) async {
    await productsCollection.doc(product.key).delete();
    // print(product.key);
  }

  Future<void> update(ProductModel product) async {
    Navigator.of(context).pop();
    final docRef = productsCollection.doc(product.key);
    await docRef.update({
      'price': product.price,
    });
    editPriceController.clear();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<DarkThemeProvider>(context);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: indigo700),
    );
    SizeConfig().init(context);
    return Scaffold(
        appBar: appBar(title: labelProduct),
        floatingActionButton: FloatingActionButtonWidget(
          
          icon: icAdd,
          onPressed: () {
            buildDialog(
              context,
              children: [
                headerTitle(),
                const Divider(
                  color: black,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.03,
                ),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Row(
                      children: [
                        Text(
                          labelType,
                          style: typeLabelTextStyle(),
                        ),
                        SizedBox(width: SizeConfig.screenWidth! * 0.05),
                        SizedBox(
                          width: SizeConfig.screenWidth! * 0.46,
                          child: DropdownButton<String>(
                            isExpanded: true,
                            borderRadius: BorderRadius.circular(10),
                            value:
                                selectedValue.isNotEmpty ? selectedValue : null,
                            hint: Text(labelSelectMilkType),
                            items: types
                                .where((type) =>
                                    !products.any((p) => p.type == type))
                                .map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            onChanged: (String? newValue) {
                              setState(
                                () {
                                  selectedValue = newValue.toString();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.01,
                ),
                Form(
                  key: formKey,
                  child: customFillPrice(priceController),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.04,
                ),
                StatefulBuilder(
                  builder: (context, setState) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const BtnCancel(),
                        SizedBox(
                          width: SizeConfig.screenWidth! * 0.01,
                        ),
                        BtnMaterial(
                          onPressed: () {
                            
                            if (formKey.currentState!.validate()) {
                              final price = double.parse(priceController.text);
                              addProduct(selectedValue, price);
                              selectedValue = "";
                              priceController.clear();
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(
                            btnLabelAdd,
                            style: const TextStyle(color: white),
                          ),
                        )
                      ],
                    );
                  },
                )
              ],
            );
          },
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: productsCollection.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
            final products = snapshot.data!.docs
                .map((doc) =>
                    ProductModel.fromJson(doc.data() as Map<String, dynamic>))
                .toList();
            if (products.isEmpty) {
              return Center(
                child: Text(
                  labelEmpty,
                ),
              );
            }
            // print(products[0].key);
            return ListView.builder(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.screenWidth! * 0.02,
                  vertical: SizeConfig.screenHeight! * 0.02),
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                return ProductItems(
                    products: product,
                    index: "${index + 1}",
                    onDelete: () {
                      showConfirmDeleteDialog(context,
                          title: labelDeleteProduct,
                          content: labelConfirmDeleteProduct,
                          btnPerform: btnLabelDelete, onClicked: () {
                        deleteProduct(product);
                        Navigator.of(context).pop();
                        setState(() {

                        });
                      });
                    },
                    onEdit: () {
                      // print(product.key);
                      showEditDialog(context, formKey: formKey, children: [
                        TextFormFieldWidget(
                            label: labelEnterPrice,
                            controller: editPriceController,
                            keyboardType: TextInputType.number,
                            autoFocus: true,
                            validator: (price) {
                              if (price!.isEmpty) {
                                return "Please Enter Price";
                              }
                              return null;
                            }),
                      ], onPressed: () async {
                        
                        if (formKey.currentState!.validate()) {
                        final newPrice = double.parse(editPriceController.text);

                        setState(() {
                          product.price = newPrice;
                        });

                        await update(product);
                      }
                          }
                          );
                    });
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
