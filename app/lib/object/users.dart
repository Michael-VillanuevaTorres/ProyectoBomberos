import 'dart:convert';

class User {
  String id;
  String apellido;
  String name;
  int status;

  User({
    required this.id,
    required this.apellido,
    required this.name,
    required this.status,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["_id"],
        apellido: json["apellido"],
        name: json["name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "apellido": apellido,
        "name": name,
        "status": status,
      };
}
