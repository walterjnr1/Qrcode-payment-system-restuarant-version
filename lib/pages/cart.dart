import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_payment_system/database/db_helper.dart';
import 'package:qr_code_payment_system/model/cart_model.dart';
import 'package:qr_code_payment_system/pages/qr.dart';
import 'package:qr_code_payment_system/provider/cart_provider.dart';
import '../model/user.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();
  List<bool> tapped = [];

  @override
  void initState() {
    super.initState();
    context.read<CartProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

        return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Cart',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Badge(
            badgeContent: Consumer<CartProvider>(
              builder: (context, value, child) {
                return Text(
                  value.counter.toString(),
                  //value.getCounter().toString(),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                );
              },
            ),
            position: const BadgePosition(start: 30, bottom: 30),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart,color:Colors.black),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
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
      ),
      body: Column(
        children: [

          Flexible(
            child: Consumer<CartProvider>(
              builder: (BuildContext context, provider, widget) {
                if (provider.cart.isEmpty) {
                  return const Center(
                      child: Text(
                        'Your Cart is Empty',
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                      )
                  );
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: provider.cart.length,
                      itemBuilder: (context, index) {
                        var data = provider.cart[index];
                        return Card(

                          color: Colors.white54,
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [

                                Image(
                                  height: 45,
                                  width: 40,

                                  image: NetworkImage(
                                      '${Env.URL_PREFIX}/${data.photo}'
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 4.0,
                                      ),
                                      RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: '',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 10.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                  '${data.product_name!}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold)),
                                            ]
                                        ),
                                      ),

                                      RichText(
                                        maxLines: 1,
                                        text: TextSpan(
                                            text: '',
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade800,
                                                fontSize: 10.0),
                                            children: [
                                              TextSpan(
                                                  text:
                                                  '${NumberFormat.simpleCurrency(name: 'NGN', decimalDigits: 2).format(data.productAmount)}\n',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold)),
                                            ]),
                                      ),
                                    ],
                                  ),
                                ),
                                   ValueListenableBuilder<int>(
                                    valueListenable:
                                    data.quantity!,
                                    builder: (context, val, child) {
                                      return PlusMinusButtons(
                                        addQuantity: () {
                                          cart.addQuantity(
                                              data.ID!);
                                          dbHelper!
                                              .updateQuantity(Cart(
                                              ID: index,
                                              product_no: data.product_no,
                                              product_name: data.product_name,
                                              initialAmount: data.initialAmount,
                                              productAmount: data.productAmount,
                                              quantity: ValueNotifier(
                                                  data.quantity!.value),
                                              photo: data.photo))
                                              .then((value) {
                                            setState(() {
                                              cart.addTotalAmount(double.parse(
                                                  data.productAmount.toString()));
                                            });
                                          });
                                        },
                                        deleteQuantity: () {
                                          cart.deleteQuantity(
                                              data.ID!);
                                          cart.removeTotalAmount(double.parse(
                                              data.productAmount
                                                  .toString()));
                                        },
                                        text: val.toString(),
                                      );
                                    }),


                                IconButton(
                                    onPressed: () {
                                      dbHelper!.deleteCartItem(
                                          data.ID!);
                                      provider
                                          .removeItem(data.ID!);
                                      provider.removeCounter();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red.shade800,
                                    )),
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          Consumer<CartProvider>(
            builder: (BuildContext context, value, Widget? child) {
              final ValueNotifier<int?> totalAmount = ValueNotifier(null);
              for (var element in value.cart) {
                totalAmount.value =
                    (element.productAmount! * element.quantity!.value) +
                        (totalAmount.value ?? 0);
              }
              return Column(
                children: [
                  ValueListenableBuilder<int?>(
                      valueListenable: totalAmount,
                      builder: (context, val, child) {
                        return ReusableWidget(
                            title: 'Sub-Total',
                            value: r'NGN' + (val?.toString() ?? '0')

                        );
                      }
                      ),

                ],
              );
            },
          )
        ],
      ),

      bottomNavigationBar:
      Consumer<CartProvider>(
            builder: (BuildContext context, provider, widget) {
    if (provider.cart.isEmpty) {
    return InkWell(
    //onTap: ()=> null,

    child: Container(
    color: Colors.deepOrangeAccent.shade100,
    alignment: Alignment.center,
    height: 50.0,
    child: const Text(
    'Can\'t Accept payment Now',
    style: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    ),
    ),
    ),
    );
    }else {

      return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (ctx) =>
                  AlertDialog(
                    content: const Text(
                        'Are you sure you want to Process Payment Now ?'),
                    actions: <Widget>[
                      ElevatedButton(
                        child: const Icon(Icons.cancel),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontStyle: FontStyle.normal),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      ElevatedButton(
                          child: const Icon(Icons.check_circle),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontStyle: FontStyle.normal),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const QR()),
                            );
                          }

                      ),
                    ],
                  )
          );
        },

        child: Container(
          color: Colors.deepOrangeAccent,
          alignment: Alignment.center,
          height: 50.0,
          child: const Text(
            'Accept payment',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

    }
    }
      )
    );
  }
}
class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;
  const PlusMinusButtons(
      {Key? key,
        required this.addQuantity,
        required this.deleteQuantity,
        required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: deleteQuantity, icon: const Icon(Icons.remove)),
        Text(text),
        IconButton(onPressed: addQuantity, icon: const Icon(Icons.add)),
      ],
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({Key? key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}


