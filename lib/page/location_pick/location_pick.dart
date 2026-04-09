import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salon/api/dio_client.dart';
import 'package:salon/constant/color_constant.dart';
import 'package:salon/controller/auth_controller.dart';
import 'package:salon/project_specific/progressbar_view.dart';
import 'package:salon/project_specific/project_appbar.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart' as fp;

class LocationPickPage extends StatefulWidget {
  final VoidCallback callback;

  const LocationPickPage({super.key, required this.callback});

  @override
  State<LocationPickPage> createState() => _LocationPickPageState();
}

class _LocationPickPageState extends State<LocationPickPage> {
  GoogleMapController? _controller;
  LatLng _initialPosition = const LatLng(0.0, 0.0);
  bool _locationLoaded = false;
  final List<Marker> _marker = <Marker>[];
  final _authController = Get.find<AuthController>();
  final _searchMapLocation = TextEditingController();
  ValueNotifier<bool> close = ValueNotifier(false);

  final places =
      fp.FlutterGooglePlacesSdk('AIzaSyATecmTI6WWH24gR6wCR4IooVH77VCnSgc');
  ValueNotifier<List<fp.AutocompletePrediction>> locationData =
      ValueNotifier([]);

  String address = "";
  double lat = 0.0;
  double lng = 0.0;

