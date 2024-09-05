// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:asiri/authentication/models/user_model.dart';
import 'package:asiri/core/models/slot_model.dart';
import 'package:intl/intl.dart';

class DoctorModel {
  int id;
  String avatar;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String specialization;
  bool isActive;
  DateTime selectedDateTime = DateTime.now();
  UserModel? user;
  List<SlotModel> slots;
  DoctorModel({
    this.id = 0,
    this.avatar = "",
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.phoneNumber = "",
    this.specialization = "",
    this.isActive = false,
    this.user,
    this.slots = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'avatar': avatar,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'specialization': specialization,
      'isActive': isActive,
      'userDto': user?.toMap(),
    };
  }

  factory DoctorModel.fromMap(Map<String, dynamic> map) {
    return DoctorModel(
      id: map['id'] ?? 0,
      avatar: map['avatar'] ?? "",
      firstName: map['firstName'] ?? "",
      lastName: map['lastName'] ?? "",
      email: map['email'] ?? "",
      phoneNumber: map['phoneNumber'] ?? "",
      specialization: map['specializationDto']["description"] ?? "",
      isActive: map['isActive'] ?? false,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DoctorModel.fromJson(String source) =>
      DoctorModel.fromMap(json.decode(source) as Map<String, dynamic>);

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

  List<SlotModel> getSlotsbyDateTime() {
    List<SlotModel> slots = [];
    for (var slot in this.slots) {
      if (slot.scheduleDateTime!.year == selectedDateTime.year &&
          slot.scheduleDateTime!.month == selectedDateTime.month &&
          slot.scheduleDateTime!.day == selectedDateTime.day) {
        slots.add(slot);
      }
    }
    return slots;
  }
}
