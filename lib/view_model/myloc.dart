import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rumkit/algoritma/google_map.dart';
import 'package:rumkit/algoritma/hubeny.dart';
import 'package:rumkit/algoritma/vincenty.dart';
import 'package:rumkit/model/koordinat.dart';
import 'package:rumkit/useable_widget/handler_permission.dart';

class LocProvider with ChangeNotifier {
  bool time = false;
  Marker? marker;
  int street = 0;
  bool text = false;
  bool direct = false;

  List<List<LatLng>> lines = [];

  List<String> lokasi = [];

  List<String> newLokasi = [];

  List<List<double>> data = [];

  double jarak = 0.0;

  LatLng? myCurrent;

  void textButton() {
    text = !text;
    notifyListeners();
  }

  Future<List<List<double>>> newdata() async {
    List<List<double>> newCoordinat = [];

    for (int i = 0; i < datakoordinat.length; i++) {
      newCoordinat.add([datakoordinat[i].lat, datakoordinat[i].lon]);
      lokasi.add(datakoordinat[i].name);
    }
    if (myCurrent != null) {
      newCoordinat.insert(0, [myCurrent!.latitude, myCurrent!.longitude]);
      lokasi.insert(0, 'Lokasi Saya');
    }
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      myCurrent = null;
      bool myBoolean = lokasi.any((element) => element.contains('Lokasi Saya'));
      if (myBoolean) {
        lokasi.removeAt(0);
        newCoordinat.removeAt(0);
      }
    }
    return newCoordinat;
  }

  void getData(List al, List<List<double>> newCoordinat) async {
    data.addAll(al[0]);

    newLokasi.addAll(al[1]);

    jarak = al[2];

    List<List<double>> newList = [];
    for (int i in al[3]) {
      newList.add(newCoordinat[i]);
    }
    int i = 0;
    do {
      List<LatLng> polylineCoordinates = [];

      PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        'AIzaSyBuPIfRdEYytBK14tIFaDq1cBPZEHj9kQw',
        PointLatLng(newList[i][0], newList[i][1]),
        PointLatLng(newList[i + 1][0], newList[i + 1][1]),
        travelMode: TravelMode.driving,
      );
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      lines.add(polylineCoordinates);
      notifyListeners();

      i++;
    } while (i < newCoordinat.length - 1);
    time = false;
    notifyListeners();
  }

  algoritmaGoogleMap() async {
    List<List<double>> newCoordinat = await newdata();

    List googlemapData = await googleMapCalculate(newCoordinat, lokasi);

    getData(googlemapData, newCoordinat);
    notifyListeners();
  }

  algoritmaVincenty() async {
    List<List<double>> newCoordinat = await newdata();

    List vincentyData = vincentyCalculate(newCoordinat, lokasi);

    getData(vincentyData, newCoordinat);
    notifyListeners();
  }

  algoritmaHubeny() async {
    List<List<double>> newCoordinat = await newdata();

    List hubenyData = hubenyCalculate(newCoordinat, lokasi);
    getData(hubenyData, newCoordinat);
    notifyListeners();
  }

  void streetLine() {
    if (street == lines.length - 1) {
      street = -1;
      notifyListeners();
    }
    street += 1;
    notifyListeners();
  }

  void directLines(String a) {
    direct = !direct;
    time = true;
    if (direct) {
      switch (a) {
        case 'Hubeny':
          algoritmaHubeny();
          break;
        case 'Vincenty':
          algoritmaVincenty();
          break;
        case 'Google Map':
          algoritmaGoogleMap();
          break;
      }
    } else {
      change();
    }
    notifyListeners();
  }

  moveCamera(BuildContext c1, GoogleMapController c2) async {
    final data = await handleLocationPermission(c1);
    if (!data) return;
    Position position = await Geolocator.getCurrentPosition();
    c2.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 14,
        ),
      ),
    );

    marker = Marker(
      markerId: const MarkerId('Lokasi Pengguna'),
      position: LatLng(position.latitude, position.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
    );
    myCurrent = LatLng(position.latitude, position.longitude);
    direct = false;
    change();
    notifyListeners();
  }

  void change() {
    time = false;
    street = 0;
    lines = [];
    data = [];
    newLokasi = [];
    lokasi = [];
    jarak = 0.0;
    notifyListeners();
  }
}
