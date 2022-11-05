import 'package:flutter/material.dart';
import 'package:restaurant_qrcode_payment_system/pages/product_list.dart';
import 'package:restaurant_qrcode_payment_system/pages/profile.dart';
import 'package:restaurant_qrcode_payment_system/pages/sell.dart';
import 'package:restaurant_qrcode_payment_system/pages/transactionhistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';
import '../widgets/slider.dart';
import 'add_product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'login.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final formatBalance  = NumberFormat("#,###", "en_US");

  late Future<User> futureUser;
  @override
  void initState() {
    super.initState();
    futureUser = getuserdetails();
  }

  logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const Login()));
  }
  Future<User> getuserdetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usernameValue = prefs.getString('username');
    final response = await http.get(Uri.parse(("${Env.URL_PREFIX}/get_user_details.php?username=$usernameValue")));
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body) as List;
      debugPrint(response.body);
      return User.fromJson(res[0]);
    } else {
      throw Exception('Failed to load data');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:  const Text(
              'Restaurant Dashboard',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            leading:
            FutureBuilder<User>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {

                    return ClipOval(
                      child: Image.network(
                        "${Env.URL_PREFIX}/${snapshot.data!.photo}",
                        //"https://protocoderspoint.com/wp-content/uploads/2019/10/mypic-300x300.jpg",
                        width: 5,
                        fit: BoxFit.fill,
                      ),

                    );
                  }else{
                    return const CircularProgressIndicator();
                  }
                }

            )
        ),

        body: Container(
          padding: const EdgeInsets.all(7),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              CarouselSliderSection,
              const Divider(
                thickness: 1.0, // thickness of the line
                indent: 0, // empty space to the leading edge of divider.
                endIndent: 0, // empty space to the trailing edge of the divider.
                color: Colors.deepOrangeAccent, // The color to use when painting the line.
                height: 25, // The divider's height extent.
              ),
              FutureBuilder<User>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                            child:  Text("Restaurant Name: ${snapshot.data!.company_name}",

                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.0)
                            ),
                          ),
                          Container(
                              margin: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                              child:  Text("Owner: ${snapshot.data!.fullname}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0))),



                          Container(
                              margin: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                              child:   Text("Balance: ${NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 2).format(int.parse(snapshot.data!.balance))}",

                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0))),
                        ],
                      ),
                    );

                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  // By default, show a loading spinner.
                  return const CircularProgressIndicator();
                },
              ),

              const Divider(
                thickness: 1.0, // thickness of the line
                indent: 0, // empty space to the leading edge of divider.
                endIndent: 0, // empty space to the trailing edge of the divider.
                color: Colors.deepOrangeAccent, // The color to use when painting the line.
                height: 25, // The divider's height extent.
              ),

              //Menu buttons
              Wrap(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SizedBox.fromSize(
                      size: const Size(90, 90),
                      child: ClipOval(
                        child: Material(
                          color: Colors.deepOrangeAccent,
                          child: InkWell(
                            splashColor: Colors.green,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Product()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(Icons.add, size: 30.0), // <-- Icon
                                Text(
                                  "Add Product",
                                  style: TextStyle(
                                    fontSize: 7.0, fontWeight: FontWeight.bold,color: Colors.white, ),
                                ), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SizedBox.fromSize(
                      size: const Size(90, 90),
                      child: ClipOval(
                        child: Material(
                          color: Colors.deepOrangeAccent,
                          child: InkWell(
                            splashColor: Colors.green,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProductList()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(Icons.list_sharp, size: 30.0), // <-- Icon
                                Text(
                                  "Product List(s)",
                                  style: TextStyle(
                                      fontSize: 7.0, color: Colors.white,fontWeight: FontWeight.bold),
                                ), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SizedBox.fromSize(
                      size: const Size(90, 90),
                      child: ClipOval(
                        child: Material(
                          color: Colors.deepOrangeAccent,
                          child: InkWell(
                            splashColor: Colors.green,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Sell()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(Icons.shopping_cart, size: 30.0), // <-- Icon
                                Text(
                                  "Sell",
                                  style: TextStyle(
                                      fontSize: 7.0, fontWeight: FontWeight.bold, color: Colors.white),
                                ), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Wrap(
                //  mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SizedBox.fromSize(
                      size: const Size(90, 90),
                      child: ClipOval(
                        child: Material(
                          color: Colors.deepOrangeAccent,
                          child: InkWell(
                            splashColor: Colors.green,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const Profile()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(Icons.account_box_outlined, size: 30.0), // <-- Icon
                                Text(
                                  "Me",
                                  style: TextStyle(
                                      fontSize: 7.0, fontWeight: FontWeight.bold, color: Colors.white),
                                ), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SizedBox.fromSize(
                      size: const Size(90, 90),
                      child: ClipOval(
                        child: Material(
                          color: Colors.deepOrangeAccent,
                          child: InkWell(
                            splashColor: Colors.green,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TransactionHistory()),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(Icons.euro_symbol_outlined, size: 30.0), // <-- Icon
                                Text(
                                  "Transaction(s)",
                                  style: TextStyle(
                                      fontSize: 7.0, fontWeight: FontWeight.bold, color: Colors.white),
                                ), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SizedBox.fromSize(
                      size: const Size(90, 90),
                      child: ClipOval(
                        child: Material(
                          color: Colors.deepOrangeAccent,
                          child: InkWell(
                            splashColor: Colors.green,
                            onTap: () {
                              // Navigator.push(
                              //  context,
                              //  MaterialPageRoute(builder: (context) => const Profile()),
                              // );
                              logout();
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Icon(Icons.logout_outlined, size: 30.0), // <-- Icon
                                Text(
                                  "Logout",
                                  style: TextStyle(
                                      fontSize: 7.0, fontWeight: FontWeight.bold, color: Colors.white),
                                ), // <-- Text
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] //<------
            ),
          ),
        )
    );
  }
}
