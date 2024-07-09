import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcode_absensi/result_screen.dart';
import 'package:qr_scanner_overlay/qr_scanner_overlay.dart';
import 'package:qrcode_absensi/resultpage.dart';

const bgColor = Color(0xfffafafa);
// const bgColor = Color(0xfffafafa);
String? kodeBarcode;

class QRScanner extends StatefulWidget {
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  bool isScanCompleted = false;
  bool isFlashon = false;
  bool isFontCamera = false;
  MobileScannerController controller = MobileScannerController();

  void closeScreen() {
    isScanCompleted = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      // drawer: const Drawer(),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isFlashon = !isFlashon;
                });
                controller.toggleTorch();
              },
              icon: Icon(Icons.flash_on,
                  color: isFlashon ? Colors.black : Colors.white)),
          // IconButton(
          //     onPressed: () {
          //       setState(() {
          //         isFontCamera = !isFontCamera;
          //       });
          //       controller.switchCamera();
          //     },
          //     icon: Icon(Icons.camera_front,
          //         color: isFontCamera ? Colors.blue : Colors.grey))
        ],
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        title: const Text(
          "QR Scanner",
          style: TextStyle(
            color: Colors.white,
            // fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Place the QR code in the area",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Scanning will be started automatically",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            )),
            Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    MobileScanner(
                        controller: controller,
                        allowDuplicates: true,
                        onDetect: (barcode, args) {
                          if (!isScanCompleted) {
                            kodeBarcode = barcode.rawValue ?? '----';
                            isScanCompleted = true;
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => ResultScreen(
                            //               closeScreen: closeScreen,
                            //               code: kodeBarcode.toString(),
                            //               // kode_barcode: kode_barcode
                            //               // product: Barcode(rawValue: rawValue)
                            //             )));
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ResultPage(
                                          closeScreen: closeScreen,
                                          code: kodeBarcode.toString(),
                                        )));
                          }
                        }),
                    QRScannerOverlay(
                      overlayColor: bgColor,
                      scanAreaHeight: 390,
                      scanAreaWidth: 345,
                    )
                  ],
                )),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: const Text(
                "",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
