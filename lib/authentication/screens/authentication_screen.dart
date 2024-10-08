
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../dependencies/secure_storage_service.dart';
import '../providers/authentication_provider.dart';
import '../widgets/login_tab_widget.dart';
import '../widgets/register_tab_widget.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () async {
            if (await SecureStorageService.exists(key: "token") &&
                await SecureStorageService.exists(key: "isVerified")) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                context.read<AuthenticationProvider>().logout();
              });
            }
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        centerTitle: true,
        title: Image.asset(
          "assets/asiri.png",
          height: 60,
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontSize: 16),
          tabs: const [
            Tab(
              text: "Login",
            ),
            Tab(
              text: "Register",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const LoginTabWidget(),
          RegisterTabWidget(
            onRegister: (patient) {
              _tabController?.animateTo(0);
            },
          ),
        ],
      ),
    );
  }
}
