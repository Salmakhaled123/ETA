import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../components/constants.dart';
import '../utiles/showSnackBar.dart';
import 'mapScreen.dart';

class phoneRegister extends StatefulWidget {
  const phoneRegister({super.key});

  @override
  State<phoneRegister> createState() => _phoneRegisterState();
}

class _phoneRegisterState extends State<phoneRegister> {
  final nameController=TextEditingController();
  final phoneController =TextEditingController();
  final carTypeController =TextEditingController();
  final carModelController = TextEditingController();
  final licController =TextEditingController();

  final registerKey =GlobalKey<FormState>();

  final focusName=FocusNode();
  final focusPhone =FocusNode();
  final focusLic =FocusNode();
  final focusCarType = FocusNode();
  final focusCarModel = FocusNode();


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        focusName.unfocus();
        focusPhone.unfocus();
        focusLic.unfocus();
        focusCarModel.unfocus();
        focusCarType.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Sign up',
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
            Row(
              children: [
                Expanded(child: Padding(
                  padding:const EdgeInsets.fromLTRB(60, 0, 60, 5),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),),
                      onPressed:() {
                        if (nameController.text.isEmpty) {
                          showSnackBar(context, 'Name Can/t be empty');
                        }
                        else if (phoneController.text.isEmpty) {
                          showSnackBar(context, 'Phone Can/t be empty');
                        }
                        else if (carModelController.text.isEmpty) {
                          showSnackBar(context, 'Car Model Can/t be empty');
                        }
                        else if (carTypeController.text.isEmpty) {
                          showSnackBar(context, 'Car Type Can/t be empty');
                        }
                        else if (licController.text.isEmpty) {
                          showSnackBar(context, 'Licence Can/t be empty');
                        }

                        else {
                          FirebaseFirestore.instance
                              .collection(modes)
                              .doc(phoneController.text)
                              .set({
                            'name': nameController.text,
                            'phone': phoneController.text,
                            'car model':carModelController.text,
                            'car type':carTypeController.text,
                            'license':licController.text,
                          }, SetOptions(merge: true));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => MapScreen(mode: modes, uId: phoneController.text,),
                            ),
                          );
                        }

                      },

                      child:const Text('Sign Up',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Serif',color:Colors.white))

                  ),
                )),
              ],
            )
          ],),
      ),
    );
  }
}

