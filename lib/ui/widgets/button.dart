import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_converter/ui/main_view.dart';
import 'package:currency_converter/ui/screens/update_currency.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

  String? baseCurrency; // Holds the base currency value
  FirebaseFirestore _instance = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
String title ='';
class MyAppbar extends StatefulWidget {
 
  MyAppbar({super.key});

  @override
  State<MyAppbar> createState() => _MyAppbarState();
}

class _MyAppbarState extends State<MyAppbar> {

@override
  void initState() {
    super.initState();
    String userId = user!.uid; // Replace this with the user's ID
     // Call the function to fetch the base currency when the page loads
    fetchBaseCurrency2(userId).then((currency) {
      setState(() {
        baseCurrency = currency; // Update the state with the fetched base currency
      });
    });
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
    return 
              Padding(
              padding: const EdgeInsets.only(right: 16.0), // Add right margin
              child: Row(
                children:[ ElevatedButton(
                  onPressed: () {
                    // Define the action when the button is pressed
                    // For example, navigate to a page to change the base currency
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UpdateCurrency(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff121331),
                    shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(0), // Rounded border on top right
                bottomRight: Radius.circular(0), // Rounded border on bottom right
                topLeft: Radius.circular(10), // No border radius on top left
                bottomLeft: Radius.circular(10), // No border radius on bottom left
              ),
            ),
                    
                  ),
                  child: Text(
                    "$baseCurrency",
                    style: TextStyle(color: Colors.white), // Set text color to white
                  ),
                ),
                ElevatedButton(
                onPressed:_handleLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff121331),
                  shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), // Rounded border on top right
                bottomRight: Radius.circular(10), // Rounded border on bottom right
                topLeft: Radius.circular(0), // No border radius on top left
                bottomLeft: Radius.circular(0), // No border radius on bottom left
              ),
            ),
                ),
                
                child: Text(
                  "Logout",
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
              ),
                ]
              ),
            );
             
             
             
           
  }
}