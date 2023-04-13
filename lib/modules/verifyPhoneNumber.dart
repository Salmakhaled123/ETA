import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etaproject/components/constants.dart';
import 'package:etaproject/modules/phone-Registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'Phone_Login.dart';
import 'mapScreen.dart';

class MyVerify extends StatefulWidget {
  static var code ="";
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  final FirebaseAuth auth =FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance.collection("users").doc("phone");
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

      },
      onError: (e) => print("Error getting document: $e"),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          title: const Text('Verification Code',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Serif',color: Colors.white)),
          backgroundColor: Colors.indigo,
          ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('assets/EnterOTP.png'),width: 270,),

              const Center(
                child: Text('Enter The OTP Code Sent To This Number',
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Serif',color: Colors.indigo)),
              ),

              const SizedBox(
                height: 10,
              ),
              const Icon(Icons.arrow_circle_down_sharp,size: 30,color: Colors.indigo,),
              const SizedBox(
                height: 10,
              ),
              Text('+20${PhoneScreen.phone}',style: const TextStyle(color: Colors.indigo),),

              const SizedBox(
                height: 20,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                onChanged: (value){
                  MyVerify.code = value;
                },
                onCompleted: (pin) => print(pin),
              ),
              const SizedBox(
                height: 20,
              ),
              RadioListTile(
                  title: Text('user'),
                  value: 'user',
                  groupValue: modes,
                  onChanged: (value)
                  {
                    setState(()
                    {
                      modes = value;
                      print(modes);

                    });
                  }),
              RadioListTile(
                  title: Text('provider'),
                  contentPadding: EdgeInsets.zero,
                  value: 'provider',
                  groupValue: modes,
                  onChanged: (value)
                  {
                    setState(()
                    {
                      modes = value;
                      print(modes);

                    });
                  }),
              SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),),
                    onPressed: () async {
                      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: PhoneScreen.verify, smsCode: MyVerify.code);
                      UserCredential userCred = await auth.signInWithCredential(credential);
                      if(userCred.additionalUserInfo?.isNewUser!=true){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MapScreen(mode: modes, uId: PhoneScreen.phone,),
                          ),
                        );
                      }

                    else{
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => phoneRegister(),
                          ),
                        );
                    }

                    },
                  child: const Text('Confirm',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Serif',color: Colors.white)),),
              ),

              Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil<void>(
                          context,
                          MaterialPageRoute<void>(builder: (BuildContext context) => const PhoneScreen()),
                          ModalRoute.withName('/'),
                        );
                      },
                      child: const Text('Edit Phone Number ?',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Serif',color: Colors.black87)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}