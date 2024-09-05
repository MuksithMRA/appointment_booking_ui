import 'package:asiri/authentication/models/patient_model.dart';
import 'package:asiri/authentication/models/user_model.dart';
import 'package:asiri/authentication/providers/authentication_provider.dart';
import 'package:asiri/authentication/utils.dart';
import 'package:asiri/core/models/entity_model.dart';
import 'package:asiri/core/providers/common_provider.dart';
import 'package:asiri/core/utils/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

import '../../core/utils/screen_size.dart';

class RegisterTabWidget extends StatefulWidget {
  final Function(PatientModel)? onRegister;
  const RegisterTabWidget({super.key, this.onRegister});

  @override
  State<RegisterTabWidget> createState() => _RegisterTabWidgetState();
}

class _RegisterTabWidgetState extends State<RegisterTabWidget> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool termsAndConditions = false;
  EntityModel? gender;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Welcome to Asiri Hospitals",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Please fill the form to register",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
            ),
            const SizedBox(height: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "First name is required";
                }
                return null;
              },
              controller: firstNameController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                labelText: "First name",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Last name is required";
                }
                return null;
              },
              controller: lastNameController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                labelText: "Last name",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Gender"),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: ScreenSize.width * 0.2,
                    child: Row(
                      children: context
                          .read<CommonProvider>()
                          .genders
                          .map(
                            (e) => Flexible(
                              child: RadioListTile(
                                title: Text(e.description),
                                value: e.code,
                                groupValue: gender?.code,
                                onChanged: (value) {
                                  setState(() {
                                    gender = context
                                        .read<CommonProvider>()
                                        .genders
                                        .firstWhere((e) => e.code == value);
                                  });
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            IntlPhoneField(
              validator: (value) {
                if (value == null) {
                  return "Phone Number is required";
                }
                return null;
              },
              controller: phoneController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                labelText: 'Phone Number',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              initialCountryCode: 'LK',
            ),
            const SizedBox(height: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null) {
                  return "Email is required";
                } else if (!value.contains("@") || !value.contains(".")) {
                  return "Invalid email";
                }
                return null;
              },
              controller: emailController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                labelText: "Email",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null) {
                  return "Password is required";
                } else if (value.length < 6) {
                  return "Password must be at least 6 characters";
                }
                return null;
              },
              controller: passwordController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                labelText: "Password",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null) {
                  return "Confirm Password is required";
                } else if (value != passwordController.text) {
                  return "Passwords do not match";
                }
                return null;
              },
              controller: confirmPasswordController,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                labelText: "Confirm Password",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile.adaptive(
              value: termsAndConditions,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  termsAndConditions = value;
                });
              },
              title:
                  const Text("I accept terms, conditions and privacy policies"),
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
                  if (gender == null) {
                    Utils.warning(context, "Please select a gender");
                    return;
                  }

                  if (!termsAndConditions) {
                    Utils.warning(
                        context, "Please accept terms and conditions");
                    return;
                  }

                  PatientModel patientModel = PatientModel(
                    avatar: gender?.code == "M"
                        ? "https://img.freepik.com/free-photo/3d-portrait-people_23-2150793895.jpg"
                        : "https://img.freepik.com/free-photo/portrait-young-woman-wearing-glasses-3d-rendering_1142-43632.jpg",
                    email: emailController.text.trim(),
                    firstName: firstNameController.text.trim(),
                    lastName: lastNameController.text.trim(),
                    gender: gender!.description,
                    phoneNumber: phoneController.text.trim(),
                    user: UserModel(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                      role: "PATIENT",
                    ),
                  );

                  final response = await LoadingOverlay.of(context).during(
                      context
                          .read<AuthenticationProvider>()
                          .registerPatient(patientModel));

                  if (mounted) {
                    if (response.$1) {
                      // ignore: use_build_context_synchronously
                      Utils.success(context, response.$2);
                      setState(() {
                        formKey.currentState?.reset();
                        gender = null;
                        termsAndConditions = false;
                      });
                      widget.onRegister?.call(patientModel);
                    } else {
                      // ignore: use_build_context_synchronously
                      Utils.error(context, response.$2);
                    }
                  }
                }
              },
              child: const Text("Register"),
            )
          ],
        ),
      ),
    );
  }
}
