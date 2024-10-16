import 'package:currency_converter/ui/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:currency_converter/ui/screens/login_screen.dart';
import 'package:currency_converter/ui/screens/sign_up_screen.dart';
import 'package:currency_converter/ui/screens/verify_screen.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        controller: controller,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Welcome(
              controller: controller,
            );
          } else if (index == 1) {
            return LoginScreen(
              controller: controller,
            );
          } 
           else if (index == 2) {
            return SignUpScreen(
              controller: controller,
            );
          } 
          
          else {
            return VerifyScreen(
              controller: controller,
            );
          }
        },
      ),
    );
  }
}
