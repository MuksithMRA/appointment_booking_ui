// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import '../../authentication/models/doctor_model.dart';

class SlotModel {
  int id;
  DoctorModel? doctor;
  DateTime? scheduleDateTime;
  String slotFormattedTime;
  String slotStatus;
  String notes;
  SlotModel({
    this.id = 0,
    this.doctor,
    this.slotFormattedTime = "",
    this.scheduleDateTime,
    this.slotStatus = '',
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': scheduleDateTime?.toIso8601String(),
      'start_time': {
        'hours': scheduleDateTime!.hour,
        'minutes': scheduleDateTime!.minute,
      },
      'status': slotStatus,
      'notes': notes,
    };
  }

  factory SlotModel.fromMap(Map<String, dynamic> map) {
    return SlotModel(
      id: map['id'] ?? 0,
      doctor: map['doctor'] != null
          ? DoctorModel.fromMap(map['doctor'] as Map<String, dynamic>)
          : null,
      scheduleDateTime:
          map['date'] != null ? DateTime.parse(map['date']) : null,
      slotFormattedTime: map['startTime'] ?? "",
      slotStatus: map['status'] ?? "",
      notes: map['notes'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory SlotModel.fromJson(String source) =>
      SlotModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
