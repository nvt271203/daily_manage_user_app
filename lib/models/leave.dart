import 'dart:convert';

const leaveType = [ 'Sick', 'Personal', 'Other'];
const leaveTimeType = [ 'Full Time', 'Part Time'];
const status = ['Pending', 'Approved', 'Rejected'];

class Leave {
  final String id;
  final DateTime dateCreated;
  final DateTime startDate;
  final DateTime endDate;
  final String leaveType;
  final String leaveTimeType;
  final String reason;
  final String status;
  final String userId;

  Leave({required this.id, required this.dateCreated, required this.startDate, required this.endDate, required this.leaveType, required this.leaveTimeType, required this.reason, required this.status, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      "id": this.id,
      "dateCreated": this.dateCreated.toUtc().toIso8601String(),
      "startDate": this.startDate.toUtc().toIso8601String(),
      "endDate": this.endDate.toUtc().toIso8601String(),
      "leaveType": this.leaveType,
      "leaveTimeType": this.leaveTimeType,
      "reason": this.reason,
      "status": this.status,
      "userId": this.userId,
    };
  }
  String toJson() => jsonEncode(toMap());

  factory Leave.fromMap(Map<String, dynamic> json) {
    return Leave(id: json["_id"],
      dateCreated: DateTime.parse(json["dateCreated"]).toLocal(),
      startDate: DateTime.parse(json["startDate"]).toLocal(),
      endDate: DateTime.parse(json["endDate"]).toLocal(),
      leaveType: json["leaveType"],
      leaveTimeType: json["leaveTimeType"],
      reason: json["reason"],
      status: json["status"],
      userId: json["userId"],);
  }
  factory Leave.fromJson(String json) => Leave.fromMap(jsonDecode(json));



}