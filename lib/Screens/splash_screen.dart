import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:novanest/APIS/apis.dart';
import 'package:novanest/Screens/authentication/login_screen.dart';
import 'package:novanest/Screens/home_screen.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isAnimate =false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        isAnimate = true;
      });
    });
    Future.delayed(const Duration(milliseconds: 3500),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white));
      if(APIS.auth.currentUser!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const HomeScreen()));
      }
      else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
              top: isAnimate == true ? mq.height * .2 : -mq.height * .4,
              width: mq.width * .46,
              right: mq.width * .27,
              duration: const Duration(seconds: 1),
              child: Image.asset("images/appIcon.png")),
          Positioned(
            bottom: mq.height * .3,
            width: mq.width * .8,
            left: mq.width * .1,
            height: mq.height * .07,
            child: const Text("NovaNest",style: TextStyle(fontSize: 30,color: Colors.black54),textAlign: TextAlign.center,),
          ),
        ],
      ),
    );
  }
}
