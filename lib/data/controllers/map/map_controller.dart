import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:adventurous_learner_app/utils/common.dart';
import 'package:adventurous_learner_app/utils/constants.dart';
import 'package:adventurous_learner_app/utils/const_color.dart';
import 'package:adventurous_learner_app/data/google_map/google_map_utils.dart';
import 'package:adventurous_learner_app/screens/place_detail/place_detail_screen.dart';
import 'package:adventurous_learner_app/data/modals/map/place_detail_response.dart';
import 'package:adventurous_learner_app/data/modals/map/location_detail_response.dart';
import 'package:adventurous_learner_app/data/controllers/map/location_detail_controller.dart';

class MapController extends GetxController {
  GoogleMapController? mapController;
  PlaceDetailResponse? currentLocationDetails;

  Set<Marker> mapMarker = {};
  Set<Circle> circlesSet = {};

  String? get currentAddress =>
      currentLocationDetails?.result?.formattedAddress;

  double? get currentLatitude =>
      currentLocationDetails?.result?.geometry?.location?.lat;

  double? get currentLongitude =>
      currentLocationDetails?.result?.geometry?.location?.lng;

  var currentCameraPos = const CameraPosition(
    target: LatLng(defaultLatitude, defaultLongitude),
    zoom: defaultMapZoomValue,
  );

  @override
  onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => moveMarkerToCurrentLocation(),
    );
  }

  moveMarkerToCurrentLocation() async {
    await GoogleMapsUtils.askLocationPermission;

    if (await GoogleMapsUtils.isLocationDeniedForever) {
      showSnackBar(constCtr.strings.allowLocation, isError: true);
      return;
    }

    final currentPosition = await GoogleMapsUtils.location.getLocation();

    // _moveCameraToLocation(currentPosition.latitude, currentPosition.longitude);
    _moveCameraToLocation(defaultLatitude, defaultLongitude);

    addCircleToCurrentLocation();

    Get.put(LocationDetailController()).fetchLocationDetails(
      // currentPosition.latitude ?? defaultLatitude,
      // currentPosition.longitude ?? defaultLongitude,
      defaultLatitude,
      defaultLongitude,
    );
  }

  _moveCameraToLocation(double? latitude, double? longitude) {
    if (latitude == null || longitude == null) return;
    currentCameraPos = CameraPosition(
      target: LatLng(
        latitude,
        longitude,
      ),
      zoom: defaultMapZoomValue,
    );
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(currentCameraPos),
    );
  }

  addMarkerForAllLocation(List<LocationDetail> locationDetails) async {
    if (locationDetails.isEmpty) return;

    int index = 0;
    mapMarker.clear();

    mapMarker.add(Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(88),
      markerId: MarkerId(DateTime.now().toString()),
      position: const LatLng(
        // currentPosition.latitude ?? defaultLatitude,
        // currentPosition.longitude ?? defaultLongitude,
        defaultLatitude,
        defaultLongitude,
      ),
      infoWindow: const InfoWindow(title: 'You'),
    ));

    for (var element in locationDetails) {
      mapMarker.add(Marker(
        markerId: MarkerId(DateTime.now().toString()),
        position: LatLng(
          element.location?.coordinates?[1] ?? defaultLatitude,
          element.location?.coordinates?[0] ?? defaultLongitude,
        ),
        infoWindow: InfoWindow(
          title: element.name,
          onTap: () {
            Get.to(
              () => PlaceDetailScreen(
                location: element,
                index: index,
              ),
              transition: Transition.downToUp,
            );
          },
        ),
      ));
      index++;
    }
    update();
  }

  addCircleToCurrentLocation() {
    circlesSet.add(
      Circle(
        circleId: CircleId(DateTime.now().toString()),
        fillColor: greenColor3.withOpacity(0.25),
        center: const LatLng(
          // currentPosition.latitude ?? defaultLatitude,
          // currentPosition.longitude ?? defaultLongitude,
          defaultLatitude,
          defaultLongitude,
        ),
        radius: 120,
        strokeColor: greenColor3,
        strokeWidth: 2,
      ),
    );
    update();
  }
}
