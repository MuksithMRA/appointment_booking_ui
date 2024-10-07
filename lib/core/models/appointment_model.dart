class AppointmentModel {
  int id;
  String patientName;
  DateTime? scheduledDateTime = DateTime.now();
  String status;
  AppointmentModel({
    this.id = 0,
    this.patientName = '',
    this.scheduledDateTime,
    this.status = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'patientName': patientName,
      'scheduledDateTime': scheduledDateTime?.toIso8601String(),
      'status': status,
    };
  }

  factory AppointmentModel.fromMap(Map<String, dynamic> map) {
    return AppointmentModel(
      id: map['id'] ?? 0,
      patientName: map['patientName'] ?? '',
      scheduledDateTime: map['scheduledDateTime'] != null
          ? DateTime.parse(map['scheduledDateTime'] ?? "1990-01-01")
          : null,
      status: map['status'] as String,
    );
  }
}
