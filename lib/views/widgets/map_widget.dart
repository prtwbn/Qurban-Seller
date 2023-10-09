import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qurban_seller/const/const.dart';
import 'package:qurban_seller/controllers/profile_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:qurban_seller/views/widgets/text_style.dart';
import 'package:geocoding/geocoding.dart';

class GoogleMapWidget extends StatefulWidget {
  final ProfileController controller;

  const GoogleMapWidget({required this.controller});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? mapController;
  final LatLng initialPosition = LatLng(-6.1754, 106.8272);
  LatLng? selectedPosition;
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission(); // Meminta izin akses lokasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: boldText(text: location, size: 16.0),
        ),
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 15,
              ),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
              onTap: (LatLng position) {
                setState(() {
                  selectedPosition = position;
                });
              },
              markers: Set<Marker>.from(
                [
                  Marker(
                    markerId: MarkerId('selected_marker'),
                    position: selectedPosition ?? initialPosition,
                    draggable: true,
                    onDragEnd: (LatLng newPosition) {
                      setState(() {
                        selectedPosition = newPosition;
                      });
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16.0,
              left: 10.0,
              right: 10.0,
              child: TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Masukkan Alamat',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _setCurrentLocationFromAddress(addressController.text);
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 10.0,
              right: 60.0,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedPosition != null) {
                    saveVendorLocation(selectedPosition!);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(46, 41, 78, 1),
                ),
                child: const Text('Save Location'),
              ),
            ),
          ],
        ));
  }

  void _requestLocationPermission() async {
    final permissionStatus = await Geolocator.requestPermission();
    if (permissionStatus == LocationPermission.denied ||
        permissionStatus == LocationPermission.deniedForever) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Izin Lokasi Ditolak'),
          content: Text(
              'Maaf, Anda harus mengizinkan akses lokasi untuk menggunakan fitur ini.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      _getCurrentLocation();
    }
  }

  void _getCurrentLocation() async {
    final position = await widget.controller.getCurrentLocation();
    setState(() {
      selectedPosition = position;
    });

    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: selectedPosition!,
            zoom: 15,
          ),
        ),
      );
    }
  }

  void _setCurrentLocationFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations != null && locations.isNotEmpty) {
        final location = locations.first;
        setState(() {
          selectedPosition = LatLng(location.latitude, location.longitude);
        });

        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: selectedPosition!,
                zoom: 15,
              ),
            ),
          );
        }
      }
    } catch (e) {
      print("Error finding location from address: $e");
    }
  }

  void saveVendorLocation(LatLng position) {
    widget.controller.saveVendorLocation(position);
    Navigator.pop(context);
  }
}
