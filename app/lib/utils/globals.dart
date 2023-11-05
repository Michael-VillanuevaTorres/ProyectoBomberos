import 'package:jwt_decoder/jwt_decoder.dart';

class Globals {
  static String token = "";
  static int returnID(token) {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken["sub"];
  }
}
