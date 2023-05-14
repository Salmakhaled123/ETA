import 'dart:async';

import 'package:flutter/material.dart';

import 'login_choose.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

  }


class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.teal,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              //Icon(Icons.flash)
              Image(
                  image: AssetImage('assets/Servei icon.png'), fit: BoxFit.fill),
               Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 270),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Help on the way',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Reross Quadratic',
                            color: Colors.white),
                      ),
                      Icon(Icons.flash_on_sharp,color: Colors.white,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => LoginChoose()));
    });
    super.initState();
  }
}
