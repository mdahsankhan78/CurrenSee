import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_converter/services/currency_services2.dart';
import 'package:currency_converter/services/select_currency_service.dart';
import 'package:currency_converter/ui/main_view.dart';
import 'package:currency_converter/ui/widgets/button.dart';
import 'package:currency_converter/ui/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
    const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final api = "https://api.exchangerate-api.com/v4/latest/USD";
  TextEditingController amountController = TextEditingController();
  String? fromCurrency;
  String? toCurrency;
  double? convertedAmount;
  Map<String, dynamic>? currencyData;
  String? baseCurrency; // Holds the base currency value
  FirebaseFirestore _instance = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  

  @override
  void initState() {
    super.initState();
    _fetchCurrencyData();
    String userId = user!.uid; // Replace this with the user's ID
     // Call the function to fetch the base currency when the page loads
    CurrencyServices2().fetchBaseCurrency2(userId).then((currency) {
      setState(() {
        baseCurrency = currency; // Update the state with the fetched base currency
        fromCurrency = baseCurrency; // to set default value
      });
    });
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

void _handleLogout() async {
  try {
    await FirebaseAuth.instance.signOut();
    // After signing out, you might want to navigate to a login screen or perform any other action.
     Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainView(),
                    ),
                  );
  } catch (e) {
    print("Error logging out: $e");
    // Handle error, if any
  }
}
  
  // for print basecurrency
// Function to fetch the base currency
  Future<String?> fetchBaseCurrency2(String? userId) async {
    CollectionReference userCollection =
        _instance.collection("users").doc(userId).collection("basecurrency");

    QuerySnapshot querySnapshot = await userCollection.get();
    if (querySnapshot.docs.isNotEmpty) {
      // Assuming only one document is present in the collection
      var data = querySnapshot.docs.first.data() as Map<String, dynamic>?; // Explicit type casting
      if (data != null && data.containsKey("curr")) {
        return data["curr"] as String?;
      } else {
        return null;
      }
    } else {
      return null; // If no documents are found
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      appBar: AppBar(
        
        title: Text("Home"),
        backgroundColor: const Color(0xffffbc0d),
        actions: [
          // Display the base currency button on the app bar
          if (baseCurrency != null)
             MyAppbar(),
        ],
        
      ),
     drawer: const AppDrawer(),
      
      backgroundColor:const Color(0xff121331),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: currencyData == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Lottie.network('https://lottie.host/f6910a04-a2a8-4e46-b969-2c4e6070c384/F2ZGEl3se7.json')
                    ),
                    TextField(
                      controller: amountController,
                       textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                      inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                     decoration: const InputDecoration(
                        labelText: 'Amount',
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
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: fromCurrency,
                            onChanged: (String? newValue) {
                              setState(() {
                                fromCurrency = newValue;
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
                        labelText: 'From',
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
                        ),
                        SizedBox(width: 20),
                        IconButton(
                        icon: Icon(Icons.swap_horiz, color: Color(0xffffbc0d),), // Icon for swapping currencies
                        onPressed: () {
                          setState(() {
                            // Swap logic
                            String? temp = fromCurrency;
                            fromCurrency = toCurrency;
                            toCurrency = temp;
                          });
                        },
                      ),
                        SizedBox(width: 20),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: toCurrency,
                            onChanged: (String? newValue) {
                              setState(() {
                                toCurrency = newValue;
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
                        labelText: 'To',
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
                        ),
                      ],
                    ),

                     SizedBox(height: 20),
                    TextField(
                      controller: TextEditingController(text: convertedAmount != null ? convertedAmount?.toStringAsFixed(2) : ''),
                      textAlign: TextAlign.center,
                      enabled: false, // Disable editing
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                     decoration: const InputDecoration(
                        labelText: 'Converted Amount',
                        labelStyle: TextStyle(
                          color: Color(0xffffbc0d),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                        disabledBorder: OutlineInputBorder(
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
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
        
        
                   ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: SizedBox(
                        width: 400,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            _getResults();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffffbc0d),
                          ),
                          child: const Text(
                            'Convert',
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

  void _getResults() {
    if (fromCurrency == null ||
        toCurrency == null ||
        amountController.text.isEmpty) {
      return;
      
    }
    final double amount = double.parse(amountController.text);
    final double fromRate = currencyData!['rates'][fromCurrency];
    final double toRate = currencyData!['rates'][toCurrency];
    setState(() {
      convertedAmount =
          (toRate / fromRate) * double.parse(amountController.text);
    });
    // Save conversion history
  if (user != null) {
    SelectCurrencyService().saveConversionHistory(
      user!.uid,
      amount,
      fromCurrency!,
      toCurrency!,
      convertedAmount,
    );
  }
  }
}

