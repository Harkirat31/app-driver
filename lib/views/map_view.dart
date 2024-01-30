import 'package:drivers/model/driver_company.dart';
import 'package:drivers/model/order.dart';
import 'package:drivers/model/path.dart' as PathModel;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PathMapView extends StatelessWidget {
  PathMapView({super.key});

  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> argumentMap =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    DriverCompany company = argumentMap['company'] as DriverCompany;
    PathModel.Path path = argumentMap['path'] as PathModel.Path;

    Set<Marker> markers = {};
    markers.add(Marker(
        markerId: MarkerId(company.name),
        position: LatLng(
            company.companyLocation!.lat, company.companyLocation!.lng)));

    for (int i = 0; i < path.path!.length; i++) {
      Order order = path.path![i];
      markers.add(Marker(
          markerId: MarkerId("Order ${i + 1}"),
          position: LatLng(order.location!.lat, order.location!.lng)));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map View"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(
              company.companyLocation!.lat, company.companyLocation!.lng),
          zoom: 10.0,
        ),
        markers: markers,
      ),
    );
  }
}
