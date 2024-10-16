import 'package:currency_converter/services/splash_service2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen2 extends StatefulWidget {
  const SplashScreen2({super.key});

  @override
  State<SplashScreen2> createState() => _SplashScreen2State();
}

class _SplashScreen2State extends State<SplashScreen2> {
  SplashScreen2Service splashservice = SplashScreen2Service();

  @override
  void initState(){
  super.initState();
  splashservice.checking(context);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Lottie.network('https://lottie.host/f75a2a67-0547-44e6-845b-54de07818faf/79fECa253s.json')),
    );
  }
}