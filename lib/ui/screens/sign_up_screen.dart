import 'package:currency_converter/ui/main_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
 final GoogleSignIn _googleSignIn = GoogleSignIn();
   final FirebaseAuth _auth = FirebaseAuth.instance;
bool _passwordVisible = false;
// Function to show snackbar with error message
  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        
        duration: Duration(seconds: 5),
        backgroundColor: Color(0xffffbc0d),
         // Adjust as needed
      ),
    );
  }

///google signup
/// // Function to sign up with Google
  Future<void> _signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);


      final user = userCredential.user;

      // Check if user is new or existing
      if (user != null && userCredential.additionalUserInfo!.isNewUser) {
        _showErrorSnackbar('Account created with Google. Now login.');
      } else {
        _showErrorSnackbar('User logged in with Google. Now login.');
      }

      // Navigate to the next screen or do something else after successful sign-up
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MainView(),
        ),
      );
    } catch (e) {
      // Handle sign-in errors here
      print('Error signing in with Google: $e');
    }
  }

  ////signup with email
  /// // Function to sign up with email/password
  Future<void> _signUpWithEmailAndPassword() async {
    try {
      if (_emailController.text.isEmpty || _passController.text.isEmpty) {
        _showErrorSnackbar('Please fill in all fields.');
        return;
      }

      final newUser = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );

      _showErrorSnackbar('Account created successfully. Now login.');

      // Navigate to the next screen or do something else after successful sign-up
      widget.controller.animateToPage(1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease);     
    } catch (e) {
      // Handle sign-up errors here
      print('Error signing up: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff121331),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Image.asset(
                "assets/images/signup-2.png",
                width: 478,
                height: 250,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                textDirection: TextDirection.ltr,
                children: [
                  const Text(
                    'Sign up',
                    style: TextStyle(
                      color: Color(0xffffbc0d),
                      fontSize: 27,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 56,
                    child: TextField(
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
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  
                      SizedBox(
                        height: 56,
                        child: TextField(
                          controller: _passController,
                            obscureText: !_passwordVisible, // Toggle visibility
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Create Password',
                            hintStyle: TextStyle(
                              color: Color(0xFF837E93),
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
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
                            suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white, // Customize icon color
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
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
                      width: 400,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _signUpWithEmailAndPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffffbc0d),
                        ),
                        child: const Text(
                          'Create account',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: 
                    SizedBox(
                      width: 400,
                      height: 56,
                      child : ElevatedButton.icon(
                      onPressed: _signUpWithGoogle,
                      icon: Icon(Icons.g_mobiledata),
                      label: Text('Sign Up with Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                    ),
                    
                    
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child:  Column(
                    children: [
                      const Text(
                        ' have an account?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF837E93),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 2.5,
                      ),
                      InkWell(
                        onTap: () {
                          widget.controller.animateToPage(1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        child: const Text(
                          'Log In ',
                          style: TextStyle(
                            color: Color(0xffffbc0d),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ), // Google sign-in button,
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

