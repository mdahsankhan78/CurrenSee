import 'dart:async';

import 'package:currency_converter/ui/main_view.dart';
import 'package:flutter/material.dart';

class SplashScreenService{
  void isLogin(BuildContext context)
  {
    Timer(Duration(seconds:4), () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  MainView())));

  }
}