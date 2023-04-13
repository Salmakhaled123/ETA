import 'package:etaproject/modules/verifyPhoneNumber.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utiles/showSnackBar.dart';


class PhoneScreen extends StatefulWidget {
  static String verify="";
  static String phone="";
  const PhoneScreen({super.key});
  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}
class _PhoneScreenState extends State<PhoneScreen> {
  final phoneController =TextEditingController();
  final countryController = TextEditingController();
  final focusPhone =FocusNode();

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap:() {
          focusPhone.unfocus();
        },
        child:Scaffold(
      appBar: AppBar(
          title: const Text('Login with phone',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Serif',color: Colors.white)),
          backgroundColor: Colors.indigo,
          ),
      body:ListView(

        children: <Widget>[
          const SizedBox(height: 70,),
            const Image(image: AssetImage('assets/SendOTP.png'),width: 700,height: 250,),
      const SizedBox(height: 20,),

      Padding(
      padding: const EdgeInsets.only(left: 15,right: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(image: AssetImage('assets/Egypt.png'),
              height: 30,width: 25,
          ),
        const SizedBox(
        width: 10,
      ),
              Container(height: 30,width: 35,
                    decoration: BoxDecoration(
                        color: Colors.indigo,
                    borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Center(child: Text('+20',style: TextStyle(fontSize: 14,color: Colors.white),
                    ),
                    ),
    ),
    const Text(
            "|",
            style: TextStyle(fontSize: 40, color: Colors.indigo),
          ),
          SizedBox(
            width: 300,
            child: TextFormField(
              keyboardType: TextInputType.phone,
              controller:phoneController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20)
                ),
                hintText: "Enter your phone number",
                focusedBorder: OutlineInputBorder(borderSide:
                const BorderSide(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(20)),
                fillColor: Colors.grey.shade100,
                filled: true,

              ),
            ),
          ),
        ],
      ),
          ),
      ),
         const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),),
                onPressed: () async {await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber:'+20${phoneController.text}',
                  verificationCompleted: (PhoneAuthCredential credential) {},
                  verificationFailed: (FirebaseAuthException e) {
                    if (e.code == 'invalid-phone-number') {
                      showSnackBar(context, 'The provided phone number is not valid.');
                    }
                  },

                  codeSent: (String verificationId, int? resendToken) async {

                    PhoneScreen.verify= verificationId;
                    PhoneScreen.phone =phoneController.text;
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context)=>MyVerify(),
                        ),
                    );
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
                  },
              child: const Text('Send OTP',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Serif',color: Colors.white)),


            ),
          ),],
    ),
        ),
    );
  }
}
