import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../authentication/models/patient_model.dart';
import '../../authentication/utils.dart';
import '../../environment.dart';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  PatientModel? patient;

  Future<String> loadMyPatientProfile() async {
    try {
      final response = await http.get(
        Uri.parse('${Environment.apiUrl}/Patient/GetById'),
        headers: await Utils.headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['statusCode'] == 200) {
          patient = PatientModel.fromMap(data['data']);
          notifyListeners();
          return "";
        }
      }
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
    return "Something went wrong";
  }
}
