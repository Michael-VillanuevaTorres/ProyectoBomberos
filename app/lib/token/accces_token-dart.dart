import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccessToken {
  String accessToken;

  AccessToken({
    required this.accessToken,
  });

  factory AccessToken.fromRawJson(String str) =>
      AccessToken.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AccessToken.fromJson(Map<String, dynamic> json) => AccessToken(
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
      };
}

class Auth extends ChangeNotifier {
  String? _token;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  String? get token => _token;

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
    notifyListeners();
  }

  Future<void> loadToken() async {
    _token = await _secureStorage.read(
      key: 'token',
    );
    notifyListeners();
  }

  Future<void> clearToken() async {
    _token = null;
    await _secureStorage.delete(key: 'token');
    notifyListeners();
  }
}
