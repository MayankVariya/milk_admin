import 'dart:core';
import 'package:flutter/material.dart';
import 'package:milk_admin_panel/comman/widgets.dart';
import 'package:milk_admin_panel/models/product.dart';
import 'package:milk_admin_panel/utils/utils_widgets.dart';

class ProductItems extends StatelessWidget {
  const ProductItems(
      {super.key,
      required this.products,
      this.onDelete,
      this.onEdit,
      this.index});
  final ProductModel products;
  final dynamic index;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: indigo700,
      elevation: 4,
      shape: OutlineInputBorder(
          borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        leading: CircleAvatar(
          backgroundColor: indigo,
          radius: 22,
          child: Text(
            index,
            style: productIdTextStyle(),
          ),
        ),
        title: Text(
          products.type.toString(),
          style: productNameTextStyle(),
        ),
        subtitle: Text(
          "Price :${products.price}",
          style: productPriceTextStyle(),
        ),
        trailing: SizedBox(
          width: 99,
          child: Row(
            children: [
              IconButton(
                  splashRadius: 25, onPressed: onEdit, icon: Icon(icEdit)),
              IconButton(
                  color: red,
                  splashRadius: 25,
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}

headerTitle() => Text(
      labelAddProduct,
      style: addProductHeaderTextStyle(),
    );

customFillPrice(TextEditingController? controller) => Row(
      children: [
        Text(
          labelPrice,
          style: priceLabelTextStyle(),
        ),
        const SizedBox(width: 20),
        SizedBox(
            width: 170,
            height: 45,
            child: TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: labelEnterPrice,
                suffixText: labelPerLtr,
                suffixStyle: perLtrTextStyle(),
              ),
              validator: (price) =>
                  price!.isEmpty ? "Please Enter Product Price" : null,
            )),
        const SizedBox(width: 8.0),
      ],
    );
