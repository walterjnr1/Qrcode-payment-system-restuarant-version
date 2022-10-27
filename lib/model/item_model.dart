class Item {
  final String product_name;
  final int amount;
  final String photo;

  Item({required this.product_name, required this.amount, required this.photo});

  Map toJson() {
    return {
      'product_name': product_name,
      'amount': amount,
      'photo': photo,
    };
  }
}
