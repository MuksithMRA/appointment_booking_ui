import 'slot_model.dart';

class DoctorModel {
  int id;
  String avatar;
  String doctorFirstName;
  String doctorLastName;
  String specialization;
  List<SlotModel> slots;
  DateTime selectedDateTime = DateTime.now();
  DoctorModel({
    this.id = 0,
    this.avatar = '',
    this.doctorFirstName = '',
    this.doctorLastName = '',
    this.specialization = '',
    this.slots = const [],
  });

  bool isToday() {
    return isSameDate(DateTime.now(), selectedDateTime);
  }

  bool isTomorrow() {
    return isSameDate(
        DateTime.now().add(const Duration(days: 1)), selectedDateTime);
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
