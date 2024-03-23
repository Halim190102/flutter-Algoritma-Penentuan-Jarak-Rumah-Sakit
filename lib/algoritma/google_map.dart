import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rumkit/algoritma/ant_colony.dart';
import 'package:rumkit/algoritma/hubeny.dart';

Future<List<List<double>>> googleMapDistance(
    List<List<double>> coordinates) async {
  final List<List<double>> distances = [];
  for (int i = 0; i < coordinates.length; i++) {
    distances.add([]);
    for (int j = 0; j < coordinates.length; j++) {
      double lat1 = coordinates[i][0];
      double lon1 = coordinates[i][1];
      double lat2 = coordinates[j][0];
      double lon2 = coordinates[j][1];

      // List<LatLng> polylineCoordinates = [];

      // PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      //   'AIzaSyBuPIfRdEYytBK14tIFaDq1cBPZEHj9kQw',
      //   PointLatLng(lat1, lon1),
      //   PointLatLng(lat2, lon2),
      //   travelMode: TravelMode.driving,
      // );
      // for (var point in result.points) {
      //   polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      // }

      // double totalDistance = 0;
      // for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      //   totalDistance += hubeny(
      //       polylineCoordinates[i].latitude,
      //       polylineCoordinates[i].longitude,
      //       polylineCoordinates[i + 1].latitude,
      //       polylineCoordinates[i + 1].longitude);
      // }
      // distances[i].add(totalDistance);
      Response response = await Dio().get(
          "https://maps.googleapis.com/maps/api/distancematrix/json?destinations=${lat2.toString()},${lon2.toString()}&origins=${lat1.toString()},${lon1.toString()}&key=AIzaSyBuPIfRdEYytBK14tIFaDq1cBPZEHj9kQw");
      int data = response.data['rows'][0]['elements'][0]['distance']['value'];
      distances[i].add(data.toDouble());
    }
  }
  return distances;
}

googleMapCalculate(List<List<double>> newCoordinat, List<String> lokasi) async {
  List<List<double>> distanceCo = await googleMapDistance(newCoordinat);
  List dataJarak = antColony(lokasi, distanceCo);

  List<String> getLokasi = [];
  for (int i in dataJarak[0]) {
    getLokasi.add(lokasi[i]);
  }

  return [distanceCo, getLokasi, dataJarak[1], dataJarak[0]];
}
