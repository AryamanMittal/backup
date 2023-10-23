import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  QRViewController? controller;
  String scannedCode = "";
  bool isuploading = false;

  void onqrviewCreated(QRViewController controller) {
    controller.resumeCamera();
    this.controller = controller;
    if (scannedCode.isEmpty) {
      controller.scannedDataStream.listen(
        (scanData) {
          setState(
            () {
              scannedCode = scanData.code!;

              controller.stopCamera();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (ctx) => QRResult(),
              //   ),
              // );
            },
          );
        },
      );
    }
  }

  void onreturn() async {
    print("inside");
    Map<String, dynamic> data = jsonDecode(scannedCode);
    var response;
    try {
      setState(() {
        isuploading = true;
      });
      print(scannedCode);
      print("inside try");
      response = await http.post(
          Uri.parse("https://arcanists-04-3jz1.onrender.com/api/v1/scanqr"),
          body: {"userId": data.values.first, "bookId": data.values.last});
      print(scannedCode.runtimeType);
    } catch (e) {
      return;
    }
    var res = jsonDecode(response.body);
    setState(() {
      isuploading = false;
    });
    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Book Returned Successfully"),
        ),
      );
    } else if (response.statusCode == 404) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res["message"]),
        ),
      );
    }

    print(res);

    print(data.values.first.runtimeType);

    // print(data.runtimeType);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Place your camera at QR",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 20, right: 20),
            child: SizedBox(
              width: 300,
              height: 300,
              child: QRView(
                key: qrKey,
                onQRViewCreated: onqrviewCreated,
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
              onPressed: onreturn,
              child: isuploading == true
                  ? SpinKitCircle(
                      color: Colors.white,
                      size: 30,
                    )
                  : const Text(
                      "RETURN",
                    ),
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shadowColor: const Color.fromARGB(255, 255, 149, 149),
                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  foregroundColor: Color.fromARGB(255, 255, 255, 255)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("BACK"),
              style: ElevatedButton.styleFrom(
                  elevation: 10,
                  shadowColor: const Color.fromARGB(255, 255, 149, 149),
                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                  foregroundColor: Color.fromARGB(255, 255, 255, 255)),
            ),
          ]),
          ElevatedButton(
            onPressed: onreturn,
            child: Text("SCAN AGAIN"),
            style: ElevatedButton.styleFrom(
                elevation: 10,
                shadowColor: const Color.fromARGB(255, 255, 149, 149),
                backgroundColor: Color.fromARGB(255, 0, 0, 0),
                foregroundColor: Color.fromARGB(255, 255, 255, 255)),
          ),
        ],
      ),
    );
  }
}
