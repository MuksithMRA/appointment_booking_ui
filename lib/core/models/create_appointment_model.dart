import 'dart:convert';

class CreateAppointmentModel {
  int scheduleSlotId;
  int patientId;
  String note;
  CreateAppointmentModel({
    this.scheduleSlotId = 0,
    this.patientId = 0,
    this.note = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'scheduleSlotId': scheduleSlotId,
      'patientId': patientId,
      'note': note,
    };
  }

  factory CreateAppointmentModel.fromMap(Map<String, dynamic> map) {
    return CreateAppointmentModel(
      scheduleSlotId: map['scheduleSlotId'] as int,
      patientId: map['patientId'] as int,
      note: map['note'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CreateAppointmentModel.fromJson(String source) =>
      CreateAppointmentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
