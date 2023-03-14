import 'package:etaproject/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/components.dart';
import '../cubit/states.dart';
import 'drawer_screen.dart';

class MapScreen extends StatelessWidget
{
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String ? uId, name, mode, email;
  MapScreen({this.mode,
       required this.uId,
       this.name,
      // required this.mode,
       this.email});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LocationCubit, LocationStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = LocationCubit.get(context);
        print('uId $uId');
        print('mode $mode');
        var searchController = TextEditingController();
        double mediaHeight = MediaQuery.of(context).size.height;
        double mediaWidth = MediaQuery.of(context).size.height;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: const Text(
              'My Current Location',
              style: TextStyle(color: Colors.white),
            ),
          ),
          drawer: DrawerPart(),
          body: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Container(
                height: mediaHeight,
                width: mediaWidth,
                child: GoogleMap(
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(30.033333, 31.233334),
                    zoom: 15.0,
                  ),
                  onMapCreated: (GoogleMapController controller) async {
                    cubit.mapController1 = controller;
                    // controller.setMapStyle(cubit.style);
                  },
                  markers: cubit.markers,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: defaultFormField(
                  label: 'Search Places',
                  prefix: Icons.search,
                  type: TextInputType.text,
                  isPassword: false,
                  controller: searchController,
                  validate: (String? value) {
                    if (value!.isEmpty) {
                      return 'search musn\' t be empty';
                    }
                  },
                ),
              ),
              // SizedBox(
              //   height: mediaHeight * 0.5,
              // ),
              Positioned(
                height: mediaHeight * 0.5,
                right: 0.0,
                top: mediaHeight * 0.3,
                child: InkWell(
                    onTap: () async {
                      cubit.getPermission();
                      cubit.getLatAndLong(
                        mode: mode,
                        uId: uId,
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.teal,
                      radius: 20,
                      child:
                          Icon(Icons.location_searching, color: Colors.white),
                    )),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
                child: Center(
                  child: Column(
                    children: [
                      const Spacer(),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 5.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0)),
                              backgroundColor: Colors.teal),
                          child: Row(
                            children: const [
                              Icon(Icons.arrow_upward_outlined),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Select the type of service',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Serif')),
                            ],
                          ),
                          onPressed: () {
                            showModalBottomSheet<void>(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.0),
                                      topRight: Radius.circular(30.0))),
                              context: context,
                              builder: (BuildContext context) =>
                                  SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                        padding: const EdgeInsets.only(
                                            top: 15.0,
                                            bottom: 15.0,
                                            right: 20,
                                            left: 20),
                                        child: Row(
                                          children: [
                                            BackButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            const Text(
                                                'Select the type of service',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Serif')),
                                          ],
                                        )),
                                    SizedBox(
                                      height: 350,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            GridView.count(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              primary: false,
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20),
                                              mainAxisSpacing: 5,
                                              crossAxisSpacing: 5,
                                              crossAxisCount: 2,
                                              children: [
                                                GestureDetector(
                                                  onTap: () => {
                                                    showModalBottomSheet<void>(
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30.0))),
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          SizedBox(
                                                        height: 200,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15,
                                                                  right: 20,
                                                                  left: 20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child:
                                                                    BackButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ), //back button
                                                              Container(
                                                                height: 60,
                                                                width: 250,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            30.0)),
                                                                    color: Colors
                                                                            .grey[
                                                                        300]),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: const [
                                                                        Text(
                                                                            'Tow Truck',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                            '350 - 400 EG',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                      ]),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ), //space
                                                              SizedBox(
                                                                height: 50,
                                                                width: 150,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>RequestScreen(uId: uId,service: 'Tow truck',)));
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              50.0)),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .teal),
                                                                  child: const Text(
                                                                      'Request',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontFamily:
                                                                              'Serif')),
                                                                ),
                                                              ), //Request Button
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  },
                                                  child: Card(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0)),
                                                    color: Colors.white70,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                            width: 80,
                                                            height: 100,
                                                            child: const Image(
                                                              image: AssetImage(
                                                                  'assets/new-tow.png'),
                                                            )),
                                                        const Text(
                                                          "Tow Truck",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontFamily:
                                                                  'Serif'),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ), // Tow Truck
                                                GestureDetector(
                                                  onTap: () => {
                                                    showModalBottomSheet<void>(
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30.0))),
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          SizedBox(
                                                        height: 200,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15,
                                                                  right: 20,
                                                                  left: 20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child:
                                                                    BackButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ), //back button
                                                              Container(
                                                                height: 60,
                                                                width: 250,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            30.0)),
                                                                    color: Colors
                                                                            .grey[
                                                                        300]),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: const [
                                                                        Text(
                                                                            'Winch',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                            '450 - 500 EG',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                      ]),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ), //space
                                                              SizedBox(
                                                                height: 50,
                                                                width: 150,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              50.0)),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .teal),
                                                                  child: const Text(
                                                                      'Request',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontFamily:
                                                                              'Serif')),
                                                                ),
                                                              ), //Request Button
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  },
                                                  child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                      color: Colors.white70,
                                                      child: Column(
                                                        children: const [
                                                          SizedBox(
                                                              width: 80,
                                                              height: 100,
                                                              child: Image(
                                                                image: AssetImage(
                                                                    'assets/new-win.png'),
                                                              )),
                                                          Text(
                                                            "winch",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'Serif'),
                                                          )
                                                        ],
                                                      )),
                                                ), // Winch
                                                GestureDetector(
                                                  onTap: () => {
                                                    showModalBottomSheet(
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30.0))),
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0,
                                                                        bottom:
                                                                            15.0,
                                                                        right:
                                                                            20,
                                                                        left:
                                                                            20),
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child:
                                                                    BackButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                )),
                                                            SizedBox(
                                                              height: 350,
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () =>
                                                                              {
                                                                        showModalBottomSheet(
                                                                          shape:
                                                                              const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext context) =>
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 20, left: 20),
                                                                                    alignment: Alignment.topLeft,
                                                                                    child: BackButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    )),
                                                                                const SizedBox(
                                                                                  height: 200,
                                                                                  child: Text("Fire stations near me"),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      },
                                                                      child: Card(
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                          color: Colors.white70,
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10),
                                                                            child:
                                                                                Column(
                                                                              children: const [
                                                                                SizedBox(
                                                                                    width: 150,
                                                                                    height: 120,
                                                                                    child: Image(
                                                                                      image: AssetImage('assets/fire-truck.png'),
                                                                                    )),
                                                                                Text(
                                                                                  "Fire Stations",
                                                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Serif'),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )), //fire stations
                                                                    ), //Fire Station
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () =>
                                                                              {
                                                                        showModalBottomSheet(
                                                                          shape:
                                                                              const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext context) =>
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 20, left: 20),
                                                                                    alignment: Alignment.topLeft,
                                                                                    child: BackButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    )),
                                                                                const SizedBox(
                                                                                  height: 200,
                                                                                  child: Text("Hospitals near me"),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      },
                                                                      child: Card(
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                          color: Colors.white70,
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10),
                                                                            child:
                                                                                Column(
                                                                              children: const [
                                                                                SizedBox(
                                                                                    width: 150,
                                                                                    height: 120,
                                                                                    child: Image(
                                                                                      image: AssetImage('assets/hospital.png'),
                                                                                    )),
                                                                                Text(
                                                                                  "Hospitals",
                                                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Serif'),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )), //fire stations
                                                                    ), //Hospitals
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () =>
                                                                              {
                                                                        showModalBottomSheet(
                                                                          shape:
                                                                              const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                                                                          context:
                                                                              context,
                                                                          builder: (BuildContext context) =>
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                    padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, right: 20, left: 20),
                                                                                    alignment: Alignment.topLeft,
                                                                                    child: BackButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                    )),
                                                                                const SizedBox(
                                                                                  height: 200,
                                                                                  child: Text("Police stations near me"),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        )
                                                                      },
                                                                      child: Card(
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                          color: Colors.white70,
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(10),
                                                                            child:
                                                                                Column(
                                                                              children: const [
                                                                                SizedBox(
                                                                                    width: 150,
                                                                                    height: 120,
                                                                                    child: Image(
                                                                                      image: AssetImage('assets/police-station.png'),
                                                                                    )),
                                                                                SizedBox(
                                                                                  height: 5,
                                                                                ),
                                                                                Text(
                                                                                  "Police Stations",
                                                                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Serif'),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )), //fire stations
                                                                    ), //Police Station
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  },
                                                  child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                      color: Colors.white70,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              width: 80,
                                                              height: 100,
                                                              child:
                                                                  const Image(
                                                                image: AssetImage(
                                                                    'assets/front-line (1).png'),
                                                              )),
                                                          const Text(
                                                            "Emergency",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'Serif'),
                                                          )
                                                        ],
                                                      )),
                                                ), //Emergency
                                                GestureDetector(
                                                  onTap: () => {
                                                    showModalBottomSheet<void>(
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30.0))),
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          SizedBox(
                                                        height: 200,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15,
                                                                  right: 20,
                                                                  left: 20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child:
                                                                    BackButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ), //back button
                                                              Container(
                                                                height: 60,
                                                                width: 250,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            30.0)),
                                                                    color: Colors
                                                                            .grey[
                                                                        300]),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: const [
                                                                        Text(
                                                                            'First Aid',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                            '150 - 200 EG',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                      ]),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ), //space
                                                              SizedBox(
                                                                height: 50,
                                                                width: 150,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              50.0)),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .teal),
                                                                  child: const Text(
                                                                      'Request',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontFamily:
                                                                              'Serif')),
                                                                ),
                                                              ), //Request Button
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  },
                                                  child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                      color: Colors.white70,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              width: 80,
                                                              height: 100,
                                                              child:
                                                                  const Image(
                                                                image: AssetImage(
                                                                    'assets/first-aid-kit (1).png'),
                                                              )),
                                                          const Text(
                                                            "First Aid",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'Serif'),
                                                          )
                                                        ],
                                                      )),
                                                ), // first aid
                                                GestureDetector(
                                                  onTap: () => {
                                                    showModalBottomSheet<void>(
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30.0))),
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          SizedBox(
                                                        height: 200,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15,
                                                                  right: 20,
                                                                  left: 20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child:
                                                                    BackButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ), //back button
                                                              Container(
                                                                height: 60,
                                                                width: 250,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            30.0)),
                                                                    color: Colors
                                                                            .grey[
                                                                        300]),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: const [
                                                                        Text(
                                                                            'Fuel',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                            '260 - 350 EG',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                      ]),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ), //space
                                                              SizedBox(
                                                                height: 50,
                                                                width: 150,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              50.0)),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .teal),
                                                                  child: const Text(
                                                                      'Request',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontFamily:
                                                                              'Serif')),
                                                                ),
                                                              ), //Request Button
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  },
                                                  child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                      color: Colors.white70,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              width: 80,
                                                              height: 100,
                                                              child:
                                                                  const Image(
                                                                image: AssetImage(
                                                                    'assets/fuel.png'),
                                                              )),
                                                          const Text(
                                                            "Fuel",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'Serif'),
                                                          )
                                                        ],
                                                      )),
                                                ), // fuel
                                                GestureDetector(
                                                  onTap: () => {
                                                    showModalBottomSheet<void>(
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30.0))),
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          SizedBox(
                                                        height: 200,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15,
                                                                  right: 20,
                                                                  left: 20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child:
                                                                    BackButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ), //back button
                                                              Container(
                                                                height: 60,
                                                                width: 250,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            30.0)),
                                                                    color: Colors
                                                                            .grey[
                                                                        300]),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: const [
                                                                        Text(
                                                                            'JumpStart',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                            '50 - 120 EG',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                      ]),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ), //space
                                                              SizedBox(
                                                                height: 50,
                                                                width: 150,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              50.0)),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .teal),
                                                                  child: const Text(
                                                                      'Request',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontFamily:
                                                                              'Serif')),
                                                                ),
                                                              ), //Request Button
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  },
                                                  child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                      color: Colors.white70,
                                                      child: Column(
                                                        children: const [
                                                          SizedBox(
                                                              width: 80,
                                                              height: 100,
                                                              child: Image(
                                                                image: AssetImage(
                                                                    'assets/battery.png'),
                                                              )),
                                                          Text(
                                                            "JumpStart",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'Serif'),
                                                          )
                                                        ],
                                                      )),
                                                ), // jumpstart
                                                GestureDetector(
                                                  onTap: () => {
                                                    showModalBottomSheet<void>(
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30.0))),
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          SizedBox(
                                                        height: 200,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15,
                                                                  right: 20,
                                                                  left: 20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child:
                                                                    BackButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ), //back button
                                                              Container(
                                                                height: 60,
                                                                width: 250,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            30.0)),
                                                                    color: Colors
                                                                            .grey[
                                                                        300]),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: const [
                                                                        Text(
                                                                            'Key Lockout',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                            '70 - 140 EG',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                      ]),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ), //space
                                                              SizedBox(
                                                                height: 50,
                                                                width: 150,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              50.0)),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .teal),
                                                                  child: const Text(
                                                                      'Request',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontFamily:
                                                                              'Serif')),
                                                                ),
                                                              ), //Request Button
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  },
                                                  child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                      color: Colors.white70,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                              width: 80,
                                                              height: 100,
                                                              child:
                                                                  const Image(
                                                                image: AssetImage(
                                                                    'assets/key.png'),
                                                              )),
                                                          const Text(
                                                            "Key Lockout",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'Serif'),
                                                          )
                                                        ],
                                                      )),
                                                ), // key lockout
                                                GestureDetector(
                                                  onTap: () => {
                                                    showModalBottomSheet<void>(
                                                      shape: const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          30.0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          30.0))),
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          SizedBox(
                                                        height: 200,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15,
                                                                  right: 20,
                                                                  left: 20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child:
                                                                    BackButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ), //back button
                                                              Container(
                                                                height: 60,
                                                                width: 250,
                                                                decoration: BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            30.0)),
                                                                    color: Colors
                                                                            .grey[
                                                                        300]),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(10),
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: const [
                                                                        Text(
                                                                            'Tire Change',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                        SizedBox(
                                                                          width:
                                                                              20,
                                                                        ),
                                                                        Text(
                                                                            '300 - 450 EG',
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: 'Serif')),
                                                                      ]),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 15,
                                                              ), //space
                                                              SizedBox(
                                                                height: 50,
                                                                width: 150,
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {},
                                                                  style: ElevatedButton.styleFrom(
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                              50.0)),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .teal),
                                                                  child: const Text(
                                                                      'Request',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .w600,
                                                                          fontFamily:
                                                                              'Serif')),
                                                                ),
                                                              ), //Request Button
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  },
                                                  child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                      color: Colors.white70,
                                                      child: Column(
                                                        children: const [
                                                          SizedBox(
                                                              width: 80,
                                                              height: 100,
                                                              child: Image(
                                                                image: AssetImage(
                                                                    'assets/tire.png'),
                                                              )),
                                                          Text(
                                                            "Tire Change",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    'Serif'),
                                                          )
                                                        ],
                                                      )),
                                                ), //Tire Change
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // floatingActionButton: FloatingActionButton(backgroundColor: Colors.teal,
          //   child: Icon(
          //     Icons.location_searching,
          //     color: Colors.white,
          //   ),
          //   onPressed: () async {
          //     cubit.getPosition();
          //     cubit.getLatAndLong();
          //   },
          // ),
        );
      },
    );
  }
}
