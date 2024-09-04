import 'package:flutter/material.dart';
import '../widgets/login_tab_widget.dart';
import '../widgets/register_tab_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 100,
          centerTitle: true,
          title: Image.asset(
            "assets/asiri.png",
            height: 60,
          ),
          bottom: const TabBar(
          labelStyle:  TextStyle(fontSize: 16),
            tabs: [
              Tab(
                text: "Login",
              ),
              Tab(
                text: "Register",
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LoginTabWidget(),
            RegisterTabWidget(),
          ],
        ),
      ),
    );
  }
}
