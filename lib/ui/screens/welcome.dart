import 'package:currency_converter/splash_screen2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class Welcome extends StatefulWidget {
  const Welcome({super.key, required this.controller});
  final PageController controller;
  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
 final FirebaseAuth _auth = FirebaseAuth.instance;
 bool _passwordVisible = false;

 // Function to show snackbar with error message
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xffffbc0d),
         // Adjust as needed
      ),
    );
  }
  Future<void> _logInWithEmailAndPassword() async {
    try {
                                // Check if the user is successfully logged in
                                if (_emailController.text.isEmpty ||
                                          _passController.text.isEmpty) {
                                      _showErrorSnackbar('Please fill in all fields.');
                                  }
                               else{
                                 final userCredential = await _auth.signInWithEmailAndPassword(
                                  email: _emailController.text.trim(),
                                  password: _passController.text.trim(),
                                );
                                  // Navigate to home page after successful login
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => SplashScreen2(),
                                    ),
                                  );
                                }
                              } on FirebaseAuthException catch (e) {
                                // Handle login errors here
                                print('Error logging in: $e');
                                String errorMessage = 'Invalid email address or password';
                                if (e.code == 'user-not-found') {
                                  errorMessage = 'User not found';
                                }
                                _showErrorSnackbar(errorMessage);
                              } catch (e) {
                                // Handle other errors here
                                print('Error logging in: $e');
                                _showErrorSnackbar('Error logging in');
                              }              
  }

 
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor:const Color(0xff121331),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:const EdgeInsets.only(right : 30.0, left: 30.0,top: 30.0),
                child: Lottie.network('https://lottie.host/f6910a04-a2a8-4e46-b969-2c4e6070c384/F2ZGEl3se7.json')),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Column(
                  textDirection: TextDirection.ltr,
                   mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        color: Color(0xffffbc0d),
                        fontSize: 27,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                   const  Center(
                      child: Text(
                        'CurrenSee: Your Gateway to Currency Conversion. Simplifying Exchange Rates for Seamless Transactions.',
                        textAlign: TextAlign.center, // Ensure text is centered within its container
                        style: TextStyle(
                          color: Color(0xffffbc0d),
                          fontSize: 15,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  
                  const SizedBox(
                      height: 50,
                    ),
                  ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: SizedBox(
                        width: 400,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
        
                             widget.controller.animateToPage(1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);       
        
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xffffbc0d),
                          ),
                          child: const Text(
                            'Log In',
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
                      height: 20,
                    ),
                   
                   
                   
                  
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: SizedBox(
                        width: 400,
                        height: 56,
                         child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffffbc0d), // Border color
                            width: 2, // Border width
                            
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
        
                            widget.controller.animateToPage(2,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease);         
        
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff121331),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color(0xffffbc0d),
                              fontSize: 15,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
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
      ),
    );
  }
}
