import 'dart:convert';
import 'dart:developer';

import 'package:asiri/authentication/models/doctor_model.dart';
import 'package:asiri/authentication/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../environment.dart';
import '../models/slot_model.dart';
import 'package:http/http.dart' as http;

class DoctorProvider extends ChangeNotifier {
  List<DoctorModel> doctors = [];

  
  void updateSelectedDateTime(int doctorId, DateTime dateTime) {
    for (var doctor in doctors) {
      if (doctor.id == doctorId) {
        doctor.selectedDateTime = dateTime;
      }
    }
    notifyListeners();
  }

  Future<void> getAllDoctors() async {
    try {
      final response = await http.get(
        Uri.parse('${Environment.apiUrl}/CareProvider/GetAll'),
        headers: Utils.headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['statusCode'] == 200) {
          doctors = [];
          for (var element in data['data'] ?? []) {
            DoctorModel doctor = DoctorModel.fromMap(element);
            doctor.slots = await getSlotsByCareProviderId(doctor.id);
            doctors.add(doctor);
          }
          notifyListeners();
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<SlotModel>> getSlotsByCareProviderId(int careProviderId) async {
    List<SlotModel> slots = [];
    try {
      final response = await http.get(
        Uri.parse(
            '${Environment.apiUrl}/ScheduleSlot/GetScheduleSlotsByCareProviderId/$careProviderId'),
        headers: Utils.headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['statusCode'] == 200) {
          for (var element in data['data'] ?? []) {
            SlotModel slot = SlotModel.fromMap(element);
            DateTime dateTime = DateTime(
              slot.scheduleDateTime!.year,
              slot.scheduleDateTime!.month,
              slot.scheduleDateTime!.day,
              int.parse(slot.slotFormattedTime.split(":")[0]),
              int.parse(slot.slotFormattedTime.split(":")[1]),
            );
            slot.scheduleDateTime = dateTime;
            slot.slotFormattedTime = DateFormat('HH:mm').format(dateTime);
            slots.add(slot);
          }
          return slots;
        }
      }
    } catch (e) {
      log(e.toString());
    }
    return slots;
  }
}
