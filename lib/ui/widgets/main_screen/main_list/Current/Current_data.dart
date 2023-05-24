class CurrrentData {
  int id;
  String name;
  String email;

  CurrrentData({
    required this.id,
    required this.name,
    required this.email,
  });

  factory CurrrentData.fromJson(Map<String, dynamic> json) {
    return CurrrentData(
      id: json["id"] as int,
      name: json["name"] as String,
      email: json["email"] as String,
    );
  }
}
