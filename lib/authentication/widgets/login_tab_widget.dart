import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../core/utils/loading_overlay.dart';
import '../../core/utils/screen_size.dart';
import '../../dependencies/secure_storage_service.dart';
import '../providers/authentication_provider.dart';
import '../utils.dart';

class LoginTabWidget extends StatefulWidget {
  const LoginTabWidget({super.key});

  @override
  State<LoginTabWidget> createState() => _LoginTabWidgetState();
}

class _LoginTabWidgetState extends State<LoginTabWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String verificationCode = "";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isVerification = false;
  bool triggered = false;

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
            if (!isVerification) loginFields(),
            if (isVerification) mFAFields(),
            const SizedBox(height: 20),
            if (isVerification)
              Text(
                "Enter the 6 digit code sent to your email",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 16,
                ),
              ),
            if (!isVerification) const SizedBox(height: 20),
            if (!isVerification)
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
                    (
                      bool,
                      String
                    ) response = await LoadingOverlay.of(context).during(context
                        .read<AuthenticationProvider>()
                        .loginPatient(
                            Utils.encryptData(emailController.text.trim()),
                            Utils.encryptData(passwordController.text.trim())));

                    if (response.$1) {
                      isVerification = true;
                      setState(() {});
                    } else {
                      // ignore: use_build_context_synchronously
                      Utils.error(context, response.$2);
                    }
                  }
                },
                child: const Text("Login"),
              ),
            const SizedBox(height: 20),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/doctor/login');
                },
                child: const Text("Login as Doctor")),
          ],
        ),
      ),
    );
  }

  Column loginFields() {
    return Column(
      children: [
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget mFAFields() {
    return OtpTextField(
      numberOfFields: 6,
      borderColor: Theme.of(context).primaryColor,
      showFieldAsBox: true,

      onSubmit: (String verificationCode) async {
        this.verificationCode = verificationCode;
        if (!triggered) {
          triggered = true;
          await verifyOTP(verificationCode);
        }
      }, // end onSubmit
    );
  }

  Future<void> verifyOTP(String otp) async {
    (bool, String) isSuccess = await LoadingOverlay.of(context).during(
      context.read<AuthenticationProvider>().validateOTP(
            Utils.encryptData(emailController.text.trim()),
            Utils.encryptData(otp),
          ),
    );
    if (isSuccess.$1) {
      formKey.currentState!.reset();
      await SecureStorageService.delete(key: "isVerified");
      Utils.success(context, isSuccess.$2);
      // Navigator.pop(context);
      // ignore: use_build_context_synchronously
    } else {
      triggered = false;
      Utils.error(context, isSuccess.$2);
    }
  }
}
