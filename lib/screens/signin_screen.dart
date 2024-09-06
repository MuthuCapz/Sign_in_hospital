import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth
import 'package:icons_plus/icons_plus.dart'; // Icon pack
import 'package:signin/screens/signup_screen.dart';
import 'package:signin/screens/verify_code_screen.dart'; // Import VerifyCodeScreen
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart'; // Facebook Auth package
import 'home_screen.dart'; // Import the HomeScreen

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;
  bool obscurePassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Facebook sign-in method
  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result =
          await FacebookAuth.instance.login(); // Trigger the login flow

      if (result.status == LoginStatus.success) {
        // Get the access token
        final AccessToken? accessToken = result.accessToken;

        // Create a credential from the access token
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken!.token);

        // Sign in with Firebase
        await FirebaseAuth.instance.signInWithCredential(credential);

        // Navigate to the home screen after successful login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (result.status == LoginStatus.cancelled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Facebook login cancelled by user')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Facebook login failed: ${result.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Email')),
      );
      return;
    }

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again later.';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email. Please sign up.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure status bar is visible
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the content vertically
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the content horizontally
            children: [
              const SizedBox(height: 120),
              const Text(
                'Sign in',
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Hi! Welcome back, you\'ve been missed',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formSignInKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        final emailRegex =
                            RegExp(r'^[a-z0-9._%+-]+@gmail\.com$');
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Email';
                        } else if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email (e.g., example@gmail.com)';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: obscurePassword,
                      obscuringCharacter: '*',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Password';
                        } else if (value.length != 6) {
                          return 'Password must be exactly 6 characters long';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: rememberPassword,
                              onChanged: (bool? value) {
                                setState(() {
                                  rememberPassword = value!;
                                });
                              },
                              activeColor: Colors.blue,
                            ),
                            const Text(
                              'Remember me',
                              style: TextStyle(
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _resetPassword();
                          },
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (_formSignInKey.currentState!.validate()) {
                            try {
                              final email = _emailController.text;
                              final password = _passwordController.text;

                              // Sign in with Firebase
                              UserCredential userCredential =
                                  await _auth.signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              String message =
                                  'Incorrect email or password. Please try again.';
                              if (e.code == 'user-not-found') {
                                message = 'No user found for that email.';
                              } else if (e.code == 'wrong-password') {
                                message =
                                    'Wrong password provided for that user.';
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.7,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or Sign in with',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.7,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Logo(Logos.apple),
                        Logo(Logos.google),
                        GestureDetector(
                          onTap: () {
                            _signInWithFacebook(context); // Facebook login
                          },
                          child: Logo(Logos.facebook_f),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text('Sign Up'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
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
