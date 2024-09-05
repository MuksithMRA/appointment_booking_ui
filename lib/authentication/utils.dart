import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../dependencies/secure_storage_service.dart';

class Utils {
 

  static Map<String, String> headers() {
    return {
      "Authorization": "Bearer ${SecureStorageService.read(key: "token")}",
      "Content-Type": "application/json",
    };
  }

  static error(BuildContext context, String? message) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.error,
        color: Colors.red,
      ),
      title: 'Error',
      message: message,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static warning(BuildContext context, String? message) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.warning,
        color: Colors.orange,
      ),
      title: 'Warning',
      message: message,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  static success(BuildContext context, String? message) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      icon: const Icon(
        Icons.check,
        color: Colors.green,
      ),
      title: 'Success',
      message: message,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}
