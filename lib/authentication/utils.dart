import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../dependencies/secure_storage_service.dart';

class Utils {
  static Toastification toastification = Toastification();
  static Future<Map<String, String>> headers() async {
    return {
      "Authorization":
          "Bearer ${await SecureStorageService.read(key: "token")}",
      "Content-Type": "application/json",
      "Accept": "*/*"
    };
  }

  static error(BuildContext context, String? message) {
    toastification.show(
      backgroundColor: Colors.red,
      context: context,
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
      title: Text(
        message!,
        style: const TextStyle(color: Colors.white),
      ),
      showIcon: true,
      progressBarTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
      ),
      autoCloseDuration: const Duration(seconds: 5),
    );
  }

  static warning(BuildContext context, String? message) {
    toastification.show(
      backgroundColor: Colors.orange,
      context: context,
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
      title: Text(
        message!,
        style: const TextStyle(color: Colors.white),
      ),
      showIcon: true,
      autoCloseDuration: const Duration(seconds: 5),
      progressBarTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
      ),
    );
  }

  static success(BuildContext context, String? message) {
    toastification.show(
      backgroundColor: Colors.green,
      context: context,
      icon: const Icon(
        Icons.check_circle_rounded,
        color: Colors.white,
      ),
      title: Text(
        message!,
        style: const TextStyle(color: Colors.white),
      ),
      showIcon: true,
      autoCloseDuration: const Duration(seconds: 5),
      progressBarTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
      ),
    );
  }

  static String encryptData(String plainText) {
    const key = 'biCMfSqPplcSEDkC';
    const iv = 'KVDT0ZN45KDxUJok';
    final keyBytes = encrypt.Key.fromUtf8(key);
    final ivBytes = encrypt.IV.fromUtf8(iv);

    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: ivBytes);

    return encrypted.base64;
  }

  static String decryptData(String encryptedData) {
    const key = 'biCMfSqPplcSEDkC';
    const iv = 'KVDT0ZN45KDxUJok';
    final keyBytes = encrypt.Key.fromUtf8(key);
    final ivBytes = encrypt.IV.fromUtf8(iv);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(keyBytes, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter
        .decrypt(encrypt.Encrypted.fromBase64(encryptedData), iv: ivBytes);
    return decrypted;
  }
}
