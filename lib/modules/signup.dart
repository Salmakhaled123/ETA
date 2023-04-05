import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etaproject/cubit/cubit.dart';
import 'package:etaproject/modules/providermapscreen.dart';
import 'package:etaproject/modules/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../cache/shared_pref.dart';
import 'mapScreen.dart';

class HomeScreen extends StatefulWidget {
  String? uId;

  HomeScreen({this.uId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  bool isObscure = false;

late  UserCredential response;
  dynamic modes;
  GoogleMapController? mapController1;
  var currentLocation;
  var lat;
  var lang;
  Set<Marker> markers = {};
  var formKey = GlobalKey<FormState>();
  signUp() async {
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
    }


  @override
  void initState() {
    super.initState();
  }

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
              ElevatedButton(
                  onPressed: () async
                  {
                  var cubit=  LocationCubit.get(context);
                  cubit.info=null;
                  cubit.lngUser=null;

                    print('salma + $modes');

                    if(modes=='provider'&& formKey.currentState!.validate())
                      {
                        await  CacheHelper.saveStringData(key: 'uIdProvider', value: emailController.text);
                        await  CacheHelper.saveStringData(key: 'modeProvider', value: modes);
                        await  CacheHelper.saveStringData(key: 'nameProvider', value: nameController.text);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProviderMapScreen(
                                  uId: emailController.text,
                                  mode: modes,
                                )),
                                (route) => false);
                      }
                    else if(modes=='user' && formKey.currentState!.validate())
                      {
                        await  CacheHelper.saveStringData(key: 'uIdUser', value: emailController.text);
                      await  CacheHelper.saveStringData(key: 'modeUser', value: modes);
                      await  CacheHelper.saveStringData(key: 'nameUser', value: nameController.text);
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
                      }
                    if(modes==null )
                      {
                        Fluttertoast.showToast(
                            msg: "please select one of the options",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }
                    if( formKey.currentState!.validate() && modes!=null)
                      {
                        response = await signUp();
                        FirebaseFirestore.instance
                            .collection(modes)
                            .doc(emailController.text)
                            .set({
                          'name': nameController.text,
                          'email': emailController.text
                        }, SetOptions(merge: true));
                      }

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
