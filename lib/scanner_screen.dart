// import 'dart:async';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:qrcode_absensi/first_screen.dart';
// import 'package:qr_code_shopee/qr_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({
    super.key,
    required this.closeScreen,
    required this.code,
  });

  final String code;
  final Function() closeScreen;

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final TextEditingController nikC = TextEditingController();
  var time = DateTime.now();
  void _incrementCounter() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setInt("counter", counter);
    setState(() {
      counter++;
    });
  }

  Future<void> writeToAssetFile() async {
    // String data = await rootBundle.loadString('assets/absen.txt');
    // print(data);
    final text = nikC.text;
    var path = "/storage/emulated/0/Download/absen.txt";
    var file = File(path);

    if (text.isNotEmpty) {
      await file.writeAsString(
          '${nikC.text} ${time.day}-${time.month}-${time.year} ${time.hour}:${time.minute}:${time.second}\n',
          mode: FileMode.append);

      // ignore: use_build_context_synchronously
      await ArtSweetAlert.show(
          barrierDismissible: true,
          // ignore: use_build_context_synchronously
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "Succes , Data Berhasil Disimpan..",
              type: ArtSweetAlertType.info));

      // ignore: use_build_context_synchronously
      // Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const FirstScreen()));
    }
    // Write the initial data to the file

    // ignore: use_build_context_synchronously
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text(
    //   'Succes , Data Tersimpan..',
    //   textAlign: TextAlign.center,
    //   style: TextStyle(
    //       color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    // )));
  }

  @override
  Widget build(BuildContext context) {
    nikC.text = widget.code;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
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
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //show QR Code here
            QrImageView(
              data: widget.code,
              size: 180,
              version: QrVersions.auto,
            ),
            const Text(
              "Scanned Result",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              autocorrect: false,
              controller: nikC,
              keyboardType: TextInputType.number,
              readOnly: false,
              // maxLength: 20,
              decoration: InputDecoration(
                labelText: "NIK",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 100,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  writeToAssetFile();
                  _incrementCounter();
                },
                child: const Text(
                  "Absen",
                  style: TextStyle(
                    // color: Colors.black87,
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
