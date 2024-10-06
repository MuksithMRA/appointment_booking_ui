import 'package:asiri/authentication/providers/authentication_provider.dart';
import 'package:asiri/authentication/screens/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/screen_size.dart';

class TopNavBarWidget extends StatelessWidget {
  final Function()? onLogout;
  const TopNavBarWidget({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/asiri.png",
            height: 70,
          ),
          if (ScreenSize.type != ScreenSizeType.mobile &&
              context.watch<AuthenticationProvider>().isLoggedIn != null)
            InkWell(
              onTap: () {
                if (context.read<AuthenticationProvider>().isLoggedIn!) {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(ScreenSize.width, 70, 0, 0),
                    items: [
                      if (context.read<AuthenticationProvider>().role ==
                          "PATIENT")
                        PopupMenuItem(
                          onTap: () {},
                          child: const SizedBox(
                            width: 100,
                            height: 30,
                            child: Text("My Bookings"),
                          ),
                        ),
                      if (context.read<AuthenticationProvider>().role ==
                          "PATIENT")
                        PopupMenuItem(
                          onTap: () {},
                          child: const SizedBox(
                            width: 100,
                            height: 30,
                            child: Text("My Profile"),
                          ),
                        ),
                      PopupMenuItem(
                        onTap: () {
                          context.read<AuthenticationProvider>().logout();
                          onLogout?.call();
                        },
                        child: const SizedBox(
                          width: 100,
                          height: 30,
                          child: Text("Logout"),
                        ),
                      ),
                    ],
                  );
                  // context.read<AuthenticationProvider>().logout();
                } else {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => Dialog(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                  width: ScreenSize.width * 0.3,
                                  child: const AuthenticationScreen()),
                            ),
                          ));
                }
              },
              child: Container(
                height: 70,
                padding: const EdgeInsets.only(right: 10),
                child: context.watch<AuthenticationProvider>().isLoggedIn!
                    ? Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: context
                                    .read<AuthenticationProvider>()
                                    .avatar
                                    .isNotEmpty
                                ? NetworkImage(context
                                    .read<AuthenticationProvider>()
                                    .avatar)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Text(context.read<AuthenticationProvider>().fullName),
                        ],
                      )
                    : const Row(
                        children: [
                          Icon(Icons.login, size: 20),
                          SizedBox(width: 10),
                          Text("Login /  Register",
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
