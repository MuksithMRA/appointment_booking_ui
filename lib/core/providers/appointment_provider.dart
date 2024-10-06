import 'dart:convert';
import 'dart:developer';

import 'package:asiri/core/models/appointment_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../authentication/utils.dart';
import '../../environment.dart';

class AppointmentProvider extends ChangeNotifier {
  List<AppointmentModel> appointments = [];
  Future<void> getAppointmentsByDoctor() async {
    appointments = [];
    try {
      final response = await http.get(
        Uri.parse('${Environment.apiUrl}/Appointement/GetAppointementsByCareProviderId'),
        headers: await Utils.headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['statusCode'] == 200) {
          for (var element in data['data'] ?? []) {
              
          }
          notifyListeners();
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
