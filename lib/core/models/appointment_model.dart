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
}
