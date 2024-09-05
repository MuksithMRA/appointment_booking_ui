import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../authentication/providers/authentication_provider.dart';
import '../models/specialization.dart';
import '../providers/doctor_provider.dart';
import '../providers/specialization_provider.dart';
import '../utils/screen_size.dart';
import '../widgets/doctor_card_widget.dart';
import '../widgets/top_navbar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
        context.read<DoctorProvider>().getAllDoctors();
    });
  }
  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
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
                const FeaturedDoctorsSection(),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  width: ScreenSize.width,
                  height: ScreenSize.height * 0.08,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Asiri Hospital © ${DateFormat('yyyy').format(DateTime.now())}",
                        style: const TextStyle(color: Colors.white),
                      ),
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

class FeaturedDoctorsSection extends StatelessWidget {
  const FeaturedDoctorsSection({
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
          const Text("Featured Doctors",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600)),
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
                  children: cDoctor.doctors
                      .map((e) => DoctorCardWidget(doctor: e))
                      .toList(),
                );
              },
            ),
          )
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
                Consumer<AuthenticationProvider>(
                  builder: (context, cAuth, child) {
                    return (cAuth.isLoggedIn ?? false)
                        ? OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                            ),
                            onPressed: () {},
                            child: const Text(
                              "My Appointments",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : const SizedBox();
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
