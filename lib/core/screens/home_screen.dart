import 'package:asiri/authentication/utils.dart';
import 'package:asiri/core/models/doctor_model.dart';
import 'package:asiri/core/models/specialization.dart';
import 'package:asiri/core/providers/doctor_provider.dart';
import 'package:asiri/core/providers/specialization_provider.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../utils/screen_size.dart';
import '../widgets/top_navbar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ScreenSize.type == ScreenSizeType.mobile ? const Drawer() : null,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const TopNavBarWidget(),
                const JumbortonWidget(),
                const SpecialitySection(),
                Container(
                  padding: const EdgeInsets.all(30),
                  width: ScreenSize.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Featured Doctors",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(30),
                        width: ScreenSize.width,
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Consumer<DoctorProvider>(
                          builder: (context, cDoctor, child) {
                            return Wrap(
                              spacing: 15,
                              runSpacing: 15,
                              children: cDoctor.doctors.map(
                                (e) {
                                  return DoctorCardWidget(doctor: e);
                                },
                              ).toList(),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: ScreenSize.height * 0.2,
              left: ScreenSize.width * 0.2,
              child: Container(
                  color: Colors.white,
                  height: ScreenSize.height * 0.5,
                  width: ScreenSize.width * 0.2,
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                      calendarType: CalendarDatePicker2Type.multi,
                    ),
                    value: [DateTime.now()],
                    onValueChanged: (dates) => print(dates),
                  )))
        ],
      ),
    );
  }
}

class DoctorCardWidget extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorCardWidget({
    required this.doctor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width * 0.25,
      height: ScreenSize.width * 0.2,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(doctor.avatar),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${doctor.doctorFirstName} ${doctor.doctorLastName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(doctor.specialization),
                ],
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: doctor.isToday() ? Colors.blue : null,
                        borderRadius: BorderRadius.circular(5),
                        border: !doctor.isToday()
                            ? Border.all(color: Colors.black, width: 1)
                            : null,
                      ),
                      child: Text(
                        "Today",
                        style: TextStyle(
                            color: doctor.isToday() ? Colors.white : null),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: doctor.isTomorrow() ? Colors.blue : null,
                        borderRadius: BorderRadius.circular(5),
                        border: !doctor.isTomorrow()
                            ? Border.all(color: Colors.black, width: 1)
                            : null,
                      ),
                      child: Text(
                        "Tomorrow",
                        style: TextStyle(
                            color: doctor.isTomorrow() ? Colors.white : null),
                      ),
                    ),
                  )
                ],
              ),
              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {},
                onHover: (value) {
                  debugPrint("Hovering $value");
                },
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.blue, width: 1),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 5),
                      Text(
                        "Calendar",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.blue,
                        child: Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          const Expanded(
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                Chip(
                  label: Text("14:00"),
                ),
                Chip(
                  label: Text("14:15"),
                ),
                Chip(
                  label: Text("14:30"),
                ),
                Chip(
                  label: Text("15:00"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SpecialitySection extends StatelessWidget {
  const SpecialitySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      width: ScreenSize.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Specializations",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
          const SizedBox(height: 15),
          Consumer<SpecializationProvider>(
            builder: (context, cSpecialization, child) {
              return Wrap(
                spacing: 20,
                alignment: WrapAlignment.start,
                children: List.generate(
                  cSpecialization.specializations.length,
                  (index) => SpecializationCard(
                      specialization: cSpecialization.specializations[index]),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class SpecializationCard extends StatelessWidget {
  final Specialization specialization;
  const SpecializationCard({
    super.key,
    required this.specialization,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(20),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: SvgPicture.asset(
              "assets/${specialization.code}.svg",
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(specialization.description, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

class JumbortonWidget extends StatelessWidget {
  const JumbortonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenSize.height - 70,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/background.jpg"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(ScreenSize.width * 0.08, 0, 0, 0),
        width: ScreenSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Asiri Hospital",
              style: TextStyle(fontSize: 40, color: Colors.white),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: ScreenSize.width * 0.5,
              child: TextField(
                  decoration: InputDecoration(
                hintText: "Search a Doctor",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              )),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Book an Appointment",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                if (Utils.isLoggedIn())
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "My Appointments",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
