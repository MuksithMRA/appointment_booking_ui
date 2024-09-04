import 'package:asiri/core/providers/specialization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/providers/doctor_provider.dart';
import 'core/screens/home_screen.dart';
import 'core/utils/screen_size.dart';

late SharedPreferences prefs;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => SpecializationProvider()),
    ChangeNotifierProvider(create: (context) => DoctorProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Asiri',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          ScreenSize.init(context);
          return const HomeScreen();
        },
      ),
    );
  }
}
