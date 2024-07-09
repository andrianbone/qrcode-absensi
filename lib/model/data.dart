class Data {
  String nik;

  Data({required this.nik});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(nik: json['nik']);
  }
}
