import 'package:asiri/core/widgets/top_navbar_widget.dart';
import 'package:flutter/material.dart';
import '../utils/screen_size.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

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
        ],
      ),
    );
  }
}
