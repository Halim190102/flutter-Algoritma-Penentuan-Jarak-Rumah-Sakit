import 'dart:math';
import 'package:rumkit/algoritma/ant_colony.dart';
import 'package:vector_math/vector_math.dart';

hubeny(double lat1, double lon1, double lat2, double lon2) {
  final p = radians(lat1 + lat2) / 2;
  final m = pow(
      (6334834 / pow(sqrt(1 - 0.006674 * pow(sin(p), 2)), 3)) *
          radians(lat2 - lat1),
      2);
  final n = pow(
      (6377397 / sqrt(1 - 0.006674 * pow(sin(p), 2))) *
          cos(p) *
          radians(lon2 - lon1),
      2);
  final s = sqrt(m + n);
  return s;
}

List<List<double>> hubenyDistance(List<List<double>> coordinates) {
  final List<List<double>> distances = [];
  for (int i = 0; i < coordinates.length; i++) {
    distances.add([]);
    for (int j = 0; j < coordinates.length; j++) {
      double lat1 = coordinates[i][0];
      double lon1 = coordinates[i][1];
      double lat2 = coordinates[j][0];
      double lon2 = coordinates[j][1];
      distances[i].add(hubeny(lat1, lon1, lat2, lon2));
    }
  }
  return distances;
}

hubenyCalculate(List<List<double>> newCoordinat, List<String> lokasi) {
  List<List<double>> distanceCo = hubenyDistance(newCoordinat);
  List dataJarak = antColony(lokasi, distanceCo);
  List<String> getLokasi = [];
  for (int i in dataJarak[0]) {
    getLokasi.add(lokasi[i]);
  }
  return [distanceCo, getLokasi, dataJarak[1], dataJarak[0]];
}
