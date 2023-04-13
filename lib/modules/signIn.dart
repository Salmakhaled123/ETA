import 'package:etaproject/modules/providermapscreen.dart';
import 'package:etaproject/modules/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../cache/shared_pref.dart';
import '../cubit/cubit.dart';
import '../utiles/showSnackBar.dart';
import 'mapScreen.dart';
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>
{
  SignIn() async {

    {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passController.text);
        return userCredential
        ;
      } on FirebaseAuthException catch(e){
        showSnackBar(context, e.message!);
      }
    }
  }

  final focusEmail = FocusNode();
  final focusPassword = FocusNode();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  bool _passwordVisible = false;

  var formKey1 = GlobalKey<FormState>();
  @override
  void initState()
  {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        focusPassword.unfocus();
        focusEmail.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Login With Email',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Serif',color: Colors.white)),
          backgroundColor: Colors.indigo,
        ),
        body:
        SingleChildScrollView(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
          const SizedBox(height: 40,),
          const Image(image: AssetImage('assets/emailLogin.png'),width: 270,),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
            child: TextFormField(
              controller: emailController,
              focusNode: focusEmail,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)
                ),
                hintText: "Email",
                hintStyle: const TextStyle(fontFamily: 'Serif',color: Colors.indigo),
                focusedBorder: OutlineInputBorder(borderSide:
                const BorderSide(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(12)),
                fillColor: Colors.grey.shade100,
                filled: true,

              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 20),
            child: TextFormField(
              controller: passController,
              focusNode: focusPassword,
              obscureText: true,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)
                ),
                hintText: "Password",
                hintStyle: const TextStyle(fontFamily: 'Serif',color: Colors.indigo),
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.indigo,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                focusedBorder: OutlineInputBorder(borderSide:
                const BorderSide(color: Colors.indigo),
                    borderRadius: BorderRadius.circular(12)),
                fillColor: Colors.grey.shade100,
                filled: true,

              ),
            ),
          ),
          const SizedBox(height: 15,),


                SizedBox(
                  height: 10,
                ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),),

                    onPressed: () async
                    {
                      await SignIn();
                      var cubit= LocationCubit.get(context);
                      cubit.lngUser=null;
                      cubit.info=null;
                      String ? modeUser=CacheHelper.getData(key: 'modeUser');
                      String ?uidUser=CacheHelper.getData(key: 'uIdUser');
                      String ? modeProvider=CacheHelper.getData(key: 'modeProvider');
                      String ? uidProvider=CacheHelper.getData(key: 'uIdProvider');

                      if( modeUser=='user' && uidUser==emailController.text )
                        {

                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => MapScreen(mode: modeUser,
                                uId:uidUser,email: emailController.text,)),
                                  (route) => false);
                        }
                      else if(modeProvider=='provider' && uidProvider==emailController.text)
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => ProviderMapScreen(mode: modeProvider,
                            uId:uidProvider,)),
                              (route) => false);

                    },

                child:const Padding(
                  padding: EdgeInsets.only(left: 15,right: 15,top: 10,bottom: 10),
                  child: Text('Login',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Serif',color: Colors.white)),

                ),),
              Row(
                children: [
                  const SizedBox(width: 30,),
                  Text("if you don't have an  account ",
                      style: TextStyle(fontSize: 16)),
                  TextButton(
                    onPressed: () async {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => HomeScreen()));
                    },
                    child: Text(
                      'click here',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
              ]),
            ),
          ),
    );

  }
}
