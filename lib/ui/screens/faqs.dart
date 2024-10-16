import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_converter/services/currency_services2.dart';
import 'package:currency_converter/ui/widgets/button.dart';
import 'package:currency_converter/ui/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FAQs extends StatefulWidget {
  const FAQs({super.key});

  @override
  State<FAQs> createState() => _FAQsState();
}

  String? baseCurrency; // Holds the base currency value
  User? user = FirebaseAuth.instance.currentUser;
FirebaseFirestore _instance = FirebaseFirestore.instance;
class _FAQsState extends State<FAQs> {
 @override
  void initState() {
    super.initState();
    String userId = user!.uid; // Replace this with the user's ID
   
    CurrencyServices2().fetchBaseCurrency2(userId).then((currency) {
      setState(() {
        baseCurrency = currency; // Update the state with the fetched base currency
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text('FAQs'),
        backgroundColor: const Color(0xffffbc0d),
        actions: [
          // Display the base currency button on the app bar
          if (baseCurrency != null)
             MyAppbar(),
        ],
      ),
      drawer: const AppDrawer(),
        backgroundColor:const Color(0xff121331),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                      FutureBuilder<List<Map<String, dynamic>>>(
                  future: _fetchFAQs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Center(child: Text('No conversion history available.', style: TextStyle(color: Colors.white),));
                    } else {
                      // Display conversion history in a beautiful table format
                      return _buildUI(snapshot.data!);
                    }
                  },
                ),
                    
                  
                 


                
                  ],
                  ),

                  
              ),
      );;
  }
}

Future<List<Map<String, dynamic>>> _fetchFAQs() async {
    List<Map<String, dynamic>> faqs = [];
    QuerySnapshot querySnapshot = await _instance.collection("FAQs").get();
    querySnapshot.docs.forEach((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      faqs.add(data);
    });
    return faqs;
  }


  Widget _buildUI(List<Map<String, dynamic>> faqs) {
  return Expanded(
    child: ListView.builder(
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        return Card(
          color: const Color(0xff121331),
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(width:2,color: Color(0xffffbc0d)),
          ),
          child: ListTile(
            title: Text(
              faqs[index]['Question'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color:  Color(0xffffbc0d),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                faqs[index]['Answer'] ?? '',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      },
    ),
  );
}
