import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etaproject/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationCubit extends Cubit<LocationStates> {
  LocationCubit() : super(LocationInitialState());

  static LocationCubit get(context) => BlocProvider.of(context);
  GoogleMapController? mapController1;

  Future getPermission() async {
    bool services;
    LocationPermission locationPermission;
    services = await Geolocator.isLocationServiceEnabled();
    print(services);
    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }
    if (locationPermission == LocationPermission.always) {
      emit(GetPositionSuccess());
    }
  }

  var currentLocation;
  var lat;
  var lang;
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  getLatAndLong({uId, mode}) {
    currentLocation = Geolocator.getCurrentPosition().then((value) {
      lat = value.latitude;
      lang = value.longitude;
      print(lat);
      print(lang);
      LatLng lng = LatLng(lat, lang);
      FirebaseFirestore.instance.collection(mode).doc(uId).set({
        'current location': GeoPoint(value.latitude, value.longitude),
        'mode': mode,
      }, SetOptions(merge: true));
      Marker marker = Marker(
          markerId: MarkerId(uId),
          position: LatLng(lat, lang),
          infoWindow: InfoWindow(title: uId));
      print(marker.markerId.value);
      markers.removeWhere((element) => element.markerId.value == uId);
      markers.add(marker);
      print('markers ${markers.length}');
      mapController1?.animateCamera(CameraUpdate.newLatLng(lng));

// real time tracking
//       Geolocator.getPositionStream()
//           .listen((event) {
//         FirebaseFirestore.instance.collection('users').doc('1').set(
//             {
//               'name': 'salma',
//               'real location': GeoPoint(event.latitude, event.longitude)});
//         // print(event.latitude.toString() + " " + event.longitude.toString());
//       });
//       FirebaseFirestore.instance.collection('users').snapshots().listen((
//           event) {
//         for (var element in event.docChanges) {
//           markers.add(Marker(
//               markerId: MarkerId('2'),
//               infoWindow: InfoWindow(title: element.doc.data()?['name']),
//               position: LatLng(element.doc.data()?['real location'].latitude,
//                   element.doc.data()?['real location'].longitude)));
//           print(element.doc.data()?['real location'].latitude.toString());
//           print(element.doc.data()?['real location'].longitude.toString());
//           emit(ChangeLocation());
//         }
//       }
//       );

      // mapController2?.animateCamera(CameraUpdate.newLatLng(lng1));
      // List<Placemark> placeMarks =  placemarkFromCoordinates(value.latitude,value.longitude);
      // print(placeMarks[0].country);
      // print(placeMarks[0].administrativeArea); // print(placeMarks[0].locality);
      emit(GetCurrentLocationSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(GetCurrentLocationError(error.toString()));
    });
  }

  List<String> screensByDrawer = [
    'Home page',
    'Settings',
    'Language',
  ];
  List<IconData> drawerIcons = [
    Icons.home,
    Icons.miscellaneous_services,
    Icons.language,
  ];

  Widget buildDrawer() => Drawer(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              accountName: Text('admin'),
              accountEmail: Text('admin@gmail.com'),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.pink,
                child: Text(
                  'A',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              )),
        ],
      ));

  bool isDark = false;
  String style = '';
  changeMood(context)async
  {
    isDark=!isDark;
    emit(ChangeMoodSuccessfully());
    if(isDark)
    {
      style=await DefaultAssetBundle.of(context).loadString('assets/darktheme.json');
      await mapController1?.setMapStyle(style);
      emit(DarkMoodSuccessfully());
    }
    else
    {
      style=await DefaultAssetBundle.of(context).loadString('assets/lighttheme.json');
      await mapController1?.setMapStyle(style);
      emit(LightMoodSuccessfully());
    }

  }
  GoogleMapController? mapController2;

  var liveLat;
  var liveLang;

  void realTimeTracking(String uId, String service) {
    Geolocator.getPositionStream().listen((event) {
      FirebaseFirestore.instance.collection('providers').doc(uId).set({
        'real location': GeoPoint(event.latitude, event.longitude),
        'mode': 'provider',
        'service': service
      }, SetOptions(merge: true));
    });
    FirebaseFirestore.instance
        .collection('providers')
        .snapshots()
        .listen((event) {
      for (var element in event.docChanges) {
        markers.add(Marker(
            markerId: MarkerId(element.doc.id),
            infoWindow: InfoWindow(title: 'provider'),
            position: LatLng(element.doc.data()?['real location'].latitude,
                element.doc.data()?['real location'].longitude)));
        liveLat = element.doc.data()?['real location'].latitude;
        liveLang = element.doc.data()?['real location'].longitude;
        emit(LiveLocation());
      }

      mapController2
          ?.animateCamera(CameraUpdate.newLatLng(LatLng(liveLat, liveLang)));
    });
  }

  bool appeared = true;
  buttonDisappeared() {
    appeared = false;
    emit(ButtonDisappeared());
  }
  List<ServiceItem> services =
  [
    ServiceItem(
        name: 'Tow Truck', image: 'assets/new-tow.png', isClicked: false),
    ServiceItem(name: 'winch',
        image: 'assets/new-win.png', isClicked: false),
    ServiceItem(
        name: 'Emergency',
        image: 'assets/front-line (1).png',
        isClicked: false),
    ServiceItem(
        name: 'First Aid',
        image: 'assets/first-aid-kit (1).png',
        isClicked: false),
    ServiceItem(name: 'Fuel',
        image: 'assets/fuel.png', isClicked: false),
    ServiceItem(
        name: 'JumpStart', image: 'assets/battery.png', isClicked: false),
    ServiceItem(name: 'Key Lockout',
        image: 'assets/key.png', isClicked: false),
    ServiceItem(name: 'Tire Change',
        image: 'assets/tire.png', isClicked: false)
  ];
  List<ServiceItem>emergencyItems=
  [
    ServiceItem(name: 'Fire Stations', image: 'assets/fire-truck.png', isClicked: false),
    ServiceItem(name: 'Hospitals', image: 'assets/hospital.png', isClicked: false),
    ServiceItem(name: 'Police Stations', image:'assets/police-station.png', isClicked: false)
  ];
  List<ServiceItem>servicesClicked=[];
  bool isServiceClicked(ServiceItem model,uId,serviceName)
  {
    model.isClicked=!model.isClicked;

    if(model.isClicked==true )
    {
      servicesClicked.add(model);
      FirebaseFirestore.instance.collection('provider').doc(uId).set({'services':FieldValue.arrayUnion([serviceName])},SetOptions(merge: true));
    }
    else if(model.isClicked==false && servicesClicked.contains(model))
    {
      servicesClicked.remove(model);
      FirebaseFirestore.instance.collection('provider').doc(uId).set({'services':FieldValue.arrayRemove([serviceName])},SetOptions(merge: true));
    }

    print(model.isClicked);
    print(servicesClicked.length);
    emit(ServiceClickedSuccessfully());

    return model.isClicked;
  }
  void removeService(model,uId,serviceName)
  {
    servicesClicked.remove(model);
    FirebaseFirestore.instance.collection('provider').doc(uId).set({'services':FieldValue.arrayRemove([serviceName])},SetOptions(merge: true));

    emit(RemovedSuccessfully());
  }

}
class ServiceItem
{
  String image;
  String name;
  bool isClicked;
  ServiceItem(
      {required this.name, required this.image, required this.isClicked});
}

