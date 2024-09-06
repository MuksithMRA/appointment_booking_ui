import 'package:asiri/authentication/providers/authentication_provider.dart';
import 'package:asiri/core/models/appointment_model.dart';
import 'package:asiri/core/utils/formatter.dart';
import 'package:asiri/core/widgets/doctor_appintments_widget.dart';
import 'package:asiri/core/widgets/top_navbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/screen_size.dart';
import '../widgets/doctor_schedule_workbench.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return Scaffold(
      body: Column(
        children: [
          TopNavBarWidget(
            onLogout: () {
              Navigator.pushNamedAndRemoveUntil(
                // ignore: use_build_context_synchronously
                context,
                '/doctor/login',
                (route) => false,
              );
            },
          ),
          SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.height - 70,
            child: Row(
              children: [
                Container(
                  color: Colors.blue,
                  width: ScreenSize.width * 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        onTap: () {
                          setState(() {
                            index = 0;
                          });
                        },
                        title: const Text(
                          'Appointments',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 0.5,
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        onTap: () {
                          setState(() {
                            index = 1;
                          });
                        },
                        title: const Text(
                          'Schedules',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 0.5,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(50),
                  child: IndexedStack(
                    index: index,
                    children: const [
                      DoctorAppointmentsWidget(),
                      ScheduleWorkBench()
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}


