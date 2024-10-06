// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PatientModel {
  String avatar;
  String firstName;
  String lastName;
  String gender;
  String phoneNumber;
  String email;
  PatientModel({
    this.avatar = "",
    this.firstName = "",
    this.lastName = "",
    this.gender = "",
    this.phoneNumber = "",
    this.email = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'avatar': avatar,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  factory PatientModel.fromMap(Map<String, dynamic> map) {
    return PatientModel(
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
