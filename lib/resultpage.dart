import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qrcode_absensi/first_screen.dart';
// import 'package:qr_code_shopee/qr_scanner.dart';
// import 'package:qr_flutter/qr_flutter.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
// // import 'dart:io';
import 'dart:async';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:qrcode_absensi/qr_scanner.dart';

const bgColor = Color(0xfffafafa);
int counter = 0;
int isExist = 0;

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

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
    required this.closeScreen,
    required this.code,
  });

  final String code;
  final Function() closeScreen;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  void initState() {
    getDataSheets();
    super.initState();
  }

  final TextEditingController nikC = TextEditingController();

  Future<List<String>> readData() async {
    var client = await auth.clientViaServiceAccount(
        credentials, [sheets.SheetsApi.spreadsheetsScope]);
    var sheetsApi = sheets.SheetsApi(client);
    var range = 'absensi!A2:A6000';
    var response =
        await sheetsApi.spreadsheets.values.get(_spreadsheetId, range);
    var values = response.values;
    List<List<Object?>>? myList = values == null ? [] : values.toList();
    List<String> stringList =
        myList.map((innerList) => innerList.join()).toList();
    if (values != null && values.isNotEmpty) {
      final rowCount = values.length;
      for (var row in stringList) {
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

  Future<List<String>> getDataSheets() async {
    var client = await auth.clientViaServiceAccount(
        credentials, [sheets.SheetsApi.spreadsheetsScope]);
    var sheetsApi = sheets.SheetsApi(client);
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        return const Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        ));
      },
    );
    var range = 'absensi!A2:A6000';
    var response =
        await sheetsApi.spreadsheets.values.get(_spreadsheetId, range);
    var values = response.values;
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();

    List<List<Object?>>? myList = values == null ? [] : values.toList();

    List<String> stringList =
        myList.map((innerList) => innerList.join()).toList();

    if (values != null && values.isNotEmpty) {
      final rowCount = values.length;
      for (var row in stringList) {
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

  void submitForm() async {
    List<String> data = await readData();

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    const String scriptURL =
        'https://script.google.com/macros/s/AKfycbxp2RbAX5QHh5FeMexBbYpCoEHpznNYAIeS3_M101Hgg_w69bzqyVubzlbLL-zaB3cbFA/exec';

    String tempNik = nikC.text;
    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        return const Center(
            child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        ));
      },
    );
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
              title: "Data dengan NIK $tempNik sudah ada",
              type: ArtSweetAlertType.info));
      Navigator.of(context).pop();
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
          Navigator.of(context).pop();
          Navigator.pushAndRemoveUntil(
              // ignore: use_build_context_synchronously
              context,
              FirstScreen as Route<Object?>,
              (route) => true);
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (BuildContext context) => const FirstScreen()));
        }
      } else {
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
    nikC.text = widget.code;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Absensi",
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
                },
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
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
                },
                child: const Text(
                  "Scan Barcode",
                  style: TextStyle(
                    color: Colors.white,
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
