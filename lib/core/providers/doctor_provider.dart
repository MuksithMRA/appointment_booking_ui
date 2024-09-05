import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../environment.dart';
import '../models/doctor_model.dart';
import '../models/slot_model.dart';
import 'package:http/http.dart' as http;

class DoctorProvider extends ChangeNotifier {
  List<DoctorModel> doctors = [
    DoctorModel(
      id: 1,
      avatar:
          'https://t3.ftcdn.net/jpg/02/60/04/08/360_F_260040863_fYxB1SnrzgJ9AOkcT0hoe7IEFtsPiHAD.jpg',
      doctorFirstName: 'Dr. John',
      doctorLastName: 'Doe',
      specialization: 'Cardiologist',
      slots: [
        SlotModel(
          id: 1,
          scheduleDateTime: DateTime.now(),
          slotStatus: 'Available',
          notes: 'No notes',
        ),
        SlotModel(
          id: 2,
          scheduleDateTime: DateTime.now().add(const Duration(minutes: 15)),
          slotStatus: 'Available',
          notes: 'No notes',
        ),
      ],
    ),
    DoctorModel(
      id: 2,
      avatar:
          'https://t3.ftcdn.net/jpg/02/60/04/08/360_F_260040863_fYxB1SnrzgJ9AOkcT0hoe7IEFtsPiHAD.jpg',
      doctorFirstName: 'Dr. Mike',
      doctorLastName: 'Baker',
      specialization: 'Cardiologist',
      slots: [
        SlotModel(
          id: 1,
          scheduleDateTime: DateTime.now(),
          slotStatus: 'Available',
          notes: 'No notes',
        ),
        SlotModel(
          id: 2,
          scheduleDateTime: DateTime.now().add(const Duration(minutes: 15)),
          slotStatus: 'Available',
          notes: 'No notes',
        ),
      ],
    ),
  ];

  List<SlotModel> getSlotsbyDateTime(DateTime dateTime) {
    List<SlotModel> slots = [];
    for (var doctor in doctors) {
      for (var slot in doctor.slots) {
        if (slot.scheduleDateTime!.year == dateTime.year &&
            slot.scheduleDateTime!.month == dateTime.month &&
            slot.scheduleDateTime!.day == dateTime.day) {
          slots.add(slot);
        }
      }
    }
    return slots.map((slot) {
      return SlotModel(
        id: slot.id,
        slotFormattedTime: DateFormat('HH:mm').format(slot.scheduleDateTime!),
      );
    }).toList();
  }

  void updateSelectedDateTime(int doctorId, DateTime dateTime) {
    for (var doctor in doctors) {
      if (doctor.id == doctorId) {
        doctor.selectedDateTime = dateTime;
      }
    }
    notifyListeners();
  }

  getAll(){
    http.get(Uri.parse(Environment.apiUrl)).then((response){
      log(response.body);
    });
  }
}
