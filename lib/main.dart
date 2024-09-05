import 'package:asiri/authentication/providers/authentication_provider.dart';
import 'package:asiri/core/providers/common_provider.dart';
import 'package:asiri/core/providers/specialization_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication/screens/doctor_login_screen.dart';
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
    ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
    ChangeNotifierProvider(create: (context) => CommonProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    context.read<AuthenticationProvider>().isLoggedInTrigger();
  }
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
      routes: {
        '/home': (context) => const HomeScreen(),
        '/doctor/login': (context) => const DoctorLoginScreen(),
      },
      initialRoute: "/home",
    );
  }
}
