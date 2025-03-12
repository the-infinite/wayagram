import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/theme/extension/text_theme_extension.dart';
import 'package:wayagram/core/theme/extension/textstyle_extension.dart';
import 'package:wayagram/core/theme/theme.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/quotation/buyer/vm/create_request_vm.dart';

class MapScreen extends ConsumerStatefulWidget {
  static const route = '/map';
  const MapScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final _controller = Completer<GoogleMapController>();

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      //target: LatLng(6.4571958, 3.292185),
      target: LatLng(6.4478, 3.4723),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final Set<Marker> _marker = {};
  final _list = const <Marker>[
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(6.4478, 3.4723),
      infoWindow: InfoWindow(
        title: 'My Position',
      ),
    ),
    Marker(
      markerId: MarkerId('2'),
      position: LatLng(6.4478, 3.4723),
      infoWindow: InfoWindow(
        title: 'Location 1',
      ),
    ),
    Marker(
      markerId: MarkerId('3'),
      position: LatLng(6.4478, 3.4723),
      infoWindow: InfoWindow(
        title: 'Location 2',
      ),
    ),
  ];

  @override
  void initState() {
    _marker.addAll(_list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(createRequestProvider);
    final wayaTheme = Theme.of(context);

    //? This is even better.
    return WayaScaffold(
      isScrollable: false,
      isLoading: false,
      body: Stack(
        children: [
          //? At the bottom, the google map.
          GoogleMap(
            initialCameraPosition: _kLake,
            mapType: MapType.normal,
            myLocationEnabled: true,
            compassEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (controller) {
              _controller.complete(controller);
            },
            myLocationButtonEnabled: true,
            minMaxZoomPreference: const MinMaxZoomPreference(3, 13),
          ),

          //? This is fine.
          Positioned(
            top: 130,
            bottom: 40,
            child: Padding(
              padding: EdgeInsets.only(top: 150.h, left: 20.w, right: 20.w),
              child: Row(
                children: [
                  Text(
                    "Bids Around You",
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => WayaNav.goBack(),
                    child: Image.asset(
                      'assets/images/bid/back-arrow.png',
                      height: 24,
                      width: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 340.h),
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              height: 420.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const Gap(10),
                  Text(
                    "Bids Around You",
                    style: TextStyle().wayaCopyWith(
                      color: wayaTheme.colorScheme.customBlack,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    "Explore open opportunities nearby and submit your best offers to get started",
                    style: TextStyle().wayaCopyWith(
                      color: WayaColors.greyColor500,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Gap(20),
                  //   SingleSeeBidWidget(
                  //     color: wayaTheme.colorScheme.scaffoldColor,
                  //   ),
                  //   SingleSeeBidWidget(
                  //     color: wayaTheme.colorScheme.scaffoldColor,
                  //   ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 630.h),
                  child: InkWell(
                      onTap: () => WayaNav.goBack(),
                      child: Image.asset(
                        'assets/images/bid/back-arrow.png',
                        height: 60.h,
                      )),
                ),
                Flexible(
                  child: FormField<String>(
                    validator: (value) {
                      return null;
                    },
                    builder: (formState) {
                      return WayaTextFormField(
                        keyboardType: TextInputType.text,
                        controller: viewModel.maxDistance,
                        hintText: 'Ikeja city, Lagos state',
                        borderColor: formState.hasError && viewModel.maxDistance.text.isEmpty
                            ? wayaTheme.colorScheme.error
                            : null,
                        label: '',
                        fillColor: Colors.white,
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            "Km",
                            style: wayaTheme.textTheme.hintStyle,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
