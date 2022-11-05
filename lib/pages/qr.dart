import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_qrcode_payment_system/pages/sell.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../provider/cart_provider.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR code Payment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: QR(),
      ),
    );
  }
}
class QR extends StatefulWidget {
  const QR({Key? key}) : super(key: key);

  @override
  QRState createState() =>QRState();
}
class QRState extends State<QR> {

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();
  String usernameValue = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetUserDetails();
  }

  GetUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username');
    setState(() {
      usernameValue = username.toString();
    });
    return username;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    String? totalamt =  cart.getTotalAmount().toString();
    String? qty = cart.getCounter().toString();
    //DateTime dateTime = DateTime.now();
    //String dateTimeToday = DateFormat.yMd().format(dateTime);

  var encoded = [totalamt,usernameValue];

    Widget _buildQRImage(String data) {
      return QrImage(
        data: encoded.toString(),
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        gapless: false,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      );

    }
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Generated QR Code ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),

          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.share,
                color: Colors.deepOrangeAccent,
              ),
              onPressed: () async {
                final capturedimage = await screenshotController.capture();
                if (capturedimage==null) return;
                await saveImage(capturedimage);

                saveAndShare(capturedimage);
              },
            )
          ],
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
        body: Screenshot(
            controller: screenshotController,
            child:      Container(
              padding: EdgeInsets.all(27),
              child: SingleChildScrollView(

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                        _buildQRImage(encoded.toString()),
                    const SizedBox(height: 20),

                    const SizedBox(height: 15),
                    ElevatedButton(
                      //Width: double.infinity,
                      onPressed: ()  {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>  Sell()),
                        );
                      },
                      //Title given on Button
                      child: Text("Close",
                        style: TextStyle(color: Colors.indigo[900],),),

                    ),
                  ],
                ),
              ),
            )
        )
    );

  }
}

Future<CircularProgressIndicator> saveAndShare(Uint8List bytes) async {
  final directory = await getApplicationDocumentsDirectory();
  final time=DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');
  final img = File('${directory.path}/qrimg_$time.png');
  img.writeAsBytesSync(bytes);
  await Share.shareFiles([img.path]);
  return  const CircularProgressIndicator();
}

Future <String> saveImage(Uint8List bytes) async {
  await [Permission.storage].request();
  final time=DateTime.now().toIso8601String().replaceAll('.', '-').replaceAll(':', '-');
  final name='screenshot_$time';
  final result = await ImageGallerySaver.saveImage(bytes, name:name);
  return result['filePath'];
}
//



