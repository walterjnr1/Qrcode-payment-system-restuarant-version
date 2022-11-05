import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:restaurant_qrcode_payment_system/database/db_helper.dart';
import 'package:restaurant_qrcode_payment_system/model/cart_model.dart';

class CartProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  int _counter = 0;
  int _quantity = 1;
  int get counter => _counter;
  int get quantity => _quantity;

  double _totalAmount = 0.0;
  double get totalAmount => _totalAmount;

  List<Cart> cart = [];

  Future<List<Cart>> getData() async {
    cart = await dbHelper.getCartList();
    notifyListeners();
    return cart;
  }

  void _setPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_items', _counter);
    prefs.setInt('item_quantity', _quantity);
    prefs.setDouble('total_amount', _totalAmount);
    notifyListeners();
  }

  void _getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_items') ?? 0;
    _quantity = prefs.getInt('item_quantity') ?? 1;
    _totalAmount = prefs.getDouble('total_amount') ?? 0;
  }

  void addCounter() {
    _counter++;
    _setPrefsItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefsItems();
    notifyListeners();
  }

  int getCounter() {
    _getPrefsItems();
    return _counter;
  }

  void addQuantity(int ID) {
    final index = cart.indexWhere((element) => element.ID == ID);
    cart[index].quantity!.value = cart[index].quantity!.value + 1;
    _setPrefsItems();
    notifyListeners();
  }

  void deleteQuantity(int ID) {
    final index = cart.indexWhere((element) => element.ID == ID);
    final currentQuantity = cart[index].quantity!.value;
    if (currentQuantity <= 1) {
      currentQuantity == 1;
    } else {
      cart[index].quantity!.value = currentQuantity - 1;
    }
    _setPrefsItems();
    notifyListeners();
  }

  void removeItem(int ID) {
    final index = cart.indexWhere((element) => element.ID == ID);
    cart.removeAt(index);
    _setPrefsItems();
    notifyListeners();
  }

  int getQuantity(int quantity) {
    _getPrefsItems();
    return _quantity;
  }

  void addTotalAmount(double productAmount) {
    _totalAmount = _totalAmount + productAmount;
    _setPrefsItems();
    notifyListeners();
  }

  void removeTotalAmount(double productAmount) {
    _totalAmount = _totalAmount - productAmount;
    _setPrefsItems();
    notifyListeners();
  }

  int getTotalAmount() {
    int _totalAmount =0;
    cart.forEach((element) {
      int quantity = element.quantity!.value ;
      int amount = element.initialAmount ?? 0;
      _totalAmount+= (amount * quantity);
    });
    _getPrefsItems();
    return _totalAmount;
  }
}
