import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/project_specific/project_appbar.dart';

class LocationPickPage extends StatefulWidget {
  final VoidCallback callback;
  const LocationPickPage({super.key, required this.callback});

  @override
  State<LocationPickPage> createState() => _LocationPickPageState();
}

class _LocationPickPageState extends State<LocationPickPage> {
  late GoogleMapController mapController;
  LatLng? initialPosition;
  List<LatLng> postcodeLocations = [];
  final List<Marker> _marker = <Marker>[];
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    getCurrentLatLng();
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPopNow,
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          tapBackAgainToCloseApp();
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstant.bgColor,
        appBar: AppBarWidget(
          nameOfScreen: "Pick Your Location",
          isBackIcon: true,
          callback: widget.callback,
        ),
        body: GoogleMap(
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          tiltGesturesEnabled: true,
          onMapCreated: (controller) {
            setState(() {
              mapController = controller;
            });
            _moveToInitialPosition();
          },
          onTap: (latLng) async {
            List<Placemark> placeMarks = await placemarkFromCoordinates(
                latLng.latitude, latLng.longitude);
            Placemark place = placeMarks[0];
            _marker.add(Marker(
              markerId: const MarkerId('current_Postion'),
              position: LatLng(latLng.latitude, latLng.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet,
              ),
            ));

            setState(() {});

            _authController.salonAddressLan = latLng.longitude;
            _authController.salonAddressLat = latLng.latitude;
            _authController.salonCurrentAddress =
                "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
          },
          initialCameraPosition: CameraPosition(
            target: initialPosition ?? const LatLng(22.303894, 70.802162),
            zoom: 12.0,
          ),
          markers: Set<Marker>.of(
            _marker,
          ),
        ),
      ),
    );
  }

  /*---------  Move Camera For Google Map ----------*/
  void _moveToInitialPosition() {
    mapController.animateCamera(CameraUpdate.newLatLng(
        initialPosition ?? const LatLng(22.303894, 70.802162)));
  }

  /*========================= Current location lat lng ========================= */
  getCurrentLatLng() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission;
    if (!serviceEnabled) {
      Get.back();
      await Permission.location.request();
      showMessage("Location services are disabled.");
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.back();
        await Permission.location.request();
        showMessage("Location permissions are denied");
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.back();
      showMessage(
          "Location permissions are permanently denied, we cannot request permissions.");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    initialPosition = LatLng(position.latitude, position.latitude);
    _marker.add(Marker(
      markerId: const MarkerId('current_Postion'),
      position: LatLng(position.latitude, position.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueViolet,
      ),
    ));
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placeMarks[0];

    _authController.salonAddressLan = position.longitude;
    _authController.salonAddressLat = position.latitude;
    _authController.salonCurrentAddress =
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
  }

  bool _canPopNow = false;
  DateTime? _currentBackPressTime;

  /*---------------  TapBack Button ----------------*/
  void tapBackAgainToCloseApp() {
    DateTime now = DateTime.now();
    widget.callback();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 3)) {
      _currentBackPressTime = now;
      showMessage("Tap back again to close the app");
      setState(() {
        _canPopNow = true; // Temporarily let user exit app on the next back tap
      });
      Future.delayed(
        const Duration(seconds: 3),
        () {
          setState(() {
            _canPopNow = false;
            _currentBackPressTime = null;
          });
        },
      );
    }
  }
}
