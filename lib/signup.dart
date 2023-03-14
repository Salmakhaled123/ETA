import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etaproject/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'components/constants.dart';
import 'modules/mapScreen.dart';

class HomeScreen extends StatefulWidget {
  String? uId;

  HomeScreen({this.uId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //var user=FirebaseAuth.instance.currentUser;
  // Future<UserCredential> signInWithGoogle() async {
  //   // Trigger the authentication flow
  //   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   // Obtain the auth details from the request
  //   final GoogleSignInAuthentication? googleAuth =
  //   await googleUser?.authentication;
  //
  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth?.accessToken,
  //     idToken: googleAuth?.idToken,
  //   );
  //   print(' access token ${googleAuth!.accessToken}');
  //   print('id token ${googleAuth.idToken}');
  //
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  // verifyEmail()async
  // {
  //   User ? user = FirebaseAuth.instance.currentUser;
  //
  //   if (user!= null && !user.emailVerified) {
  //     await user.sendEmailVerification();
  //     QuickAlert.show(text: 'check your inbox for verification',
  //       context: context,
  //       type: QuickAlertType.info,
  //     );
  //   }
  // }

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  bool isObscure = false;

  UserCredential? response;
  dynamic modes;
  GoogleMapController? mapController1;
  var currentLocation;
  var lat;
  var lang;
  Set<Marker> markers = {};

  signUp() async {
    if (formKey.currentState!.validate()) {
      print('valid');
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passController.text,
        );
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
                  context: context,
                  title: 'Error',
                  body: const Text('The password provided is too weak.'))
              .show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
                  context: context,
                  title: 'Error',
                  body:
                      const Text('The account already exists for that email.'))
              .show();
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('not valid');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Center(
                child: Image.network(
                    height: 250,
                    'https://img.freepik.com/free-vector/scheduling-planning-setting-goals-schedule-timing-workflow-optimization-taking-note-assignment-businesswoman-with-timetable-cartoon-character_335657-2580.jpg?w=740&t=st=1675393490~exp=1675394090~hmac=73c74c6e71eb7e9c146091ff4405f54d833c5fc2981c77374c73ea0c1d88c1a0'),
              ),
              TextFormField(
                  style: TextStyle(color: Colors.black),
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  validator: (data) {
                    if (data!.isEmpty) {
                      return 'this field is required';
                    }
                  },
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: 'username ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)))),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  style: TextStyle(color: Colors.black),
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
                  style: TextStyle(color: Colors.black),
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
                height: 10,
              ),
              Row(
                children: [
                  Text('if you already have account ',
                      style: TextStyle(fontSize: 16)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
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
                height: 5.0,
              ),
              RadioListTile(
                  title: Text('user'),
                  value: 'user',
                  groupValue: modes,
                  onChanged: (value)
                  {
                    setState(() {
                      modes = value;
                      print(modes);
                      if (modes == 'user')
                      {
                        emails.add(emailController.text);
                        modess.add('user');
                        FirebaseFirestore.instance
                            .collection(modes)
                            .doc(emailController.text)
                            .set({
                          'name': nameController.text,
                          'email': emailController.text
                        }, SetOptions(merge: true));
                      }
                    });
                  }),
              RadioListTile(
                  title: Text('provider'),
                  contentPadding: EdgeInsets.zero,
                  value: 'provider',
                  groupValue: modes,
                  onChanged: (value) {
                    setState(() {
                      modes = value;
                      if (modes == 'provider') {
                        emails.add(emailController.text);
                        modess.add('provider');
                        FirebaseFirestore.instance
                            .collection(modes)
                            .doc(emailController.text)
                            .set({
                          'name': nameController.text,
                          'email': emailController.text
                        }, SetOptions(merge: true));
                      }
                    });
                  }),
              ElevatedButton(
                  onPressed: () async {
                    response = await signUp();
                    print(response!.user!.uid);
                    print(response!.user!.email);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapScreen(
                                  uId: emailController.text,
                                  mode: modes,
                                  name: nameController.text,
                              email: emailController.text,
                                )),
                        (route) => false);

                    // That's it to display an alert, use other properties to customize.
                  },
                  child: Text('Sign Up'))
            ]),
          ),
        ),
      ),
    );
  }
}
