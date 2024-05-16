import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:novanest/Screens/home_screen.dart';
import 'package:novanest/helper/dialogs.dart';

import '../../APIS/apis.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isAnimate = false;

  @override
  void initState() {
    super.initState();
  }

  handleGoogleLoginButton() async {
    Dialogs.showProgressBar(context);
    signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if (user != null) {
        if (await APIS.userExsists()) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const HomeScreen()));
        } else {
          await APIS.createUser().then((value){
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()));
              });
        }
      }
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIS.auth.signInWithCredential(credential);
    } catch (e) {
      Dialogs.showSnackbar(context, "Check Network Connection & Try Again");
      return null;
    }
  }

  signOut() async {
    await APIS.auth.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .15,
              width: mq.width * .46,
              right: mq.width * .27,
              child: Image.asset(
                "images/login-avatar.png",
                color: Colors.teal,
              )),
          Positioned(
            bottom: mq.height * .2,
            width: mq.width * .8,
            left: mq.width * .1,
            height: mq.height * .07,
            child: ElevatedButton.icon(
              onPressed: () {
                handleGoogleLoginButton();
              },
              icon: Image.asset(
                "images/google.png",
                height: mq.height * .04,
              ),
              label: const Text(
                "Sign In with Google",
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(elevation: 1),
            ),
          ),
        ],
      ),
    );
  }
}
