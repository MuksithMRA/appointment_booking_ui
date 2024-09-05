// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  int id;
  String email;
  String role;
  String password;
  String token;
  UserModel({
    this.id = 0,
    this.email = "",
    this.role = "",
    this.password = "",
    this.token = "",
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'role': role,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,
      email: map['email'] ?? "",
      role: map['role'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
