import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_qrcode_payment_system/UI_Model/Theme.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_qrcode_payment_system/pages/register-success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';
import 'dart:io';


class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {

  bool isLoading = false;
  TextEditingController txtusername_f = TextEditingController();
  TextEditingController txtpassword_f = TextEditingController();
  TextEditingController txtrestaurant_f = TextEditingController();
  TextEditingController txtphone_f = TextEditingController();
  TextEditingController txtaddress_f = TextEditingController();
  TextEditingController txtfullname_f = TextEditingController();

  File? pickedimage;

  Future pickImage() async {
    try {
      final pickedimage = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(pickedimage == null) return;

      final imageTemp = File(pickedimage.path);

      setState(() => this.pickedimage = imageTemp);
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  checkTextFieldEmptyOrNot() {
    String text1, text2,text3, text4,text5, text6;
    text1 = txtusername_f.text;
    text2 = txtpassword_f.text;
    text3 = txtrestaurant_f.text;
    text4 = txtphone_f.text;
    text5 = txtaddress_f.text;
    text6 = txtfullname_f.text;

      if (text1 == '' || text2 == '' || text3 == '' || text4 == '' || text5 == '' || text6 == '' ) {
      print('TextField are empty, Please Fill All Data');

      Fluttertoast.showToast(
          msg: "TextFields are empty, Please Fill All Data",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.red,
          timeInSecForIosWeb: 3,
          textColor: Colors.white);
    }
  }
    void register() async {
      checkTextFieldEmptyOrNot();

          var uri = "${Env.URL_PREFIX}/register.php";
        var request = http.MultipartRequest('POST', Uri.parse(uri));

          //add text fields
          request.fields["txtusername"] = txtusername_f.text;
          request.fields["txtpassword"] = txtpassword_f.text;
          request.fields["txtrestaurant"] = txtrestaurant_f.text;
          request.fields["txtphone"] = txtphone_f.text;
          request.fields["txtaddress"] = txtaddress_f.text;
          request.fields["txtfullname"] = txtfullname_f.text;



          //Assign username to session
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', txtusername_f.text);

          if(pickedimage != null){
            var pic = await http.MultipartFile.fromPath("image", pickedimage!.path);

            request.files.add(pic);
            await request.send().then((result) {
              http.Response.fromStream(result).then((response) {

                var message = jsonDecode(response.body);
                  if (message == "success") {

               //   txtfullname_f.text='';
             //     txtusername_f.text='';
               //   txtpassword_f.text='';
               //   txtrestaurant_f.text='';
               //   txtphone_f.text='';
               //   txtaddress_f.text='';
                 // setState(() {
                //  pickedimage = null;
                 // }
                  //);

                  //Fluttertoast.showToast(
                    //  msg: "Registration was successful",
                     // toastLength: Toast.LENGTH_SHORT,
                   //   backgroundColor: Colors.green,
                    //  timeInSecForIosWeb: 3,
                    // textColor: Colors.white);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterSuccess1()),
                    );
                } else if (message == "User Already Exist"){
                  Fluttertoast.showToast(
                      msg: "User Already Exist",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.red,
                      timeInSecForIosWeb: 3,
                      textColor: Colors.white);
                }else{
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
              child: ListView(
                  children: [
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
                                            child: Text("User Registration",
                                                style: TextStyle(
                                                    color: ArgonColors.text,
                                                    fontSize: 16.0)),
                                          )),

                                      // Divider()
                                    ],
                                  )
                              ),

                              Container(
                                  height: MediaQuery.of(context).size.height * 0.63,
                                  color: const Color.fromRGBO(244, 245, 247, 1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:SingleChildScrollView(
                                      child:Column(

                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children:  [
                                              Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: TextField(
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'UserName:',
                                                  ),
                                                  controller:   txtusername_f,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: TextField(
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Password',
                                                  ),
                                                  controller:   txtpassword_f,
                                                  obscureText: true,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: TextField(
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Restaurant Name:',
                                                  ),
                                                  controller:   txtrestaurant_f,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: TextField(
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Full Name:',
                                                  ),
                                                  controller:   txtfullname_f,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: TextField(
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Phone',
                                                  ),
                                                  controller:   txtphone_f,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(2.0),
                                                child: TextField(
                                                  decoration: const InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'Address',
                                                  ),
                                                  controller:   txtaddress_f,
                                                ),
                                              ),

                                            ],
                                          ),
                                          Center( child:
                                          Column(
                                            // mainAxisAlignment: MainAxisAlignment.center,
                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              OutlinedButton.icon( // <-- OutlinedButton
                                                onPressed: () {
                                                  pickImage();
                                                },
                                                icon: const Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 24.0,
                                                ),
                                                label: const Text('Upload User Image'),
                                              ),
                                              Container(
                                                // width: double.infinity,
                                                height: 150,
                                                width: 150,

                                                child: pickedimage != null ? Image.file(pickedimage!): const Text("No image selected"),
                                              ),
                                            ],
                                          ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      padding: const EdgeInsets.only(left: 10, right: 10),
                                                      width: MediaQuery.of(context).size.width,
                                                      height: 60,

                                                      // elevated button created and given style
                                                      // and decoration properties
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            primary: Colors.deepOrangeAccent,

                                                            shape: const StadiumBorder()),
                                                        onPressed: () {
                                                          setState(() {
                                                            isLoading = true;
                                                          });

                                                          // we had used future delayed to stop loading after
                                                          // 3 seconds and show text "submit" on the screen.
                                                          Future.delayed(const Duration(seconds: 5), (){
                                                            setState(() {
                                                              isLoading = true;
                                                              register();
                                                              isLoading = false;
                                                            });
                                                          }
                                                          );
                                                        }, child:  isLoading? Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,

                                                        // as elevated button gets clicked we will see text"Loading..."
                                                        // on the screen with circular progress indicator white in color.
                                                        //as loading gets stopped "Submit" will be displayed
                                                        children: const [
                                                          Text('Loading...', style: TextStyle(fontSize: 15),),
                                                          SizedBox(width: 10,),
                                                          CircularProgressIndicator(color: Colors.white,),
                                                        ],
                                                      ) : const Text('Register',style: TextStyle(fontSize: 15)),

                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                              )
                            ],
                          )),
                    ),
                  ]),
            )
          ],
        )
    );
  }
}
