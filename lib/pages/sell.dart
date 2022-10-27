import 'dart:convert';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_payment_system/pages/dashboard.dart';
import 'package:qr_code_payment_system/pages/product_list.dart';
import 'package:qr_code_payment_system/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/db_helper.dart';
import '../model/cart_model.dart';
import '../model/product.dart';
import '../model/searchproduct.dart';
import '../provider/cart_provider.dart';
import 'cart.dart';
import 'login.dart';
import 'package:http/http.dart' as http;

class Sell extends StatefulWidget {
  Sell({Key? key, Sell}) : super(key: key);

  @override
  SellState createState() => SellState();
}

class SellState extends State<Sell> {
  DBHelper dbHelper = DBHelper();
  TextEditingController txtsearch_f = TextEditingController();
  // String total_livestock = "0";
  List<Product> products = [];
  String query = '';

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Login()));
  }

  late Future<List<Product>> product;
  final productListKey = GlobalKey<ProductListState>();
  @override
  void initState() {
    super.initState();
    product = getProductList();
  }

  Future<List<Product>> getProductList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usernameValue = prefs.getString('username');
    final response = await http.get(Uri.parse(
        ("${Env.URL_PREFIX}/fetch_product.php?username=$usernameValue")));

    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Product> product = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();
    setState(() {
      //total_livestock = "${livestock.length}";
      products = product;
    });

    return product;
  }

  Future<List<Product_search>> getProductList_search() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usernameValue = prefs.getString('username');
    final response = await http.get(Uri.parse(
        ("${Env.URL_PREFIX}/searchproduct.php?query=${txtsearch_f.text}&username=${usernameValue}")));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Product_search> productSearch = items.map<Product_search>((json) {
      return Product_search.fromJson(json);
    }).toList();
    setState(() {
      //   total_livestock = "${livestock_search.length}";
    });

    List<Product> product = items.map<Product>((json) {
      return Product.fromJson(json);
    }).toList();
    setState(() {
      products = product;
    });

    return productSearch;
  }

  final int _currentIntValue = 0;
  bool isLoading = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //save to local storage (Cart) using sqlite --DBhelper
    final cart = Provider.of<CartProvider>(context);
    void saveData(int index) {
      print(index);
      dbHelper
          .insert(
        Cart(
          ID: index,
          product_no: products[index].product_no,
          product_name: products[index].product_name,
          initialAmount: products[index].amount,
          productAmount: products[index].amount,
          quantity: ValueNotifier(1),
          photo: products[index].photo,
        ),
      )
          .then((value) {
        cart.addTotalAmount(products[index].amount.toDouble());
        cart.addCounter();
        Fluttertoast.showToast(
            msg: "${products[index].product_name} Added to Cart",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.green,
            timeInSecForIosWeb: 2,
            textColor: Colors.white);
      }).onError((error, stackTrace) {
        //print(error.toString());
        Fluttertoast.showToast(
            // msg: error.toString(),
            msg: "${products[index].product_name} Added already to Cart",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.red,
            timeInSecForIosWeb: 2,
            textColor: Colors.white);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menu List',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.deepOrangeAccent,
            radius: 23,
            child: Icon(Icons.arrow_back),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          const SizedBox(
            width: 30,
          ),
          Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  value.getCounter().toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
            position: const BadgePosition(start: 30, bottom: 30),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartScreen()));
              },
              icon: const Icon(Icons.shopping_cart, color: Colors.black),
            ),
          ),
          const SizedBox(
            width: 25,
          ),
        ],
        elevation: 0,
      ),
      body: ListView(scrollDirection: Axis.vertical, children: [
        Container(
          height: 40.0,
          padding: const EdgeInsets.fromLTRB(13.0, 2.0, 2.0, 2.0),
          alignment: Alignment.center,
          child: TextField(
            onChanged: (query) {
              getProductList_search();
              setState(() {
                txtsearch_f.text.isEmpty
                    ? getProductList()
                    : getProductList_search();
              });
            },
            controller: txtsearch_f,
            decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search Food Menu",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: () {
                    txtsearch_f.text = "";
                    setState(() {
                      txtsearch_f.text.isEmpty
                          ? getProductList()
                          : getProductList_search();
                    });
                  },
                  icon: const Icon(Icons.cancel),
                ),
                border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)))),
          ),
        ),

        Container(
          height: 20,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
          shrinkWrap: true,
          itemCount: products.length,
          itemBuilder: (context, index) {
            var data = products[index];
            return Center(
                /** Card Widget **/

                child: Banner(
              message:
                  NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 2)
                      .format(data.amount),
              location: BannerLocation.topStart,
              color: Colors.red,
              child: Card(
                  elevation: 4.0,
                  child: Column(
                    children: [
                      Container(
                        height: 100.0,
                        child: Ink.image(
                          image:
                              NetworkImage('${Env.URL_PREFIX}/${data.photo}'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          data.product_name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      ButtonBar(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.deepOrangeAccent),
                              onPressed: () {
                                saveData(index);
                              },
                              child: const Text('Add to Cart')),
                        ],
                      )
                    ],
                  )
              ),
            )
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 5,
            mainAxisExtent: 264,
          ),
        ),

      ]
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              logout();
            },
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 4),
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment(0.7, -0.5),
                  end: Alignment(0.6, 0.5),
                  colors: [
                    Color(0xFF53a78c),
                    Color(0xFF70d88b),
                  ],
                ),
              ),
              child: const Icon(Icons.logout, size: 30),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.lightBlueAccent[700],
        unselectedItemColor: Colors.grey,
        unselectedFontSize: 13,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
            label: "Menu",
            icon: IconButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Dashboard())),
              icon: const Icon(Icons.menu),
            ),
          ),
          BottomNavigationBarItem(
            label: "Me",
            icon: IconButton(
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Profile())),
              icon: const Icon(Icons.account_circle_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
