import 'dart:convert';

class times {
  DateTime entryTime;
  DateTime exitTime;
  int id;
  int userId;

  times({
    required this.entryTime,
    required this.exitTime,
    required this.id,
    required this.userId,
  });

  factory times.fromRawJson(String str) => times.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory times.fromJson(Map<String, dynamic> json) => times(
        entryTime: DateTime.parse(json["entry_time"]),
        exitTime: DateTime.parse(json["exit_time"]),
        id: json["id"],
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "entry_time": entryTime.toIso8601String(),
        "exit_time": exitTime.toIso8601String(),
        "id": id,
        "user_id": userId,
      };
}

class Datatimes {
  int entryCount;
  List<times> entrytimes;
  double totalHoursWorked;
  int userId;

  Datatimes({
    required this.entryCount,
    required this.entrytimes,
    required this.totalHoursWorked,
    required this.userId,
  });

  factory Datatimes.fromRawJson(String str) =>
      Datatimes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datatimes.fromJson(Map<String, dynamic> json) => Datatimes(
        entryCount: json["entry_count"],
        entrytimes:
            List<times>.from(json["entrytimes"].map((x) => times.fromJson(x))),
        totalHoursWorked: json["total_hours_worked"]?.toDouble(),
        userId: json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "entry_count": entryCount,
        "entrytimes": List<dynamic>.from(entrytimes.map((x) => x.toJson())),
        "total_hours_worked": totalHoursWorked,
        "user_id": userId,
      };
}
