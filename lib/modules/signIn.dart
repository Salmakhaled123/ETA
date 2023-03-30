import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:etaproject/modules/providermapscreen.dart';
import 'package:etaproject/modules/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../cache/shared_pref.dart';
import 'mapScreen.dart';
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen>
{
  SignIn() async {
    if (formKey1.currentState!.validate())
    {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passController.text);
        return userCredential
        ;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
                  context: context,
                  body: Text('No user found for that email'),
                  title: 'error')
              .show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
                  context: context,
                  body: Text('Wrong password provided for that user.'),
                  title: 'error')
              .show();
        }
      }
    }
  }

  var emailController = TextEditingController();
  var passController = TextEditingController();
  bool isObscure = false;

  var formKey1 = GlobalKey<FormState>();
  @override
  void initState()
  {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: formKey1,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(children: [
              Center(
                child: Image.network(
                    height: 250,
                    'https://img.freepik.com/free-vector/scheduling-planning-setting-goals-schedule-timing-workflow-optimization-taking-note-assignment-businesswoman-with-timetable-cartoon-character_335657-2580.jpg?w=740&t=st=1675393490~exp=1675394090~hmac=73c74c6e71eb7e9c146091ff4405f54d833c5fc2981c77374c73ea0c1d88c1a0'),
              ),
              TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (data) {
                    if (data!.isEmpty) {
                      return 'email is required';
                    }
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'email address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)))),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  controller: passController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: isObscure,
                  validator: (data) {
                    if (data!.isEmpty) {
                      return 'this field is required';
                    }
                  },
                  decoration: InputDecoration(
                      suffixIcon: isObscure
                          ? InkWell(
                              child: Icon(Icons.remove_red_eye),
                              onTap: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                            )
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              child: Icon(Icons.visibility_off)),
                      prefixIcon: Icon(
                        Icons.lock_outline_sharp,
                      ),
                      hintText: 'password ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)))),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
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
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () async
                  {
                    await SignIn();

                    String ? modeUser=CacheHelper.getData(key: 'modeUser');
                    String ?uidUser=CacheHelper.getData(key: 'uIdUser');
                    String ? modeProvider=CacheHelper.getData(key: 'modeProvider');
                    String ?uidProvider=CacheHelper.getData(key: 'uIdProvider');
                    if( modeUser=='user' && uidUser==emailController.text)
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
                  child: Text('Sign in'))
            ]),
          ),
        ),
      ),
    );
  }
}
