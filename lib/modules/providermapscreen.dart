import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../components/components.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import 'drawer_screen.dart';

class ProviderMapScreen extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String? uId, name, mode, email;
  ProviderMapScreen({
    this.mode,
    required this.uId,
  });

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
              'Services',
              style: TextStyle(color: Colors.white),
            ),
          ),
          drawer: DrawerPart(uId: uId!, mode: mode!),
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
                                              child: GridView.builder(
                                                  itemCount: cubit.services.length,
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  padding: const EdgeInsets.only(
                                                      left: 20, right: 20),
                                                  gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                    mainAxisSpacing: 5,
                                                    crossAxisSpacing: 5,
                                                    crossAxisCount: 2,
                                                  ),
                                                  itemBuilder: (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        if (index == 2) {
                                                          showModalBottomSheet(
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.only(
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
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              top: 15.0,
                                                                              bottom:
                                                                              15.0,
                                                                              right: 20,
                                                                              left: 20),
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
                                                                      ListView
                                                                          .builder(shrinkWrap: true,
                                                                        physics:const  BouncingScrollPhysics(),
                                                                        itemBuilder:
                                                                            (context,
                                                                            index) {
                                                                          return GestureDetector(
                                                                              onTap:
                                                                                  ()
                                                                              {
                                                                                cubit.isServiceClicked(
                                                                                    cubit.emergencyItems[index],
                                                                                    uId,
                                                                                    cubit.emergencyItems[index].name);
                                                                              },
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.all(10.0),

                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  child: Card(
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                                                    color: cubit.emergencyItems[index].isClicked ? Colors.teal : Colors.white70,
                                                                                    child: Container(width: 160,height: 180,
                                                                                      child: Padding(
                                                                                        padding:
                                                                                        const EdgeInsets.all(10),
                                                                                        child:
                                                                                        Column(
                                                                                          children: [
                                                                                            Image(width: 100,height: 120,
                                                                                              image: AssetImage(cubit.emergencyItems[index].image),
                                                                                            ),
                                                                                            Text(
                                                                                              cubit.emergencyItems[index].name,
                                                                                              style:const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Serif'),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),),
                                                                                ),
                                                                              ));
                                                                          //fire stations

                                                                        },
                                                                        itemCount: cubit
                                                                            .emergencyItems
                                                                            .length,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                          );
                                                        } else {
                                                          cubit.isServiceClicked(
                                                              cubit.services[index],
                                                              uId,
                                                              cubit.services[index]
                                                                  .name);
                                                        }
                                                      },
                                                      child: Card(
                                                        shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                20.0)),
                                                        color: cubit.services[index]
                                                            .isClicked
                                                            ? Colors.teal
                                                            : Colors.white70,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                                width: 80,
                                                                height: 100,
                                                                child: Image(
                                                                  image: AssetImage(
                                                                      cubit
                                                                          .services[
                                                                      index]
                                                                          .image),
                                                                )),
                                                            Text(
                                                              cubit.services[index]
                                                                  .name,
                                                              style:
                                                              const TextStyle(
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
                                                    );
                                                  })),
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
        );
      },
    );
  }
}
