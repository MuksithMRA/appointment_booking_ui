import 'package:asiri/dependencies/secure_storage_service.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (await SecureStorageService.exists(key: "token")) {
        if (await SecureStorageService.exists(key: "role")) {
          if (await SecureStorageService.read(key: "role") == "DOCTOR") {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, "/doctor/home");
          } else {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, "/home");
          }
        }
      } else {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, "/home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
