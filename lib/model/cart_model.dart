import 'package:flutter/material.dart';

class Cart {
  late final int? ID;
  final String? product_no;
  final String? product_name;
  final int? initialAmount;
  final int? productAmount;
  final ValueNotifier<int>? quantity;
  final String? photo;

  Cart(
      {
        required this.ID,
      required this.product_no,
      required this.product_name,
      required this.initialAmount,
      required this.productAmount,
      required this.quantity,
      required this.photo});

  Cart.fromMap(Map<dynamic, dynamic> data)
      : ID = data['ID'],
        product_no = data['product_no'],
        product_name = data['product_name'],
        initialAmount = data['initialAmount'],
        productAmount = data['productAmount'],
        quantity = ValueNotifier(data['quantity']),
        photo = data['photo'];

  Map<String, dynamic> toMap() {
    return {
      'ID': ID,
      'product_no': product_no,
      'product_name': product_name,
      'initialAmount': initialAmount,
      'productAmount': productAmount,
      'quantity': quantity?.value,
      'photo': photo,
    };
  }

  Map<String, dynamic> quantityMap() {
    return {
      'ID': ID,
      'product_no': product_no,
      'product_name': product_name,
      'initialAmount': initialAmount,
      'productAmount': productAmount,
      'quantity': quantity?.value,
      'photo': photo,
    };
  }
}
