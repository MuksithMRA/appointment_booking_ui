import 'package:asiri/core/models/doctor_model.dart';

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
}
