import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_converter/services/currency_services2.dart';
import 'package:currency_converter/ui/widgets/button.dart';
import 'package:currency_converter/ui/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();
  final TextEditingController _fnameController = TextEditingController();
  String? baseCurrency; // Holds the base currency value
  FirebaseFirestore _instance = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> feedback(
      String? userId, String fname, String lname, String email,String phone, String feedback) async {
    CollectionReference feeddbackCollection =
        _instance.collection("users").doc(userId).collection("feedback");
    await feeddbackCollection.doc(DateTime.now().microsecondsSinceEpoch.toString()).set({
      "first_name": fname,
      "last_name": lname,
      "email": email,
      "phone": phone,
      "feedback": feedback,
    });
  }

void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xffffbc0d),
      ),
    );
  }
 @override
  void initState() {
    super.initState();
    
    String userId = user!.uid; // Replace this with the user's ID
     // Call the function to fetch the base currency when the page loads
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
        
        
        backgroundColor: const Color(0xffffbc0d),
        actions: [
          // Display the base currency button on the app bar
          if (baseCurrency != null)
             MyAppbar(),
        ],
        
      ),
     drawer: const AppDrawer(),
      backgroundColor: const Color(0xff121331),
      body: SingleChildScrollView(
        child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [ 
            const Padding(
              padding: EdgeInsets.only(left: 15, top: 15),
              
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                textDirection: TextDirection.ltr,
                children: [
                  const Text(
                    'Feedback',
                    style: TextStyle(
                      color: Color(0xffffbc0d),
                      fontSize: 27,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
        
                  TextField(
                    controller: _fnameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'First Name',
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
        
        
                  const SizedBox(
                    height: 25,
                  ),
        
        
                  TextField(
                    controller: _lnameController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
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
        
        
                  const SizedBox(
                    height: 25,
                  ),
        
        
                  TextField(
                    controller: _emailController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Email',
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
        
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _phoneController,
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
                      labelText: 'Phone',
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
        
        
                  const SizedBox(
                    height: 25,
                  ),
                  TextField(
                     keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    controller: _feedbackController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Feedback',
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
                  
                  const SizedBox(
                    height: 25,
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: 329,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          String userId = user!.uid; // Replace this with the user's ID
                          feedback(userId, _fnameController.text, _lnameController.text, _emailController.text, _phoneController.text, _feedbackController.text);
                         
                            _showErrorSnackbar("your feedback has submitted");
                          
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffffbc0d),
                        ),
                        child: const Text(
                          'Submit',
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
                  const SizedBox(
                    height: 15,
                  ),
                  
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
