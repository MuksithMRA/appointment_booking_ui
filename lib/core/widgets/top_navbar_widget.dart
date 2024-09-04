import 'package:asiri/authentication/screens/authentication_screen.dart';
import 'package:asiri/authentication/utils.dart';
import 'package:flutter/material.dart';

import '../utils/screen_size.dart';

class TopNavBarWidget extends StatelessWidget {
  const TopNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/asiri.png",
            height: 70,
          ),
          if (ScreenSize.type != ScreenSizeType.mobile)
            InkWell(
              onTap: () {
                if (Utils.isLoggedIn()) {
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
                child: Utils.isLoggedIn()
                    ? const Row(
                        children: [
                          CircleAvatar(),
                          SizedBox(width: 5),
                          Text("Abdul Muksith"),
                        ],
                      )
                    : const Row(
                        children: [
                          Icon(Icons.login , size: 20),
                          SizedBox(width: 10),
                          Text("Login /  Register" , style: TextStyle(fontSize: 16)),
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
