import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_converter/services/select_currency_service.dart';
import 'package:currency_converter/ui/screens/home.dart';
import 'package:currency_converter/ui/screens/select_currency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen2Service{

  FirebaseFirestore _instance = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  void checking(BuildContext context)async{
  

      User? user = FirebaseAuth.instance.currentUser;
      String userId = user!.uid; // Replace this with the user's ID
      SelectCurrencyService service = SelectCurrencyService();
      
      // Fetch base currency for the user
      String? baseCurrency = await service.fetchBaseCurrency(userId);
      
      if (baseCurrency != null) {
      Timer(Duration(seconds:4), () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  Home())));
      } else {
        Timer(Duration(seconds:4), () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  SelectCurrency())));
      }
    
                
                
                
                
                
                
                // Timer(Duration(seconds:5), () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  Home())));
  }
}