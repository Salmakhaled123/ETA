import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import 'directions_model.dart';
import 'distance_matrix_model.dart';

class DirectionsRepository {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json?';
  static const String baseUrl2 =
      'https://maps.googleapis.com/maps/api/distancematrix/json?';

  final Dio _dio;

  DirectionsRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<Directions?> getDirections({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final response = await _dio.get(
      _baseUrl,
      queryParameters: {
        'origin': '${origin.latitude},${origin.longitude}',
        'destination': '${destination.latitude},${destination.longitude}',
        'key': "AIzaSyAyI0JudLgooPjOCDpqWCZaNQPRUkspsDc",
      },
    );

    // Check if response is successful
    if (response.statusCode == 200) {
      print(response.data);
      return Directions.fromMap(response.data);
    }
    return null;
  }

  List<LatLng> origins = [];
  List<LatLng> destinations = [];
  List<DistanceMatrixElement> sortedElements = [];
  List<DistanceMatrixElement> elements = [];
  Future<List<DistanceMatrixElement>> getDistanceMatrix(context) async {
    List<String> destinationStrings = [];
    List<String> originStrings = [];
    await FirebaseFirestore.instance.collection('user').get().then((value) {
      for (var doc in value.docs) {
        origins.add(LatLng(
          doc.data()['current location'].latitude,
          doc.data()['current location'].longitude,
        ));
      }
      originStrings = origins.map((latLng) {
        return '${latLng.latitude},${latLng.longitude}';
      }).toList();
      print('origins${origins.length} $origins');
    });
    await FirebaseFirestore.instance.collection('provider').get().then((value) {
      for (var doc in value.docs) {
        destinations.add(LatLng(
          doc.data()['current location'].latitude,
          doc.data()['current location'].longitude,
        ));
      }
      destinationStrings = destinations.map((latLng) {
        return '${latLng.latitude},${latLng.longitude}';
      }).toList();
      print('destinations${destinations.length} $destinations');
    });
    print('=========================strings===================');
    print(destinationStrings);
    print(originStrings);
    try {
      final response = await _dio.get(baseUrl2,
          options: Options(contentType: 'application/json'),
          queryParameters: {
            'origins': originStrings.join('|'),
            'destinations': destinationStrings.join('|'),
            'key': "AIzaSyDxMrnzQP767IAB6Gg-e6zTjLalfJuI1Mw",
            'units': 'metric',
            'mode': 'driving'
          });
      if (response.statusCode == 200) {
        print('======================response======================');
        final json = response.data as Map<String, dynamic>;
        print(response.data);
        print('====================response============================');
        // Assuming you have retrieved the sorted list using the code mentioned in the previous response
        elements = List<DistanceMatrixElement>.from(json['rows'][0]['elements']
            .map((element) => DistanceMatrixElement.fromJson(element)));
        for (var element in elements) {
          print(
              'Duration: ${element.duration.text}, Distance: ${element.distance.text}');
        }
        Map<LatLng, String> complexElements = {};
        for (var i = 0; i < destinations.length; i++)
        {
          // Use the LatLng value as the key and the corresponding
          // DistanceMatrixElement as the value in the Map
          complexElements[destinations[i]] = elements[i].duration.text;
        }
        print(complexElements);
        sortedElements = List<DistanceMatrixElement>.from(json['rows'][0]
                ['elements']
            .map((element) => DistanceMatrixElement.fromJson(element)))
          ..sort((a, b) => int.parse(
                  a.duration.text.replaceAll(RegExp(r'[^0-9]'), ''))
              .compareTo(int.parse(b.duration.text.replaceAll(RegExp(r'[^0-9]'),
                  '')))); // The sorted list of DistanceMatrixElement objects
// Printing the sorted list to the console
        print('====================new ==================');
        for (var i = 0; i < destinations.length; i++) {
          if (sortedElements[0].duration.text ==
              complexElements[destinations[i]]) {
            print('${destinations[i]} =>${complexElements[destinations[i]]}');
            FirebaseFirestore.instance
                .collection('provider')
                .get()
                .then((value) {
              for (var doc in value.docs) {
                if (LatLng(doc.data()['current location'].latitude,
                        doc.data()['current location'].longitude) ==
                    destinations[i]) {
                  return QuickAlert.show(
                      context: context,
                      type: QuickAlertType.info,
                      title: 'provider name ${doc.data()['name']}',
                      text: 'car model ${doc.data()['car model']} ,'
                          'eta ${complexElements[destinations[i]]}');
                }
              }
            });
            break;
          }
        }
        print('====================new ==================');
        print('Sorted DistanceMatrixElement list:');
        for (var element in sortedElements) {
          print(
              'Duration: ${element.duration.text}, Distance: ${element.distance.text}');
        }
        return sortedElements;
      } else {
        throw DioError(
            requestOptions: response.requestOptions,
            response: response,
            error: 'Request failed with status code ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw e.error.toString();
    } catch (e) {
      throw e.toString();
    }
  }
}
