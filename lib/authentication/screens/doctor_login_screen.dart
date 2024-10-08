import 'package:asiri/core/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../core/utils/loading_overlay.dart';
import '../providers/authentication_provider.dart';
import '../utils.dart';

class DoctorLoginScreen extends StatefulWidget {
  const DoctorLoginScreen({super.key});

  @override
  State<DoctorLoginScreen> createState() => _DoctorLoginScreenState();
}

class _DoctorLoginScreenState extends State<DoctorLoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return Scaffold(
      body: SizedBox(
        height: ScreenSize.height,
        width: ScreenSize.width,
        child: Row(
          children: [
            loginForm(),
            SizedBox(
              width: ScreenSize.width * 0.6,
              child: Lottie.asset("assets/doctor.json"),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox loginForm() {
    return SizedBox(
      width: ScreenSize.width * 0.4,
      child: Form(
        key: formKey,
        child: Container(
          color: Colors.blue.withAlpha(20),
          padding: EdgeInsets.symmetric(
              vertical: 50, horizontal: ScreenSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Asiri Hospital",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Doctor Login",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email is required";
                  }
                  return null;
                },
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  labelText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
                controller: passwordController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  labelText: "Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: Size(ScreenSize.width, 50),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    (bool, String) response =
                        await LoadingOverlay.of(context).during(
                      context.read<AuthenticationProvider>().loginDoctor(
                            Utils.encryptData(emailController.text.trim()),
                            Utils.encryptData(passwordController.text.trim()),
                          ),
                    );

                    if (response.$1) {
                      formKey.currentState!.reset();
                      Navigator.pushNamedAndRemoveUntil(
                          // ignore: use_build_context_synchronously
                          context,
                          '/doctor/home',
                          (route) => false);
                      // ignore: use_build_context_synchronously
                      Utils.success(context, response.$2);
                    } else {
                      // ignore: use_build_context_synchronously
                      Utils.error(context, response.$2);
                    }
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
