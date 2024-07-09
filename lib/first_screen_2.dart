import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:intl/intl.dart';
import 'package:qrcode_absensi/model/data.dart';
import 'package:qrcode_absensi/qr_scanner.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:gsheets/gsheets.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart' as auth;
// import 'dart:convert' as convert;
// import 'dart:convert';

const bgColor = Color(0xfffafafa);
int counter = 0;
int isExist = 0;

// int getCount = 0;

const _credentials = r'''
{
  "type": "service_account",
  "project_id": "absensi-project-428303",
  "private_key_id": "e80a6b91f4ac20a7a220f5dcacc9b0745b0c43fa",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCoFuV5ALt8e9mh\npxZ9lD/UHcrNxDinFpFo94U7SidSeEzXLp3rXsgUoXRv6vQSNpubvlmMY3F3M2J6\n82obsap3AjxaTuixWl6KMiY1GyC/9mLXc/Eg8wI8JRx8UBO1vvtAGY8TUV+W/mdV\nLemn93fPyg/dZh9WrEVgiyLjbhrX+Me/yiEuj5Vsiow113oOFAWLn2T3LwqDKLzt\nC3VQDt+Uy0VyB5mngw6e+3N4AnzlJUtkTfL7PRjC5V737S+oEyOCe8wj8Er1K1v8\nnyn2eKAJ3sAa87Agaoyo9t4rbOOBc3nK93AK2zrGrMNH8OK231GwiUMjvPGphZAo\nX292ebuNAgMBAAECggEABytw2XmJRbz0/RLxio+QrcAhPCfRlc5Ii15mya8MSyrT\n9j1oDC0vDMg6kqKGNiJWVAKUHcDzyvaUuF4FHuN0EV71oDwrlehe+MyST3jAgRz7\nPX7rIFwVMpJlAGgcVcfXaODI4Z/6hegvPqrLw7fHyG5xQPY/7HRtLM91KxfGyoL2\n9FEwnOuiiV6NP7lHQXhSpPeMrHMi2tW56RW5U+TGGXLmgzfrUuZZS98IQV4wYmna\nDBVTqiRQofuJm6miD5c60lhUMfsfZ4kSfq3IhlkNuUQa7L7VEK0fyG/t34pi/R0J\nqCpJVlqrRfEMU76VH5WxpehwINZp00J9x6TlMZKrkQKBgQDRtD687zD4KKPelk3n\nRqmUljAju0rjeKmPDwQMrh6/u3pGtV/++E3K00dD0OnsaJas6tC22Mu5eRO3AGdT\n/N5qxiCNV1n5VRSlPzznIMyH7j/B4V7kAVU5iSN9sxbHS1b33vDTHJCZzi7KDfuT\naV89748Fi3p2S4J6j/C0RG7W0QKBgQDNMrwIpr0uP7QKLRmXC47o1sTA2zOnI5je\nCx54u2MzduZqoN3r8kQPRziDWW1fnMdbApQVe9FUNexXy2P4BbhMIdG4pX/2F+va\nMiDop+/XJkR5IRk+q4g2sPNVCnD4dSU8cuFc/RDK/rxcEuaR8uxLQZ1O2t8gkv/W\nWxEJ1XI//QKBgC+7/cP4FoeGiLa0NAt/ND7UaSTZD1T0NHSSEHPqdqliPZU22CEr\n2Flg+onfVkAwFoxJ7zSP6N/RRcGUX/DoUKCxdNt3lM2Cpm5vFKfv+V6/xteVO4pf\nG007gE6uo3K+HY/SubL0f53jJxdrU2bcx4dLrpyugTPIQG0xsrL2GNzhAoGBAJ/H\njKET7KVRl0iBO7bgmiP17/jX9s2Dq2nisJSEHUeaouqOXp914scexwOII+Fae+UD\nCfn8ktAGuQTX6/zZv1sQznP/8rbWg6FAfV2MPvaB5rmHK1ggSw2DFca3PaZJ2XfL\nYG5+44+dcWAkm4Mz7Ajhi7M2PJ3puOrZuFe266KlAoGAaVvSj+Gy0Vij+os4jvtE\nfUHYfv2DK6BIBDAWJLW9oKIsgxwQgDxYCrmqFTYnmyUyylF2Qg11VEfmWiwsL5MW\nQlBg4cQ05WXdUSimM3oet4Tuwno+1xToZ79G4dAgmTqJf+qJ44awtuH6eBgUVVZ2\neHeR4xdQt78B5CmAgHdCA+w=\n-----END PRIVATE KEY-----\n",
  "client_email": "absensi-project@absensi-project-428303.iam.gserviceaccount.com",
  "client_id": "105736064428045743472",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/absensi-project%40absensi-project-428303.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

var credentials = auth.ServiceAccountCredentials.fromJson(r'''
    {
  "type": "service_account",
  "project_id": "absensi-project-428303",
  "private_key_id": "e80a6b91f4ac20a7a220f5dcacc9b0745b0c43fa",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCoFuV5ALt8e9mh\npxZ9lD/UHcrNxDinFpFo94U7SidSeEzXLp3rXsgUoXRv6vQSNpubvlmMY3F3M2J6\n82obsap3AjxaTuixWl6KMiY1GyC/9mLXc/Eg8wI8JRx8UBO1vvtAGY8TUV+W/mdV\nLemn93fPyg/dZh9WrEVgiyLjbhrX+Me/yiEuj5Vsiow113oOFAWLn2T3LwqDKLzt\nC3VQDt+Uy0VyB5mngw6e+3N4AnzlJUtkTfL7PRjC5V737S+oEyOCe8wj8Er1K1v8\nnyn2eKAJ3sAa87Agaoyo9t4rbOOBc3nK93AK2zrGrMNH8OK231GwiUMjvPGphZAo\nX292ebuNAgMBAAECggEABytw2XmJRbz0/RLxio+QrcAhPCfRlc5Ii15mya8MSyrT\n9j1oDC0vDMg6kqKGNiJWVAKUHcDzyvaUuF4FHuN0EV71oDwrlehe+MyST3jAgRz7\nPX7rIFwVMpJlAGgcVcfXaODI4Z/6hegvPqrLw7fHyG5xQPY/7HRtLM91KxfGyoL2\n9FEwnOuiiV6NP7lHQXhSpPeMrHMi2tW56RW5U+TGGXLmgzfrUuZZS98IQV4wYmna\nDBVTqiRQofuJm6miD5c60lhUMfsfZ4kSfq3IhlkNuUQa7L7VEK0fyG/t34pi/R0J\nqCpJVlqrRfEMU76VH5WxpehwINZp00J9x6TlMZKrkQKBgQDRtD687zD4KKPelk3n\nRqmUljAju0rjeKmPDwQMrh6/u3pGtV/++E3K00dD0OnsaJas6tC22Mu5eRO3AGdT\n/N5qxiCNV1n5VRSlPzznIMyH7j/B4V7kAVU5iSN9sxbHS1b33vDTHJCZzi7KDfuT\naV89748Fi3p2S4J6j/C0RG7W0QKBgQDNMrwIpr0uP7QKLRmXC47o1sTA2zOnI5je\nCx54u2MzduZqoN3r8kQPRziDWW1fnMdbApQVe9FUNexXy2P4BbhMIdG4pX/2F+va\nMiDop+/XJkR5IRk+q4g2sPNVCnD4dSU8cuFc/RDK/rxcEuaR8uxLQZ1O2t8gkv/W\nWxEJ1XI//QKBgC+7/cP4FoeGiLa0NAt/ND7UaSTZD1T0NHSSEHPqdqliPZU22CEr\n2Flg+onfVkAwFoxJ7zSP6N/RRcGUX/DoUKCxdNt3lM2Cpm5vFKfv+V6/xteVO4pf\nG007gE6uo3K+HY/SubL0f53jJxdrU2bcx4dLrpyugTPIQG0xsrL2GNzhAoGBAJ/H\njKET7KVRl0iBO7bgmiP17/jX9s2Dq2nisJSEHUeaouqOXp914scexwOII+Fae+UD\nCfn8ktAGuQTX6/zZv1sQznP/8rbWg6FAfV2MPvaB5rmHK1ggSw2DFca3PaZJ2XfL\nYG5+44+dcWAkm4Mz7Ajhi7M2PJ3puOrZuFe266KlAoGAaVvSj+Gy0Vij+os4jvtE\nfUHYfv2DK6BIBDAWJLW9oKIsgxwQgDxYCrmqFTYnmyUyylF2Qg11VEfmWiwsL5MW\nQlBg4cQ05WXdUSimM3oet4Tuwno+1xToZ79G4dAgmTqJf+qJ44awtuH6eBgUVVZ2\neHeR4xdQt78B5CmAgHdCA+w=\n-----END PRIVATE KEY-----\n",
  "client_email": "absensi-project@absensi-project-428303.iam.gserviceaccount.com",
  "client_id": "105736064428045743472",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/absensi-project%40absensi-project-428303.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
    }
  ''');

const String _spreadsheetId = '1AIE81DbmuJbPUxyZG5XNITf2S1KEPoy9ZCgWMSwebxI';

class FirstScreen2 extends StatefulWidget {
  const FirstScreen2({super.key});

  @override
  State<FirstScreen2> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen2> {
  final _formKey = GlobalKey<FormState>();
  List<Data> _dataList = [];
  @override
  void initState() {
    // getCounterData();
    readData();
    super.initState();
    // Timer.periodic(const Duration(seconds: 1), (timer) {
    //   if (mounted) {
    //     // setState(() {
    //     //   counter;
    //     //   print(counter);
    //     // });
    //   }
    // });
  }

  Future getCounterData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    int counter_ = sharedPreferences.getInt("counter") as int;
    setState(() {
      counter = counter_;
    });
  }

  void _incrementCounter() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setInt("counter", counter);
    setState(() {
      counter++;
    });
  }

  void _resetCounter() async {
    clearToAssetFile();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.remove("counter");
    setState(() {
      counter = 0;
    });
  }

  final TextEditingController nikC = TextEditingController();
  String fileContent = '';
  var time = DateTime.now();
  // var newDate = '${time.day}-${time.month}-${time.year} ${time.hour}:${time.minute}:${time.second}';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/myfile.txt');
  }

  Future<File> writeContent(String content) async {
    final file = await _localFile;
    return file.writeAsString(content);
  }

  void _writeToFile() async {
    final text = nikC.text;
    if (text.isNotEmpty) {
      await writeContent(text);
      nikC.clear();
    }
  }

  Future<String> readContent() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return 'Error reading file: $e';
    }
  }

  void _readFromFile() async {
    String content = await readContent();
    setState(() {
      fileContent = content;
    });
  }

  Future<void> writeToAssetFile() async {
    // String data = await rootBundle.loadString('assets/absen.txt');
    final text = nikC.text;
    var path = "/storage/emulated/0/Download/absen.txt";
    var file = File(path);

    if (text.isNotEmpty) {
      await file.writeAsString(
          '${nikC.text} ${time.day}-${time.month}-${time.year} ${time.hour}:${time.minute}:${time.second}\n',
          mode: FileMode.append);
      // ignore: use_build_context_synchronously
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

  Future<void> clearToAssetFile() async {
    // String data = await rootBundle.loadString('assets/absen.txt');
    // print(data);
    var path = "/storage/emulated/0/Download/absen.txt";
    var file = File(path);
    // Write the initial data to the file
    await file.writeAsString(
      '',
    );
    // ignore: use_build_context_synchronously
    await ArtSweetAlert.show(
        barrierDismissible: true,
        // ignore: use_build_context_synchronously
        context: context,
        artDialogArgs: ArtDialogArgs(
            title: "Succes , Isi Data File txt. Telah Di Hapus..",
            type: ArtSweetAlertType.info));
    // ignore: use_build_context_synchronously
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //     content: Text(
    //   'Succes , Data Tersimpan..',
    //   textAlign: TextAlign.center,
    //   style: TextStyle(
    //       color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    // )));
  }

  Future<List<String>> readData() async {
    var client = await auth.clientViaServiceAccount(
        credentials, [sheets.SheetsApi.spreadsheetsScope]);
    var sheetsApi = sheets.SheetsApi(client);
    var range = 'absensi!A2:A6000';
    var response =
        await sheetsApi.spreadsheets.values.get(_spreadsheetId, range);
    var values = response.values;
    // String tempNik = nikC.text;
    List<List<Object?>>? myList = values;
    List<String> stringList =
        myList!.map((innerList) => innerList.join()).toList();
    if (values != null && values.isNotEmpty) {
      final rowCount = values.length;
      for (var row in stringList) {
        // // if (tempNik == row) {
        // //   print('ada duplicate data');
        // // } else {
        // //   print('masuk else');
        // //   print(row);
        // // }
        print(row);
      }
      setState(() {
        counter = rowCount;
      });
    } else {
      print('Tidak ada data yang ditemukan.');
    }
    client.close();
    return stringList;
  }

  Future<void> getData() async {
    const String scriptURL =
        'https://script.google.com/macros/s/AKfycbxp2RbAX5QHh5FeMexBbYpCoEHpznNYAIeS3_M101Hgg_w69bzqyVubzlbLL-zaB3cbFA/exec';
    var finalURI = Uri.parse(scriptURL);
    var response = await http.get(finalURI);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final data = jsonData.map((e) => Data.fromJson(e)).toList();
      print(data);
      print('-**-*-*-*-*-');
      for (var item in data) {
        if (!_dataList.any((element) => element.nik == item.nik)) {
          _dataList.add(item);
        }
      }
    } else {
      print('Failed to load data');
    }
  }

  void readDatafromGSheet() async {
    final gsheets = GSheets(_credentials);
    final ss = await gsheets.spreadsheet(_spreadsheetId);
    var sheet = ss.worksheetByTitle('absensi');
    int rows = sheet!.rowCount;
    print(rows);
    print(rows);
    List<Cell> cellsRow;
    for (var i = 1; i < rows; i++) {
      cellsRow = await sheet.cells.row(i);
      print(cellsRow.elementAt(0).value);
    }
  }

  void _submitForm() async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    // if (_formKey.currentState!.validate()) {
    const String scriptURL =
        'https://script.google.com/macros/s/AKfycbxp2RbAX5QHh5FeMexBbYpCoEHpznNYAIeS3_M101Hgg_w69bzqyVubzlbLL-zaB3cbFA/exec';

    String tempNik = nikC.text;
    String tempTgl = "$formattedDate $formattedTime";
    String queryString = "?nik=$tempNik&tanggal=$tempTgl";
    var finalURI = Uri.parse(scriptURL + queryString);
    var response = await http.get(finalURI);
    if (response.statusCode == 200) {
      // final jsonData = jsonDecode(response.body);
      // final data = jsonData.map((e) => Data.fromJson(e)).toList();
      // print(data);
      // print('---+----+---+---+');
      // for (var item in data) {
      //   final existingItem =
      //       _dataList.firstWhere((element) => element.nik == item.nik);
      //   if (existingItem != null) {
      //     print('masuk sini');
      //     existingItem.nik = item.nik;
      //   } else {
      //     print('masuk else');
      //     _dataList.add(item);
      //   }
      // }

      if (response.body.contains('error')) {
        print('masuk error');
        print('Error: ${response.body}');
      } else {
        print('Data inserted successfully!');
        nikC.clear();
        readData();
      }
    } else {
      print('masuk error else');
      print('Error: ${response.statusCode}');
    }
  }

  void submitForm() async {
    List<String> data = await readData();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    const String scriptURL =
        'https://script.google.com/macros/s/AKfycbxp2RbAX5QHh5FeMexBbYpCoEHpznNYAIeS3_M101Hgg_w69bzqyVubzlbLL-zaB3cbFA/exec';

    String tempNik = nikC.text;
    for (var row in data) {
      if (tempNik == row) {
        isExist = 1;
        print('ada duplicate data');
      }
    }
    if (isExist == 1) {
      print('ada duplicate data');
      await ArtSweetAlert.show(
          barrierDismissible: true,
          context: context,
          artDialogArgs: ArtDialogArgs(
              title: "Ada Duplicate Data..", type: ArtSweetAlertType.info));
      isExist = 0;
    } else {
      print('tidak ada duplicate data');
      String tempTgl = "$formattedDate $formattedTime";
      String queryString = "?nik=$tempNik&tanggal=$tempTgl";
      var finalURI = Uri.parse(scriptURL + queryString);
      var response = await http.get(finalURI);
      if (response.statusCode == 200) {
        print('Response: ${response.body}');
        // Check if the response body contains any error messages
        if (response.body.contains('error')) {
          // print('masuk error');
          // print('Error: ${response.body}');
          await ArtSweetAlert.show(
              barrierDismissible: true,
              context: context,
              artDialogArgs: ArtDialogArgs(
                  title: "Error: ${response.body}",
                  type: ArtSweetAlertType.info));
        } else {
          print('Data inserted successfully!');
          await ArtSweetAlert.show(
              barrierDismissible: true,
              context: context,
              artDialogArgs: ArtDialogArgs(
                  title: "Succes , Data Berhasil Disimpan..",
                  type: ArtSweetAlertType.info));
          nikC.clear();
          readData();
        }
      } else {
        // print('masuk error else');
        // print('Error: ${response.statusCode}');
        await ArtSweetAlert.show(
            barrierDismissible: true,
            context: context,
            artDialogArgs: ArtDialogArgs(
                title: "Error: ${response.statusCode}",
                type: ArtSweetAlertType.info));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      // drawer: const Drawer(),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                // _resetCounter();
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //     builder: (context) => const FirstScreen()));
              },
              icon: const Icon(Icons.restore_from_trash_rounded,
                  color: Colors.white)),
        ],
        // iconTheme: const IconThemeData(color: Colors.black87),
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
        key: _formKey,
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Please Input Manual NIK",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text(
                  "Please klik button Scan Barcode for Scanning",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Total Input/Scan : $counter ",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
              ],
            )),
            const SizedBox(
              height: 20,
            ),
            TextField(
              autocorrect: false,
              controller: nikC,
              keyboardType: TextInputType.number,
              readOnly: false,
              // maxLength: 20,
              decoration: InputDecoration(
                labelText: "NIK",
                hintText: '',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  submitForm();
                  // readData();
                  // getData();
                  // _submitForm();
                  // readDatafromGSheet();
                  // writeToAssetFile();
                  // // _writeToFile();
                  // _incrementCounter();
                  // await ArtSweetAlert.show(
                  //     barrierDismissible: true,
                  //     context: context,
                  //     artDialogArgs: ArtDialogArgs(
                  //         title: "Succes , Data Berhasil Disimpan..",
                  //         type: ArtSweetAlertType.info));
                  // nikC.clear();
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    // color: Colors.black87,
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const QRScanner()));

                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ResultScreen(
                  //               code: '23056',
                  //               closeScreen: () {},
                  //               // kode_barcode: kode_barcode
                  //               // product: Barcode(rawValue: rawValue)
                  //             )));
                  // await ArtSweetAlert.show(
                  //     barrierDismissible: true,
                  //     context: context,
                  //     artDialogArgs: ArtDialogArgs(
                  //         title: "Route Result..",
                  //         type: ArtSweetAlertType.info));
                },
                child: const Text(
                  "Scan Barcode",
                  style: TextStyle(
                    // color: Colors.black87,
                    fontSize: 20,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
            Expanded(
                child: Container(
              alignment: Alignment.center,
              child: const Text(
                "Developed by IT Broadcast 2024 V.2",
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
