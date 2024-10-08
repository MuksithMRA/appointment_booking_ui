import 'package:asiri/authentication/models/patient_model.dart';
import 'package:asiri/authentication/utils.dart';
import 'package:asiri/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../authentication/models/doctor_model.dart';
import '../models/create_appointment_model.dart';
import '../models/slot_model.dart';
import '../providers/appointment_provider.dart';
import '../utils/loading_overlay.dart';
import '../utils/screen_size.dart';
import 'top_navbar_widget.dart';

class PatientBookingDetailsWidget extends StatefulWidget {
  const PatientBookingDetailsWidget({super.key});

  @override
  State<PatientBookingDetailsWidget> createState() =>
      _PatientBookingDetailsWidgetState();
}

class _PatientBookingDetailsWidgetState
    extends State<PatientBookingDetailsWidget> {
  DoctorModel? doctor;
  SlotModel? slot;
  PatientModel? patient;

  late LoadingOverlay overlay;

  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    overlay = LoadingOverlay.of(context);
    Future.delayed(Duration.zero, () async {
      UserProvider userProvider = context.read<UserProvider>();
      await overlay.during(userProvider.loadMyPatientProfile());
      patient = userProvider.patient;
      setState(() {});
    });
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      doctor = args['doctor'];
      slot = args['slot'];
    }

    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(70), child: TopNavBarWidget()),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            if (doctor != null) bookingDetailsWidget(),
            Divider(
              color: Colors.blueGrey[300]!,
              thickness: 0.3,
              height: 40,
              endIndent: 50,
              indent: 50,
            ),
            if (patient != null) patientDetailsWidget(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () async {
                    String message = await overlay.during(
                        context.read<AppointmentProvider>().bookAppointment(
                              CreateAppointmentModel(
                                scheduleSlotId: slot!.id,
                                patientId: patient!.id,
                                note: noteController.text.trim(),
                              ),
                            ));
                    if (message.isNotEmpty) {
                      Utils.error(context, message);
                    } else {
                      Utils.success(context, "Appointment booked successfully");
                      Navigator.popAndPushNamed(context, "/");
                    }
                  },
                  child: const Text(
                    "Book Appointment",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container bookingDetailsWidget() {
    return Container(
      width: ScreenSize.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Booking Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(doctor!.avatar),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Doctor name",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text("${doctor!.firstName} ${doctor!.lastName}"),
                ],
              ),
              SizedBox(width: ScreenSize.width * 0.1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Specialization",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(doctor!.specialization),
                ],
              ),
              SizedBox(width: ScreenSize.width * 0.1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Date",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(DateFormat("yyyy-MMM-dd")
                      .format(slot!.scheduleDateTime!)),
                ],
              ),
              SizedBox(width: ScreenSize.width * 0.1),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Time",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(DateFormat("hh:mm a").format(slot!.scheduleDateTime!)),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget patientDetailsWidget() {
    return Container(
      width: ScreenSize.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Patient Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Wrap(
            runSpacing: 30,
            spacing: ScreenSize.width * 0.1,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(patient?.avatar ??
                        "https://as2.ftcdn.net/v2/jpg/04/85/39/87/1000_F_485398728_aKL9duq8W78nnZ65BR3oGRMgari0sWEG.jpg"),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Patient name",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text("${patient?.firstName} ${patient?.lastName}"),
                    ],
                  ),
                ],
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Date of Birth",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text("1990-01-01"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Gender",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(patient?.gender ?? ""),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Phone",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(patient?.phoneNumber ?? ""),
                ],
              ),
              SizedBox(
                width: ScreenSize.width * 0.2,
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    label: const Text("Payment Method"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: "Cash",
                      child: Text("Cash"),
                    ),
                    DropdownMenuItem(
                      value: "Card",
                      child: Text("Card"),
                    ),
                  ],
                  onChanged: (value) {},
                ),
              ),
              SizedBox(
                width: ScreenSize.width * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Special Notes for Doctor (Optional)",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: noteController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
