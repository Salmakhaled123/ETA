import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etaproject/cubit/cubit.dart';
import 'package:etaproject/modules/providermapscreen.dart';
import 'package:etaproject/modules/signInWithMailAddress.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../cache/shared_pref.dart';
import '../components/constants.dart';
import '../utiles/showSnackBar.dart';
import 'mapScreen.dart';

class HomeScreen extends StatefulWidget {
  String? uId;
  HomeScreen({this.uId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passController = TextEditingController();
  final phoneController =TextEditingController();
  final confPasswordController =TextEditingController();
  final carTypeController =TextEditingController();
  final carModelController = TextEditingController();
  final licController =TextEditingController();
  final focusName=FocusNode();
  final focusEmail =FocusNode();
  final focusPassword=FocusNode();
  final focusConfPassword=FocusNode();
  final focusPhone =FocusNode();
  final focusLic =FocusNode();
  final focusCarType = FocusNode();
  final focusCarModel = FocusNode();

  bool _confPasswordVisible = false;
  bool _passwordVisible = false;

late  UserCredential response;

  var formKey = GlobalKey<FormState>();

  signUp() async {
    try{
      if(passController.text!=confPasswordController.text){showSnackBar(context, 'The password Not Match.');}
      else if (nameController.text.isEmpty) {showSnackBar(context, 'Name Can/t be empty');}
      else if (phoneController.text.isEmpty) {showSnackBar(context, 'Phone Can/t be empty');}
      else if (emailController.text.isEmpty) {showSnackBar(context, 'Email can/t be empty');}
      else if (!emailRegExp.hasMatch(emailController.text)) {showSnackBar(context,  'Enter a correct email');}
      else if (confPasswordController.text.isEmpty){showSnackBar(context, 'Password Can/t be empty');}
      else if (confPasswordController.text.length<8){showSnackBar(context,'Enter a password with length at least 8');}
      else if (carModelController.text.isEmpty) {showSnackBar(context, 'Car Model Can/t be empty');}
      else if (carTypeController.text.isEmpty) {showSnackBar(context, 'Car Type Can/t be empty');}
      else if (licController.text.isEmpty) {showSnackBar(context, 'Licence Can/t be empty');}
      else if(modes==null )
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

      else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: confPasswordController.text);
        FirebaseFirestore.instance
            .collection(modes)
            .doc(emailController.text)
            .set({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'car model':carModelController.text,
          'car type':carTypeController.text,
          'license':licController.text,
        }, SetOptions(merge: true));
        showSnackBar(context, "signed up successfully");
        if(modes=='provider')
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
        else if(modes=='user' )
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
      }
    } on FirebaseAuthException catch(e) {
        if (e.code == 'weak-password') {
          showSnackBar(context, 'The password provided is too weak.');
        }
        else if (e.code == 'email-already-in-use') {
          showSnackBar(context, 'The account already exists for that email.');
        }
        else if (e.code == 'notMatch') {
          showSnackBar(context, 'The password Not Match.');
        }
        else {
          showSnackBar(context, e.message!);
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
      appBar: AppBar(
        title: const Text('Register',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Serif',color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      backgroundColor: Colors.white,
      body: ListView(

          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Image(image: AssetImage('assets/SignupEmail.png'),height:150,width: 300,),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 5),
              child: TextFormField(
                controller: nameController,
                focusNode: focusName,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  hintText: "Name",
                  hintStyle: const TextStyle(fontFamily: 'Serif',color: Colors.grey),
                  focusedBorder: OutlineInputBorder(borderSide:
                  const BorderSide(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(12)),
                  fillColor: Colors.grey.shade100,
                  filled: true,

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: TextFormField(
                controller: phoneController,
                focusNode: focusPhone,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  hintText: "Phone Number",
                  hintStyle: const TextStyle(fontFamily: 'Serif',color: Colors.grey),
                  focusedBorder: OutlineInputBorder(borderSide:
                  const BorderSide(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(12)),
                  fillColor: Colors.grey.shade100,
                  filled: true,

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: TextFormField(
                controller: emailController,
                focusNode: focusEmail,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  hintText: "Email",
                  hintStyle: const TextStyle(fontFamily: 'Serif',color: Colors.grey),
                  focusedBorder: OutlineInputBorder(borderSide:
                  const BorderSide(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(12)),
                  fillColor: Colors.grey.shade100,
                  filled: true,

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: TextFormField(
                controller: passController,
                focusNode: focusPassword,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: const TextStyle(fontFamily: 'Serif',color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  focusedBorder: OutlineInputBorder(borderSide:
                  const BorderSide(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(12)),
                  fillColor: Colors.grey.shade100,
                  filled: true,


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

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: TextFormField(
                controller: confPasswordController,
                focusNode: focusConfPassword,
                obscureText: !_confPasswordVisible,
                decoration: InputDecoration(
                  hintText: "Confirm Password",
                  hintStyle: const TextStyle(fontFamily: 'Serif',color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  focusedBorder: OutlineInputBorder(borderSide:
                  const BorderSide(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(12)),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.indigo,
                    ),
                    onPressed: () {
                      setState(() {
                        _confPasswordVisible = !_confPasswordVisible;
                      });
                    },
                  ),


                ),
              ),
            ),
            Row(children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 10, 10, 5),
                  child: TextFormField(
                    controller: carTypeController,
                    focusNode: focusCarType,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      hintText: "Car Type",
                      hintStyle: const TextStyle(fontFamily: 'Serif',color: Colors.grey),
                      focusedBorder: OutlineInputBorder(borderSide:
                      const BorderSide(color: Colors.indigo),
                          borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.grey.shade100,
                      filled: true,

                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 10, 15, 5),
                  child: TextFormField(
                    controller: carModelController,
                    focusNode: focusCarModel,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      hintText: "Car Model",
                      hintStyle: const TextStyle(fontFamily: 'Serif',color: Colors.grey),
                      focusedBorder: OutlineInputBorder(borderSide:
                      const BorderSide(color: Colors.indigo),
                          borderRadius: BorderRadius.circular(12)),
                      fillColor: Colors.grey.shade100,
                      filled: true,

                    ),
                  ),
                ),
              ),
            ],),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
              child: TextFormField(
                controller: licController,
                focusNode: focusLic,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)
                  ),
                  hintText: "License",
                  hintStyle: const TextStyle(fontFamily: 'Serif',color: Colors.grey),
                  focusedBorder: OutlineInputBorder(borderSide:
                  const BorderSide(color: Colors.indigo),
                      borderRadius: BorderRadius.circular(12)),
                  fillColor: Colors.grey.shade100,
                  filled: true,

                ),
              ),
            ),
              Row(
                children: [
                  SizedBox(width: 25,),
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
                          fontSize: 17,
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

              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: RadioListTile(
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
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),),
                    onPressed: () async
                    {
                    var cubit=  LocationCubit.get(context);
                    cubit.info=null;
                    cubit.lngUser=null;


                    response = signUp();


                      // That's it to display an alert, use other properties to customize.
                    },
                    child: Text('Sign Up')),
              )
            ]),);

  }
}
