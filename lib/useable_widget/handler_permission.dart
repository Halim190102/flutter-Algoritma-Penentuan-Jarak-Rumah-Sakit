import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rumkit/useable_widget/color.dart';
import 'package:rumkit/useable_widget/message.dart';
import 'package:location/location.dart';

handleLocationPermission(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      if (context.mounted) {
        snackBar(
          const Text(
            'Location permissions are denied',
          ),
          context,
        );
      }

      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    if (context.mounted) {
      snackBar(
        Row(
          children: [
            const Flexible(
              child: Text(
                  'Location permissions are permanently denied, we cannot request permissions.'),
            ),
            TextButton(
              onPressed: () {
                Location().requestService();
                openAppSettings();
              },
              child: Text(
                'Open\nSetting',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: lightBlue,
                ),
              ),
            ),
          ],
        ),
        context,
      );
    }

    return false;
  }
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Location().requestService();
    return false;
  }
  return true;
}