  @override
  void initState() {
    super.initState();
    _setInitialLocation();
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
          actions: [
            IconButton(
              onPressed: () {
                _authController.salonAddressLan = lng;
                _authController.salonAddressLat = lat;
                _authController.salonCurrentAddress = address;
                Navigator.pop(context);
                widget.callback.call();
                print(address);
                print(lat.toString());
                print(lng.toString());
              },
              icon: const Icon(
                Icons.check_circle,
                color: ColorConstant.blackColor,
              ),
            ),
          ],
          nameOfScreen: "Pick Your Location",
          isBackIcon: true,
        ),
        body: _locationLoaded
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 14.0,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller = controller;
                    },
                    onTap: (latLng) async {
                      _marker.clear();
                      List<Placemark> placeMarks =
                          await placemarkFromCoordinates(
                              latLng.latitude, latLng.longitude);
                      Placemark place = placeMarks[0];
                      _marker.add(Marker(
                        markerId: const MarkerId('current_Postion23'),
                        position: LatLng(latLng.latitude, latLng.longitude),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueViolet,
                        ),
                      ));

                      lng = latLng.longitude;
                      lat = latLng.latitude;
                      address =
                          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
                      setState(() {});
                    },
                    markers: Set<Marker>.of(
                      _marker,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                  Positioned(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: ColorConstant.whiteColor,
                              borderRadius: BorderRadius.circular(5)),
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 80),
                          // height: 48,
                          child: TextField(
                            controller: _searchMapLocation,
                            style: Get.textTheme.bodyLarge
                                ?.copyWith(color: Colors.black),
                            onChanged: (val) async {
                              if (val != "") {
                                close.value = true;
                                close.notifyListeners();
                                final predictions = await places
                                    .findAutocompletePredictions(val);
                                locationData.value = predictions.predictions;
                              } else {
                                close.value = false;
                                close.notifyListeners();
                                locationData.value = [];
                              }
                              locationData.notifyListeners();
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(top: 13),
                                border: InputBorder.none,
                                hintText: "Search Location",
                                prefixIcon: const Icon(Icons.search,
                                    color: Colors.black, size: 20),
                                suffixIcon: ValueListenableBuilder(
                                    valueListenable: close,
                                    builder: (context, v, c) {
                                      return close.value
                                          ? InkWell(
                                              onTap: () {
                                                _marker.clear();
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                _searchMapLocation.clear();
                                                locationData.value = [];
                                                close.value = false;
                                                close.notifyListeners();

                                                setState(() {
                                                  _setInitialLocation();
                                                });
                                              },
                                              child: const Icon(
                                                CupertinoIcons.xmark_circle,
                                                color: Colors.black,
                                                size: 20,
                                              ),
                                            )
                                          : const SizedBox();
                                    })),
                          ),
                        ),
                        Container(
                          color: ColorConstant.whiteColor,
                          margin: const EdgeInsets.only(
                              left: 20, right: 20, top: 15),
                          child: ValueListenableBuilder(
                              valueListenable: locationData,
                              builder: (context, v, c) {
                                return locationData.value.isEmpty
                                    ? const SizedBox()
                                    : ListView.builder(
                                        itemCount: locationData.value.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              _searchMapLocation.text =
                                                  locationData
                                                      .value[index].fullText
                                                      .toString();
                                              locationData.value = [];
                                              _marker.clear();
                                              List<Location> location =
                                                  await locationFromAddress(
                                                      _searchMapLocation.text);
                                              if (location.isNotEmpty) {
                                                List<Placemark> placeMarks =
                                                    await placemarkFromCoordinates(
                                                        location[0].latitude,
                                                        location[0].longitude);
                                                Placemark place = placeMarks[0];

                                                setState(() {
                                                  _marker.add(Marker(
                                                    markerId: const MarkerId(
                                                        'current_Postion'),
                                                    position: LatLng(
                                                        location[0].latitude,
                                                        location[0].longitude),
                                                    icon: BitmapDescriptor
                                                        .defaultMarkerWithHue(
                                                      BitmapDescriptor
                                                          .hueViolet,
                                                    ),
                                                  ));
                                                });

                                                lng = location[0].longitude;
                                                lat = location[0].latitude;
                                                address =
                                                    _searchMapLocation.text;

                                                _marker.add(Marker(
                                                  markerId:
                                                      const MarkerId('new'),
                                                  position: LatLng(
                                                      location[0].latitude,
                                                      location[0].longitude),
                                                  icon: BitmapDescriptor
                                                      .defaultMarkerWithHue(
                                                    BitmapDescriptor.hueViolet,
                                                  ),
                                                ));

                                                setState(() {
                                                  _initialPosition = LatLng(
                                                      location[0].latitude,
                                                      location[0].longitude);
                                                  _controller?.animateCamera(
                                                      CameraUpdate.newLatLng(
                                                          LatLng(
                                                              location[0]
                                                                  .latitude,
                                                              location[0]
                                                                  .longitude)));
                                                });
                                              }
                                            },
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Column(
                                                children: [
                                                  index == 0
                                                      ? const SizedBox(
                                                          height: 10,
                                                        )
                                                      : const SizedBox(),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10,
                                                        vertical: 5),
                                                    child: SizedBox(
                                                      width: Get.width,
                                                      child: Text(
                                                          locationData
                                                              .value[index]
                                                              .fullText
                                                              .toString(),
                                                          style: Get.textTheme
                                                              .titleMedium
                                                              ?.copyWith(
                                                            color: ColorConstant
                                                                .blackColor,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          )),
                                                    ),
                                                  ),
                                                  index ==
                                                          locationData.value
                                                                  .length -
                                                              1
                                                      ? const SizedBox(
                                                          height: 10,
                                                        )
                                                      : const Divider(
                                                          color: ColorConstant
                                                              .blackColor,
                                                        )
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : const ProgressBarView(),
      ),
    );
  }

  /*----------------- Set  init  Location  -----------------*/
  Future<void> _setInitialLocation() async {
    await requestPermission();
    Position position = await getCurrentLocation();
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      _locationLoaded = true;
      _marker.add(Marker(
        markerId: const MarkerId('current_Postion'),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
        ),
      ));
    });
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placeMarks[0];
    lng = position.longitude;
    lat = position.latitude;
    address =
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
  }

  /*------------------- Location  Change Liston --------------------*/
  void _listenToLocationChanges() {
    Geolocator.getPositionStream().listen((Position position) {
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14.0,
          ),
        ),
      );
    });
  }

  /*---------------- Request  Permission  -----------------*/
  Future<void> requestPermission() async {
    var status = await Permission.location.request();
    if (status.isDenied) {
      await Permission.location.request();
    } else if (status.isPermanentlyDenied) {
      showMessage(
          "Location permissions are permanently denied, we cannot request permissions.");
    }
  }

  /*--------------  Get Current Location  -----------------*/
  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  bool _canPopNow = false;
  DateTime? _currentBackPressTime;

  /* ---------------  TapBack Button ---------------- */
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
