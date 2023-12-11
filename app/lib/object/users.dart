import 'dart:convert';

class User {
  String email;
  String firstName;
  int id;
  String? image;
  String lastName;
  String role;
  int state;
  String userName;

  User({
    required this.email,
    required this.firstName,
    required this.id,
    required this.image,
    required this.lastName,
    required this.role,
    required this.state,
    required this.userName,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        firstName: json["first_name"],
        id: json["id"],
        image: json["image"],
        lastName: json["last_name"],
        role: json["role"],
        state: json["state"],
        userName: json["user_name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "first_name": firstName,
        "id": id,
        "image": image,
        "last_name": lastName,
        "role": role,
        "state": state,
        "user_name": userName,
      };
}
