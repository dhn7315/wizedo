// import 'package:wizedo/Pages/homepage.dart';
// import 'package:wizedo/Pages/register_page.dart';
// import 'package:wizedo/Services/AuthService.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wizedo/components/my_button.dart';
import 'package:wizedo/components/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wizedo/components/white_text.dart';
import 'package:wizedo/pages/UserDetailsPage.dart';
import 'package:wizedo/pages/detailsPage.dart';
import '../components/colors/sixty.dart';
import '../components/my_elevatedbutton.dart';
import '../components/my_textbutton.dart';
import '../components/purple_text.dart';
import '../services/AuthService.dart';
import 'BottomNavigation.dart';
import 'HomePage.dart';
import 'RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';





class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool passwordVisibility = false;
  FocusNode myFocusNode = FocusNode();
  String hexColor = '#211b2e';
  RxBool loading = false.obs;
  bool userDetailsfilled = false; // Initialize userDetailsfilled as false

  //instance of auth
  FirebaseAuth _auth=FirebaseAuth.instance;  //creaing instance for easier use through _auth

  //instance of firestore
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  //
  //signin user
  final emailController =TextEditingController();
  final passController =TextEditingController();

  //this below code is to sign in with google - currently under test
  final AuthService _authService = AuthService();
  final GoogleSignIn googleSignIn = GoogleSignIn();



  // signin logic
  Future<void> login(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passController.text,
      );

      // Check if the user is linked with a Google account
      if (userCredential.user != null &&
          userCredential.user!.providerData.any(
                (userInfo) => userInfo.providerId == 'google.com',
          )) {
        Get.snackbar('Error',
            'This email is associated with a Google account. Please sign in with Google.');
        return;
      }

      Get.snackbar('Success', 'Sign in successful');
      if (userDetailsfilled==true) {
        print(userDetailsfilled);
        print('homepage');
        Get.offAll(() => HomePage());
      } else {
        print('userdetails');
        Get.to(() => UserDetails(userEmail: emailController.text));
        // User details are not filled, send to userdetailspage
      }
      // Navigate to the next screen upon successful sign-in.
    } catch (error) {
      Get.snackbar('Error', 'Error signing in: $error');
    } finally {
      loading.value = false;
    }
  }


  //loginwithgoogle
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      UserCredential? userCredential = await _authService.signInWithGoogle();
        Get.snackbar('Success', 'Sign in with Google successful');
        // Navigate to the next screen upon successful sign-in.
        Get.offAll(() => HomePage());
    } catch (error) {
      Get.snackbar('Error', 'Error signing in with Google: $error');
    } finally {
      loading.value = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    Color backgroundColor = ColorUtil.hexToColor(hexColor);

    return Scaffold(
      backgroundColor: Color(0xFF211B2E),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: Container(
                width: 310,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 50),
                    Image.asset(
                      'lib/images/login_animation.png',
                      width: 400,
                      height: 160,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: WhiteText(
                        'Login',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: WhiteText('Please login to continue', fontSize: 16),
                    ),
                    SizedBox(height: 25),
                    MyTextField(
                      controller: emailController,
                      label: 'Email',
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Colors.white,
                      ),
                      fontSize: 11.5,
                    ),
                    SizedBox(height: 25),

                    MyTextField(
                      controller: passController,
                      label: 'Password',
                      obscureText: !passwordVisibility,
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.white,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            passwordVisibility = !passwordVisibility; // Toggle visibility for password field
                          });
                        },
                        child: Icon(
                          passwordVisibility ? Icons.visibility_off : Icons.visibility,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      fontSize: 11.5,
                    ),

                    Align(
                      alignment: Alignment.topRight,
                      child: MyTextButton(
                        onPressed: () {
                          Get.to(BottomNavigation());
                          // Handle forgot password logic
                        },
                        buttonText: 'Forgot Password?',
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 15),

                    MyElevatedButton(onPressed: (){
                      login(context);
                    }, buttonText: 'Login',fontWeight: FontWeight.bold,),

                    SizedBox(height: 19),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 1.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [0.0, 0.5, 1.0, 1.0],
                                colors: [
                                  Colors.transparent,
                                  Color(0xFF955AF2),
                                  Color(0xFF955AF2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: PurpleText(
                              'Or Continue with',
                              fontSize: 12,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 1.5,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [0.0, 0.0, 0.5, 1.0],
                                colors: [
                                  Colors.transparent,
                                  Color(0xFF955AF2),
                                  Color(0xFF955AF2),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 25),
                    GestureDetector(
                      onTap: () {
                        // Handle Google sign-in logic
                        _authService.signInWithGoogle();
                      },
                      child: Image.asset(
                        'lib/images/google.png',
                        width: 45,
                        height: 45,
                      ),
                    ),

                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        WhiteText('Not a member?', fontSize: 12),
                        MyTextButton(onPressed: (){
                          Get.to(() => RegisterPage());
                        }, buttonText: 'Register Now',fontSize: 12,)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



}