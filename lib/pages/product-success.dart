import 'package:flutter/material.dart';
import 'package:restaurant_qrcode_payment_system/pages/dashboard.dart';
import 'dashboard.dart';

class RegisterSuccess2 extends StatefulWidget {
  const   RegisterSuccess2({Key? key}) : super(key: key);

  @override
  _RegisterSuccess2State createState() => _RegisterSuccess2State();
}
class _RegisterSuccess2State extends State<RegisterSuccess2> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text(""),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {
                // do something
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
              },
            )
          ],
          elevation: 0,
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: splash());

  }

  Widget splash(){
    return Container(

        width: double.infinity,
        height: double.infinity,
        color: Colors.deepOrangeAccent,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          //  scrollDirection: Axis.horizontal,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                const <Widget>[

                  Padding(
                    padding: EdgeInsets.only(left: 35.0,top: 170.0,right: 16.0, bottom: 0),

                    child: Icon(Icons.check_circle,
                        size: 120,
                        color: Colors.green
                    ),

                    // ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 35.0,top: 0.0,right: 16.0, bottom: 200),
                    child:   Text('Successful',
                        textAlign: TextAlign.center,
                        style:TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        )
                    ),
                    //   )
                  )
                ]
            )
        )
    );

  }
}