import 'package:asiri/authentication/providers/authentication_provider.dart';
import 'package:asiri/authentication/utils.dart';
import 'package:asiri/core/utils/loading_overlay.dart';
import 'package:asiri/core/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginTabWidget extends StatefulWidget {
  const LoginTabWidget({super.key});

  @override
  State<LoginTabWidget> createState() => _LoginTabWidgetState();
}

class _LoginTabWidgetState extends State<LoginTabWidget> {
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
      child: Form(
          key: formKey,
          child: Column(
            children: [
              SvgPicture.asset(
                "assets/login.svg",
                height: 200,
              ),
              const SizedBox(height: 20),
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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
                obscureText: true,
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
                      context.read<AuthenticationProvider>().loginPatient(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                          ),
                    );

                    if (response.$1) {
                      formKey.currentState!.reset();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                      Utils.success(context, response.$2);
                    } else {
                      Utils.error(context, response.$2);
                    }
                  }
                },
                child: const Text("Login"),
              )
            ],
          )),
    );
  }
}
