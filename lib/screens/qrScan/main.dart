import "package:flutter/material.dart";
import 'package:qr_code_scanner/qr_code_scanner.dart';
import "dart:io";
import "../../api/main.dart";

class QRScanView extends StatefulWidget {
  @override
  _QRViewExampleState createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool started = false;
  bool isProcessQR = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
          ),
          if(!started) Positioned(
            child: ElevatedButton(
              onPressed: () async {
                controller!.resumeCamera();

                setState(() {
                  started = true;
                });
              },
              child: const Text(
                "BẮT ĐẦU", 
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(6),
                primary: Colors.black.withOpacity(.75), // <-- Splash color
                shadowColor: Colors.transparent
              ),
            )
          ),
          Positioned(
            top: 48,
            left: 8,
            child: ElevatedButton(
              onPressed: () {
                controller!.pauseCamera();
                Navigator.pop(context);
              },
              child: const Icon(Icons.close, color: Colors.white),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(6),
                primary: Colors.black.withOpacity(.75), // <-- Splash color
                shadowColor: Colors.transparent
              ),
            )
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      String code = scanData.code ?? "";

      if(!isProcessQR) {
        // print(code);
        if(code.contains("checkin")) { //CHECKIN
          setState(() {
            isProcessQR = true;
          });

          String eventId = code.split("/")[5];

          Navigator.pushNamedAndRemoveUntil(
            context, 
            "/checkin", 
            (route) => false,
            arguments: {
              "event": eventId
            }
          );
        }
      }

      // if(code.contains("gift_exchange")) { //GIFT EXCHANGE
      //   String params = code.split("/")[2];
      //   List<String> paramsList = params.split("|");

      //   Navigator.pushNamedAndRemoveUntil(
      //     context, 
      //     "/gems_exchange", 
      //     (route) => false,
      //     arguments: {
      //       "values": paramsList
      //     }
      //   );
      // }else if(code.contains("quiz")) { //QUIZ
      //   String quizId = code.split("#")[1].split("/")[2];

      //   Navigator.pushNamedAndRemoveUntil(
      //     context,
      //     "/quiz",
      //     (route) => false,
      //     arguments: quizId
      //   );
      // }
      // }else if(code.contains("checkin")) { //CHECKIN
      //   String eventId = code.split("/")[4];

      //   Navigator.pushNamedAndRemoveUntil(
      //       context, 
      //       "/checkin", 
      //       (route) => false,
      //       arguments: {
      //         "event": eventId
      //       }
      //     );
      // }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}