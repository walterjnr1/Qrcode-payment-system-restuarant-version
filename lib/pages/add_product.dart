import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_qrcode_payment_system/UI_Model/Theme.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_qrcode_payment_system/pages/product-success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../model/product.dart';

class Product extends StatefulWidget {
  const Product({Key? key}) : super(key: key);

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  bool isLoading = false;
  TextEditingController txtproduct_f = TextEditingController();
  TextEditingController txtamount_f = TextEditingController();

  File? pickedimage;

  Future pickImage() async {
    try {
      final pickedimage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedimage == null) return;

      final imageTemp = File(pickedimage.path);

      setState(() => this.pickedimage = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  checkTextFieldEmptyOrNot() {
    String text1, text2;
    text1 = txtproduct_f.text;
    text2 = txtamount_f.text;

    if (text1 == '' || text2 == '') {
      print('TextField are empty, Please Fill All Data');

      Fluttertoast.showToast(
          msg: "TextFields are empty, Please Fill All Data",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 3,
          textColor: Colors.white);
    }
  }

  void AddProduct() async {
    checkTextFieldEmptyOrNot();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username_value = prefs.getString('username');

    var uri = "${Env.URL_PREFIX}/product.php";
    var request = http.MultipartRequest('POST', Uri.parse(uri));

    //add text fields
    request.fields["txtname"] = txtproduct_f.text;
    request.fields["txtamt"] = txtamount_f.text;
    request.fields["username"] = username_value!;

    if (pickedimage != null) {
      var pic = await http.MultipartFile.fromPath("image", pickedimage!.path);

      request.files.add(pic);
      await request.send().then((result) {
        http.Response.fromStream(result).then((response) {
          var message = jsonDecode(response.body);
          if (message == "success") {
           // Fluttertoast.showToast(
            //    msg: "Product added Successfully",
              //  toastLength: Toast.LENGTH_SHORT,
              //  backgroundColor: Colors.green,
               // timeInSecForIosWeb: 3,
               // textColor: Colors.white);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterSuccess2()),
            );
          } else if (message == "Product Already Exist") {
            Fluttertoast.showToast(
                msg: "Product Already Exist",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.red,
                timeInSecForIosWeb: 3,
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: "Something Went wrong",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.red,
                timeInSecForIosWeb: 3,
                textColor: Colors.white);
          }
        });
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Row(
              children: const [
                Expanded(
                  child: Text(
                    "",
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            elevation: 0,
            backgroundColor: Colors.deepOrangeAccent,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(Icons.arrow_back),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 700,
              color: Colors.deepOrangeAccent[200],
              alignment: Alignment.center,
            ),
            SafeArea(
              child: ListView(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 16, left: 24.0, right: 24.0, bottom: 32),
                  child: Card(
                      elevation: 5,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Column(
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * 0.15,
                              decoration: const BoxDecoration(
                                  color: ArgonColors.white,
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 0.5,
                                          color: ArgonColors.muted))),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  Center(
                                      child: Padding(
                                    padding: EdgeInsets.only(top: 8.0),
                                    child: Text("Register Your Product",
                                        style: TextStyle(
                                            color: ArgonColors.text,
                                            fontSize: 16.0)),
                                  )),

                                  // Divider()
                                ],
                              )),
                          Container(
                              height: MediaQuery.of(context).size.height * 0.63,
                              color: const Color.fromRGBO(244, 245, 247, 1),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Name:',
                                              ),
                                              controller: txtproduct_f,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Amount',
                                              ),
                                              controller: txtamount_f,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Center(
                                        child: Column(
                                          // mainAxisAlignment: MainAxisAlignment.center,
                                          //crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            OutlinedButton.icon(
                                              // <-- OutlinedButton
                                              onPressed: () {
                                                pickImage();
                                              },
                                              icon: const Icon(
                                                Icons.camera_alt_outlined,
                                                size: 24.0,
                                              ),
                                              label: const Text(
                                                  'Upload Product Image'),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 100,
                                              child: pickedimage != null
                                                  ? Image.file(pickedimage!)
                                                  : const Text(
                                                      "No image selected"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10, right: 10),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 60,

                                                  // elevated button created and given style
                                                  // and decoration properties
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Colors
                                                            .deepOrangeAccent,
                                                        shape:
                                                            const StadiumBorder()),
                                                    onPressed: () {
                                                      setState(() {
                                                        isLoading = true;
                                                      });

                                                      // we had used future delayed to stop loading after
                                                      // 3 seconds and show text "submit" on the screen.
                                                      Future.delayed(
                                                          const Duration(
                                                              seconds: 5), () {
                                                        setState(() {
                                                          isLoading = true;
                                                          AddProduct();
                                                          isLoading = false;
                                                        });
                                                      });
                                                    },
                                                    child: isLoading
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,

                                                            // as elevated button gets clicked we will see text"Loading..."
                                                            // on the screen with circular progress indicator white in color.
                                                            //as loading gets stopped "Submit" will be displayed
                                                            children: const [
                                                              Text(
                                                                'Loading...',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              CircularProgressIndicator(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ],
                                                          )
                                                        : const Text('Add',
                                                            style: TextStyle(
                                                                fontSize: 15)),
                                                  ))
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                        ],
                      )),
                ),
              ]),
            )
          ],
        ));
  }
}
