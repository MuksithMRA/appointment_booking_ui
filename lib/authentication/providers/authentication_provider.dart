import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../dependencies/secure_storage_service.dart';
import '../../environment.dart';
import '../models/doctor_model.dart';
import '../models/patient_model.dart';
import '../utils.dart';

class AuthenticationProvider extends ChangeNotifier {
  bool? isLoggedIn;
  String avatar = "";
  String fullName = "";
  String role = "";

  Future<(bool, String)> registerPatient(PatientModel model) async {
    try {
      final http.Response response = await http.post(
        Uri.parse("${Environment.apiUrl}/Authentication/RegisterPatient"),
        headers: await Utils.headers(),
        body: model.toJson(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['statusCode'] == 200) {
          return (true, data['message'].toString());
        } else {
          return (false, data['message'].toString());
        }
      }
    } on Exception catch (ex) {
      log(ex.toString());
      return (false, ex.toString());
    }
    return (false, "Something went wrong!");
  }

  Future<(bool, String)> registerDoctor(DoctorModel model) async {
    try {
      final http.Response response = await http.post(
        Uri.parse("${Environment.apiUrl}/Authentication/RegisterCareProvider"),
        headers: await Utils.headers(),
        body: model.toJson(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['statusCode'] == 200) {
          return (true, data['message'].toString());
        } else {
          return (false, data['message'].toString());
        }
      }
    } on Exception catch (ex) {
      log(ex.toString());
      return (false, ex.toString());
    }
    return (false, "Something went wrong!");
  }

  Future<(bool, String)> loginPatient(String email, String password) async {
    try {
      final http.Response response = await http.post(
        Uri.parse("${Environment.apiUrl}/Authentication/PatientLogin"),
        headers: await Utils.headers(),
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['statusCode'] == 200) {
          isLoggedIn = true;
          avatar = data['data']["avatar"];
          fullName = data['data']["firstName"] + " " + data['data']["lastName"];
          role = "PATIENT";
          notifyListeners();
          await SecureStorageService.write(
              key: "token", value: data['data']["userDto"]['token']);
          await SecureStorageService.write(key: "fullName", value: fullName);
          await SecureStorageService.write(key: "avatar", value: avatar);
          await SecureStorageService.write(key: "role", value: role);
          return (true, data['message'].toString());
        } else {
          return (false, data['message'].toString());
        }
      }
    } on Exception catch (ex) {
      log(ex.toString());
      return (false, ex.toString());
    }
    return (false, "Something went wrong!");
  }

  Future<(bool, String)> loginDoctor(String email, String password) async {
    try {
      final http.Response response = await http.post(
        Uri.parse("${Environment.apiUrl}/Authentication/CareProviderLogin"),
        headers: await Utils.headers(),
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['statusCode'] == 200) {
          isLoggedIn = true;
          avatar = data['data']["avatar"];
          fullName = data['data']["firstName"] + " " + data['data']["lastName"];
          role = "DOCTOR";
          notifyListeners();
          await SecureStorageService.write(
              key: "token", value: data['data']["userDto"]['token']);
          await SecureStorageService.write(key: "fullName", value: fullName);
          await SecureStorageService.write(key: "avatar", value: avatar);
          await SecureStorageService.write(key: "role", value: role);
          return (true, data['message'].toString());
        } else {
          return (false, data['message'].toString());
        }
      }
    } on Exception catch (ex) {
      log(ex.toString());
      return (false, ex.toString());
    }
    return (false, "Something went wrong!");
  }

  void isLoggedInTrigger() async {
    isLoggedIn = await checkIfLoggedIn();
    if (isLoggedIn ?? false) {
      fullName = await SecureStorageService.read(key: "fullName") ?? "";
      avatar = await SecureStorageService.read(key: "avatar") ?? "";
    }
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      isLoggedIn = await checkIfLoggedIn();
      notifyListeners();
    });
  }

  Future<bool> checkIfLoggedIn() async {
    return SecureStorageService.exists(key: "token").then((value) => value);
  }

  Future<void> logout() async {
    await SecureStorageService.delete(key: "token");
    await SecureStorageService.delete(key: "fullName");
    await SecureStorageService.delete(key: "avatar");
    isLoggedIn = false;
    notifyListeners();
  }
}
