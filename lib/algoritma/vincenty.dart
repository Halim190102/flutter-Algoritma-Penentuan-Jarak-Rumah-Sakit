import 'dart:math';
import 'package:rumkit/algoritma/ant_colony.dart';
import 'package:vector_math/vector_math.dart';

const a = 6378137; //Jari-jari khatulistiwa
const b = 6356752.3142; //Jari-jari kutub bumi

vincenty(double lat1, double lon1, double lat2, double lon2) {
  const f = 1 / 298.257223563;
  final l = radians(lon2 - lon1);

  final u1 = atan((1 - f) * tan(radians(lat1)));
  final u2 = atan((1 - f) * tan(radians(lat2)));
  final sinU1 = sin(u1), cosU1 = cos(u1);
  final sinU2 = sin(u2), cosU2 = cos(u2);

  double lambda = l,
      iter = 0,
      cosSqAlpha,
      lambdaP,
      sinSigma,
      cos2SigmaM,
      cosSigma,
      sigma;

  do {
    double sinLambda = sin(lambda);
    double cosLambda = cos(lambda);
    sinSigma = sqrt(pow(cosU2 * sinLambda, 2) +
        pow(cosU1 * sinU2 - sinU1 * cosU2 * cosLambda, 2));
    cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
    sigma = atan(sinSigma / cosSigma);
    double sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
    cosSqAlpha = 1 - sinAlpha * sinAlpha;
    cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;
    double c = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
    lambdaP = lambda;
    lambda = l +
        (1 - c) *
            f *
            sinAlpha *
            (sigma +
                c *
                    sinSigma *
                    (cos2SigmaM +
                        c * cosSigma * (-1 + 2 * pow(cos2SigmaM, 2))));
    iter++;
  } while ((lambda - lambdaP).abs() > 1e-12 && iter < 100);

  if (iter == 0) return 0;

  final uSq = cosSqAlpha * (a * a - b * b) / (b * b);
  final a1 = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
  final b1 = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
  final deltaSigma = b1 *
      sinSigma *
      (cos2SigmaM +
          b1 /
              4 *
              (cosSigma * (-1 + 2 * pow(cos2SigmaM, 2)) -
                  (b1 / 6) *
                      cos2SigmaM *
                      (-3 + 4 * pow(sinSigma, 2)) *
                      (-3 + 4 * pow(cos2SigmaM, 2))));
  final s = b * a1 * (sigma - deltaSigma);
  return s;
}

List<List<double>> vincentyDistance(List<List<double>> coordinates) {
  final List<List<double>> distances = [];

  for (int i = 0; i < coordinates.length; i++) {
    distances.add([]);
    for (int j = 0; j < coordinates.length; j++) {
      double lat1 = coordinates[i][0];
      double lon1 = coordinates[i][1];
      double lat2 = coordinates[j][0];
      double lon2 = coordinates[j][1];
      distances[i].add(vincenty(lat1, lon1, lat2, lon2));
    }
  }
  for (int i = 0; i < distances.length; i++) {
    for (int j = 0; j < distances[i].length; j++) {
      if (distances[i][j].isNaN) {
        distances[i][j] = 0.0;
      }
    }
  }
  return distances;
}

vincentyCalculate(List<List<double>> newCoordinat, List<String> lokasi) {
  List<List<double>> distanceCo = vincentyDistance(newCoordinat);
  List dataJarak = antColony(lokasi, distanceCo);
  List<String> getLokasi = [];
  for (int i in dataJarak[0]) {
    getLokasi.add(lokasi[i]);
  }
  return [distanceCo, getLokasi, dataJarak[1], dataJarak[0]];
}
