import 'package:currency_converter/services/splash_service.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashScreenService splashservice = SplashScreenService();

  @override
  void initState(){
  super.initState();
  splashservice.isLogin(context);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.network('https://lottie.host/f75a2a67-0547-44e6-845b-54de07818faf/79fECa253s.json')),
    );
  }
}