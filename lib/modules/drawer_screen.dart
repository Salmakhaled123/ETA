import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/components.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../signIn.dart';
class DrawerPart extends StatelessWidget
{
  DrawerPart();
  @override
  Widget build(BuildContext context)
  {
    var cubit = LocationCubit.get(context);
    return BlocConsumer<LocationCubit,LocationStates>(listener:(context,state){} ,
      builder: (context,state){
      return Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.teal),
                  accountName: Text('admin'),
                  accountEmail: Text('email'),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.pink,
                    child: Text(
                      'S',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  )),
              buildDrawerItem(
                  cubit.screensByDrawer, cubit.drawerIcons, context,),
              SwitchListTile(
                value: LocationCubit.get(context).isDark,
                onChanged: (val)
                {
                // val=LocationCubit.get(context).isDark;
                //    LocationCubit.get(context).changeMood(
                //     context: context,);
                },
                title: Text('Theme',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                activeColor: Colors.teal,
                secondary: Icon(Icons.nightlight),
              ),
              ListTile(title: Text('log out',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),leading: Icon(Icons.logout,size: 30),onTap: ()async
              {
                
               await FirebaseAuth.instance.signOut();
               Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              }),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => ProviderScreen()));
                    },
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.teal)),
                    child: Text('Provider mode')),
              ),

            ],
          ));
      },

    );
  }
}
