import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/transaction.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<Transaction> transactions = [];
  late Future<List<Transaction>> transaction;
  @override
  void initState() {
    super.initState();
    transaction = getTransactionthistory();
  }

  Future<List<Transaction>> getTransactionthistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usernameValue = prefs.getString('username');
    final response = await http.get(Uri.parse(
        ("${Env.URL_PREFIX}/fetch_transaction_history.php?username=$usernameValue")));
    final items = json.decode(response.body).cast<Map<String, dynamic>>();
    List<Transaction> transaction = items.map<Transaction>((json) {
      return Transaction.fromJson(json);
    }).toList();
    setState(() {
      transactions = transaction;
    });
    return transaction;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Payment History',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.deepOrangeAccent,
              radius: 30,
              child: Icon(Icons.arrow_back),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          elevation: 0,
        ),
        body: Center(
            child: SingleChildScrollView(
                        child: Column(
                    children: [
                       ListView.separated(
                           separatorBuilder: (context, index) => const Divider(
                             color: Colors.black,
                           ),
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric( vertical: 10.0, horizontal: 8.0),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: transactions.length,
                      itemBuilder: (BuildContext context, int index) {
                        var data =transactions[index];
                        return Container(
                          padding:
                              const EdgeInsets.fromLTRB(14.0, 1.0, 2.0, 7.4),
                          height: 90,
                          color: Colors.deepOrange[50],
                          width: double.infinity,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 4.0,
                              ),
                              RichText(
                                maxLines: 1,
                                text: TextSpan(
                                    text: 'Payment ID : ',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0),
                                    children: [
                                      TextSpan( text:'${data.paymentID}\n',
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.w100
                                          )
                                      ),
                                    ]
                                ),
                              ),

                              RichText(
                                maxLines: 1,
                                text: TextSpan(
                                    text: 'Customer : ',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0),
                                    children: [
                                      TextSpan( text:'${data.customer_email}\n',
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.w100
                                          )
                                      ),
                                    ]
                                ),
                              ),
                              RichText(
                                maxLines: 1,
                                text: TextSpan(
                                    text: 'Amount : ',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0),
                                    children: [
                                      TextSpan( text:'${NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 2).format(int.parse(data.amount))}\n',
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.w100
                                          )
                                      ),
                                    ]
                                ),
                              ),
                               RichText(
                                maxLines: 1,
                                text: TextSpan(
                                    text: 'Date : ',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0),
                                    children: [
                                      TextSpan( text:'${data.date_payment}\n',
                                          style: const TextStyle(
                                              fontWeight:
                                              FontWeight.w100
                                          )
                                      ),
                                    ]
                                ),
                              ),
                            ],

                          ),
                        );
                      })
                ]
                )
            )
        )
    );
  }
}
