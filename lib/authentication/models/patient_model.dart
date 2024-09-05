import 'dart:convert';

import 'user_model.dart';

class PatientModel {
  int id;
  String avatar;
  String firstName;
  String lastName;
  String gender;
  String phoneNumber;
  String email;
  UserModel? user;
  PatientModel({
    this.id = 0,
    this.avatar = "",
    this.firstName = "",
    this.lastName = "",
    this.gender = "",
    this.phoneNumber = "",
    this.email = "",
    this.user,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'avatar': avatar,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'email': email,
      'userDto': user?.toMap(),
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
      id: map['id'] ?? 0,
      avatar: map['avatar'] ?? "",
      firstName: map['firstName'] ?? "",
      lastName: map['lastName'] ?? "",
      gender: map['gender'] ?? "",
      phoneNumber: map['phoneNumber'] ?? "",
      email: map['email'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory PatientModel.fromJson(String source) =>
      PatientModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
