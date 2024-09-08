import 'dart:convert';

import 'package:asiri/core/models/slot_model.dart';
import 'package:asiri/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../authentication/utils.dart';

class SlotProvider extends ChangeNotifier {
  List<SlotModel> slots = [];

  Future<(bool, String)> addSlot(SlotModel slot) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${Environment.apiUrl}/ScheduleSlot/CreateOrUpdateScheduleSlot'),
        headers: await Utils.headers(),
        body: slot.toJson(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['statusCode'] == 200) {
          return (true, data['message'].toString());
        } else {
          return (false, data['message'].toString());
        }
      }
      return (true, "Slot added successfully");
    } catch (e) {
      return (false, "Failed to add slot");
    }
  }
}
