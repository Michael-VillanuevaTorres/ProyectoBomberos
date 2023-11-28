import 'dart:convert';

class Bitacora {
  String dateTime;
  String description;
  double fuelLevel;
  int id;
  double oilLevel;
  String truckPatent;
  String type;
  String user;
  double waterLevel;

  Bitacora({
    required this.dateTime,
    required this.description,
    required this.fuelLevel,
    required this.id,
    required this.oilLevel,
    required this.truckPatent,
    required this.type,
    required this.user,
    required this.waterLevel,
  });

  factory Bitacora.fromRawJson(String str) =>
      Bitacora.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Bitacora.fromJson(Map<String, dynamic> json) => Bitacora(
        dateTime: json["date_time"],
        description: json["description"],
        fuelLevel: json["fuel_level"]?.toDouble(),
        id: json["id"],
        oilLevel: json["oil_level"]?.toDouble(),
        truckPatent: json["truck_patent"],
        type: json["type"],
        user: json["user"],
        waterLevel: json["water_level"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "date_time": dateTime,
        "description": description,
        "fuel_level": fuelLevel,
        "id": id,
        "oil_level": oilLevel,
        "truck_patent": truckPatent,
        "type": type,
        "user": user,
        "water_level": waterLevel,
      };
}
