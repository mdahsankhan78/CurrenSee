import 'dart:convert';
import 'package:currency_converter/services/select_currency_service.dart';
import 'package:currency_converter/ui/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelectCurrency extends StatefulWidget {
    const SelectCurrency({super.key});

  @override
  _SelectCurrency createState() => _SelectCurrency();
}

class _SelectCurrency extends State<SelectCurrency> {
  final api = "https://api.exchangerate-api.com/v4/latest/USD";
  String? Currency;
  Map<String, dynamic>? currencyData;

  @override
  void initState() {
    super.initState();
    _fetchCurrencyData();
  }

  void _fetchCurrencyData() async {
    final response = await http.get(Uri.parse(api));
    if (response.statusCode == 200) {
      setState(() {
        currencyData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load currency data');
    }
  }

  @override
  Widget build(BuildContext context){
    
    SelectCurrencyService currencyService = SelectCurrencyService();

  
 

// Get the userId of the logged-in user
  User? user = FirebaseAuth.instance.currentUser;
  String userId = user!.uid;
    return Scaffold(
      
      appBar: AppBar(
        title: Text('Select Your Base Currency'),
        backgroundColor: const Color(0xffffbc0d),
         automaticallyImplyLeading: false, // Add this line to remove the back button
      ),
        backgroundColor:const Color(0xff121331),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: currencyData == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonFormField<String>(
                          value: Currency,
                          onChanged: (String? newValue) {
                            setState(() {
                              Currency = newValue;
                            });
                          },
                          items: _getDropdownItems(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                          decoration: const InputDecoration(
                      labelText: 'Currency',
                      labelStyle: TextStyle(
                        color: Color(0xffffbc0d),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xFF837E93),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 2,
                          color: Color(0xffffbc0d),
                        ),
                      ),
                    ),
                        ),
                      
                    
                  
                  SizedBox(height: 20),


                 ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: 400,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          currencyService.addCurrency(userId, Currency);
                           Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => Home(),
                            ),
                          );
                          // _getResults();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffffbc0d),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ],
                  ),

                  
              ),
      );
  }

  List<DropdownMenuItem<String>> _getDropdownItems() {
    List<DropdownMenuItem<String>> items = [];
    currencyData!['rates'].forEach((key, value) {
      items.add(
        DropdownMenuItem(
          value: key,
          child: Text(key),
        ),
      );
    });
    return items;
  }

  // void _getResults() {
    

  //   final double fromRate = currencyData!['rates'][Currency];
  //   setState(() {
  //     convertedAmount =
  //         (toRate / fromRate) * double.parse(amountController.text);
  //   });
    
  // }
}

