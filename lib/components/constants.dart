import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/distance_matrix_model.dart';

// List<LatLng> polylineCoordinates = [
// ];
int reqButton =0;
Map<LatLng, String> complexElements = {};
Map<LatLng, String> originElements = {};
List<String>emails=[];
List<String>providersUid=[];
List<String>modess= [];
List<LatLng> destinations = [];
List<LatLng> origins = [];
List<DistanceMatrixElement> sortedElements = [];
dynamic modes;

