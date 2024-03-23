import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rumkit/model/koordinat.dart';
import 'package:rumkit/useable_widget/color.dart';
import 'package:rumkit/useable_widget/message.dart';
import 'package:rumkit/view_model/map/map_bloc.dart';
import 'package:rumkit/view_model/myloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GoogleMapController _controller;

  final CameraPosition _mapInitialPosition = const CameraPosition(
    target: LatLng(5.191858, 97.117187),
    zoom: 12.0,
  );

  String dropdownvalue = 'Hubeny';

  // List of items in our dropdown menu
  var items = ['Hubeny', 'Vincenty', 'Google Map'];

  @override
  Widget build(BuildContext context) {
    final m2 = Provider.of<LocProvider>(context);
    final size = MediaQuery.of(context).size;

    return m2.time == true && m2.lines.isEmpty
        ? const Loading()
        : BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              return Scaffold(
                body: SafeArea(
                  child: GoogleMap(
                    polylines: <Polyline>{
                      Polyline(
                        polylineId: const PolylineId('Route'),
                        points: m2.lines.isEmpty ? [] : m2.lines[m2.street],
                        color: blue,
                        width: 4,
                      ),
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    mapType: state.mapT ? MapType.hybrid : MapType.normal,
                    initialCameraPosition: _mapInitialPosition,
                    onMapCreated: (value) => _controller = value,
                    markers: <Marker>{
                      if (m2.marker != null) m2.marker!,
                      for (int i = 0; i < datakoordinat.length; i++)
                        Marker(
                          markerId: MarkerId('Rumah Sakit $i'),
                          position: LatLng(
                            datakoordinat[i].lat,
                            datakoordinat[i].lon,
                          ),
                          infoWindow: InfoWindow(
                            title: 'Rumah Sakit ${datakoordinat[i].name}',
                          ),
                        ),
                    },
                  ),
                ),
                floatingActionButton: Padding(
                  padding: EdgeInsets.only(left: size.width * 0.08),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(top: 80),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.amberAccent,
                        ),
                        child: DropdownButton(
                          style: TextStyle(color: black, fontSize: 13),
                          value: dropdownvalue,
                          dropdownColor: Colors.amber,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              m2.direct = false;
                              m2.change();
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          m2.direct
                              ? calculation(context, size, dropdownvalue)
                              : const SizedBox(),
                          Wrap(
                            spacing: size.height * 0.015,
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            children: [
                              state.but
                                  ? Wrap(
                                      direction: Axis.vertical,
                                      alignment: WrapAlignment.end,
                                      spacing: size.height * 0.015,
                                      children: [
                                        m2.direct
                                            ? hospitalWidget(m2)
                                            : const SizedBox(),
                                        mapType(state, context),
                                        directWidget(m2, dropdownvalue),
                                      ],
                                    )
                                  : const SizedBox(),
                              Wrap(
                                spacing: size.height * 0.015,
                                direction: Axis.vertical,
                                alignment: WrapAlignment.end,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  button(context, state),
                                  myLocWidget(m2),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  FloatingActionButton mapType(MapState state, BuildContext context) {
    return FloatingActionButton(
      backgroundColor: state.mapT ? green : greenAccent,
      onPressed: () => context.read<MapBloc>().add(ToggleMapTypeEvent()),
      child: Icon(
        color: white,
        size: 30,
        Icons.map,
      ),
    );
  }

  FloatingActionButton button(BuildContext context, MapState state) {
    return FloatingActionButton.small(
      backgroundColor: black,
      onPressed: () => context.read<MapBloc>().add(ToggleButtonEvent()),
      child: Icon(
        color: white,
        size: 20,
        state.but ? Icons.expand_more : Icons.expand_less,
      ),
    );
  }

  FloatingActionButton calculation(
      BuildContext context, Size size, String datas) {
    return FloatingActionButton(
      onPressed: () {
        showModal(context, size, datas);
      },
      child: const Icon(Icons.description),
    );
  }

  FloatingActionButton hospitalWidget(LocProvider a) {
    return FloatingActionButton(
      backgroundColor: blueGrey,
      onPressed: a.streetLine,
      child: Icon(
        color: white,
        size: 30,
        Icons.navigate_next,
      ),
    );
  }

  FloatingActionButton directWidget(LocProvider a, String b) {
    return FloatingActionButton(
      backgroundColor: a.direct ? white : blue,
      onPressed: () => a.directLines(b),
      child: Icon(
        color: a.direct ? blue : white,
        size: 30,
        Icons.directions,
      ),
    );
  }

  FloatingActionButton myLocWidget(LocProvider a) {
    return FloatingActionButton(
      backgroundColor: green,
      onPressed: () => a.moveCamera(context, _controller),
      child: Icon(
        color: white,
        size: 34,
        Icons.my_location_outlined,
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: green,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text('Sedang Memuat Data....')
            ],
          ),
        ),
      ),
    );
  }
}
