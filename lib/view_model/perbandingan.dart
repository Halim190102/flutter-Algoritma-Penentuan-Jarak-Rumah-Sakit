import 'package:flutter/material.dart';
import 'package:rumkit/algoritma/google_map.dart';
import 'package:rumkit/algoritma/hubeny.dart';
import 'package:rumkit/algoritma/vincenty.dart';
import 'package:rumkit/model/koordinat.dart';

class PersentaseProvider with ChangeNotifier {
  List<List<double>> newCoordinat = [];

  List<List<double>> hubenyvincenty = [];
  double? totalhubenyvincenty;

  List<List<double>> hubenygooglemap = [];
  double? totalhubenygooglemap;

  List<List<double>> vincentygooglemap = [];
  double? totalvincentygooglemap;

  List<int> timeHubenyList = [];
  List<int> timeVincentyList = [];

  datapersentase() async {
    for (int i = 0; i < datakoordinat.length; i++) {
      newCoordinat.add([datakoordinat[i].lat, datakoordinat[i].lon]);
    }
    timeHubeny();
    timeVincenty();

    List<List<double>> hubeny = await hubenyDistance(newCoordinat);
    List<List<double>> vincenty = await vincentyDistance(newCoordinat);
    List<List<double>> googlemap = await googleMapDistance(newCoordinat);

    hv(hubeny, vincenty);
    hg(hubeny, googlemap);
    vg(vincenty, googlemap);

    notifyListeners();
  }

  hv(List<List<double>> hubeny, List<List<double>> vincenty) {
    for (int i = 0; i < datakoordinat.length; i++) {
      List<double> row = [];
      for (int j = 0; j < datakoordinat.length; j++) {
        double difference = (hubeny[i][j] - vincenty[i][j]).abs();
        double percentage = (difference / vincenty[i][j]) * 100;
        if (percentage.isNaN) {
          percentage = 0.0;
        }
        row.add(percentage);
      }
      hubenyvincenty.add(row);
    }

    double sum = 0.0;
    int totalElements = 0;

    for (List<double> innerList in hubenyvincenty) {
      for (double value in innerList) {
        sum += value;
        totalElements++;
      }
    }
    totalhubenyvincenty = sum / totalElements;
    notifyListeners();
  }

  hg(List<List<double>> hubeny, List<List<double>> googlemap) {
    for (int i = 0; i < datakoordinat.length; i++) {
      List<double> row = [];
      for (int j = 0; j < datakoordinat.length; j++) {
        double difference = (hubeny[i][j] - googlemap[i][j]).abs();
        double percentage = (difference / googlemap[i][j]) * 100;
        if (percentage.isNaN) {
          percentage = 0.0;
        }
        row.add(percentage);
      }
      hubenygooglemap.add(row);
    }

    double sum = 0.0;
    int totalElements = 0;

    for (List<double> innerList in hubenygooglemap) {
      for (double value in innerList) {
        sum += value;
        totalElements++;
      }
    }
    totalhubenygooglemap = sum / totalElements;
    notifyListeners();
  }

  vg(List<List<double>> vincenty, List<List<double>> googlemap) {
    for (int i = 0; i < datakoordinat.length; i++) {
      List<double> row = [];
      for (int j = 0; j < datakoordinat.length; j++) {
        double difference = (vincenty[i][j] - googlemap[i][j]).abs();
        double percentage = (difference / googlemap[i][j]) * 100;
        if (percentage.isNaN) {
          percentage = 0.0;
        }
        row.add(percentage);
      }
      vincentygooglemap.add(row);
    }

    double sum = 0.0;
    int totalElements = 0;

    for (List<double> innerList in vincentygooglemap) {
      for (double value in innerList) {
        sum += value;
        totalElements++;
      }
    }
    totalvincentygooglemap = sum / totalElements;
    notifyListeners();
  }

  timeHubeny() {
    // print(vincenty(rsLocations));
    for (int i = 0; i < 11; i++) {
      Stopwatch stopwatch = Stopwatch()..start();
      hubenyDistance(newCoordinat);
      stopwatch.stop();
      timeHubenyList.add(stopwatch.elapsedMicroseconds);
      notifyListeners();
    }
  }

  timeVincenty() {
    for (int i = 0; i < 11; i++) {
      Stopwatch stopwatch = Stopwatch()..start();
      vincentyDistance(newCoordinat);
      stopwatch.stop();
      timeVincentyList.add(stopwatch.elapsedMicroseconds);
      notifyListeners();
    }
  }
}

class ChartData {
  final String jumlah;
  final int hasil;

  ChartData(
    this.hasil,
    this.jumlah,
  );
}
