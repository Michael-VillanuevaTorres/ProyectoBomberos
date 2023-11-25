import 'dart:convert';

class DateTimes {
  int entryCount;
  List<Entries> entries;
  String totalHoursWorked;
  int userId;

  DateTimes({
    required this.entryCount,
    required this.entries,
    required this.totalHoursWorked,
    required this.userId,
  });

  factory DateTimes.fromRawJson(String str) =>
      DateTimes.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DateTimes.fromJson(Map<String, dynamic> json) => DateTimes(
    entryCount: json["entry_count"],
    entries:
    List<Entries>.from(json["entries"].map((x) => Entries.fromJson(x))),
    totalHoursWorked: json["total_hours_worked"],
    userId: json["user_id"],
  );

  Map<String, dynamic> toJson() => {
    "entry_count": entryCount,
    "entries": List<dynamic>.from(entries.map((x) => x.toJson())),
    "total_hours_worked": totalHoursWorked,
    "user_id": userId,
  };
}

class Entries {
  String entryDateTime;
  String exitDateTime;
  int id;

  Entries({
    required this.entryDateTime,
    required this.exitDateTime,
    required this.id,
  });

  factory Entries.fromRawJson(String str) => Entries.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Entries.fromJson(Map<String, dynamic> json) => Entries(
    entryDateTime: json["entry_date_time"],
    exitDateTime: json["exit_date_time"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "entry_date_time": entryDateTime,
    "exit_date_time": exitDateTime,
    "id": id,
  };
}
