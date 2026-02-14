import 'dart:developer';

import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/models/OnBoarding.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


/// Controller for managing onBoarding screens.
class OnBoardingController extends GetxController {
  // Controller for managing the page view.
  PageController pageController = PageController();

  // Current page index in the onBoarding screens.
  int currentPage = 0;

  /// Navigate to the next onBoarding screen.
  void nextPage() {
    currentPage++;
    pageController.nextPage(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
    update();
  }

  /// List of onBoarding screens with title, content, and image.
  List<OnBoarding> onBoards = [
    OnBoarding(
      id: 0,
      title: "Welcome to ClickBooking",
      content: "Exceptional service at unbeatable prices!",
      img: 'assets/img/Clicbookingsquarelogo.png',
    ),
    OnBoarding(
      id: 0,
      title: "Find and Book",
      content:
          "Explore a variety of nearby hotels. Sign in or create an account to access a diverse selection tailored to your preferences. Easily find and book the perfect stay for your travels with clickBooking.",
      img: 'assets/animations/book.json',
    ),
    OnBoarding(
      id: 0,
      title: "Find Your Dream Home",
      content:
          "Explore diverse homes on clickBooking, from cozy apartments to charming villas. Find your dream living space effortlessly with us.",
      img: 'assets/animations/home.json',
    ),
  ];

  // Loading state indicator.
  bool loading = false;

  // Network error indicator.
  bool networkError = false;

  /// Update the current page index.
  void updateCurrentPage(int page) {
    currentPage = page;
    log(currentPage.toString());
    log(onBoards.length.toString());
    pageController.jumpToPage(page);
    update();
  }

  /// Fetch onBoarding data from a remote data source.
  Future<void> getOnBoardsData() async {
    // Uncomment the following lines to fetch onboarding data from a remote source.
    // BaseAppInitRemoteDataSource appInitRemoteDataSource = AppInitRemoteDataSource();
    // BaseAppInitLocalDataSource appInitLocalDataSource = AppInitLocalDataSource();
    // BaseAppInitRepository appInitRepository =
    //     AppInitRepository(appInitRemoteDataSource, appInitLocalDataSource);
    // final Either<ErrorMessageModel, List<OnBoarding>> onBoardings =
    //     await GetOnBoardsUseCase(appInitRepository).execute();
    // onBoardings.fold(
    //   (l) {
    //     loading = false;
    //     networkError = true;
    //     update();
    //   },
    //   (r) {
    //     log((r).toString());
    //     onBoards = r;
    //     loading = false;
    //     networkError = false;
    //     update();
    //   },
    // );
  }

  saveOnBoardingStatus() async {

  }

  /// Navigate to the login screen.
  void submit(BuildContext context) async {
    // final permissionGranted = await requestLocationPermission();
    //
    // if (!permissionGranted) {
    //   LocationPermission permission = await Geolocator.checkPermission();
    //   if (permission == LocationPermission.deniedForever) {
    //     await showDialog(
    //       context: context,
    //       builder: (c) {
    //         return IntrinsicHeight(
    //           child: AlertDialog(
    //             title: Text(
    //               "Permission Required",
    //               style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.black),
    //             ),scrollable: true,
    //             content: Center(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Padding(
    //                     padding: const EdgeInsets.all(20),
    //                     child: Text(
    //                       "Location permission denied, please open app settings and allow location permission.",
    //                       style: Theme.of(context).textTheme.bodyMedium,
    //                       textAlign: TextAlign.center,
    //                     ),
    //                   ),
    //                   IconButton(
    //                     onPressed: () async {
    //                       await openAppSettings();
    //                     },
    //                     icon: Icon(
    //                       Icons.settings,
    //                       color: CustomColors.darkGreen,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             actions: [
    //               TextButton(
    //                 onPressed: () {
    //                   Get.back();
    //                 },
    //                 child: Text("Cancel",style: Theme.of(context).textTheme.displaySmall!.copyWith(color: Colors.red),),
    //               ),
    //             ],
    //           ),
    //         );
    //       },
    //     );
    //   } else {
    //     Get.snackbar(
    //       "Permission Required",
    //       "Location permission is required to proceed.",
    //       snackPosition: SnackPosition.BOTTOM,
    //     );
    //   }
    //   return;
    // }

    await showDialog(
      context: context,
      builder: (c) {
        return AlertDialog(
          title: Text(
            "Privacy Policies",
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(color: Colors.black),
          ),
          scrollable: true,
          content: Container(
            child: SelectableText.rich(
              TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black),
                children: [
                  TextSpan(text: 'By clicking continue, you agree to our '),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        CustomUrlLauncher.launchWebUrl(AppConstants.privacyURL);
                      },
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline),
                    text: 'Privacy Policy & Terms And Conditions',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            GetBuilder<OnBoardingController>(builder: (c) {
              return TextButton(
                onPressed: loading
                    ? null
                    : () async {
                        loading = true;
                        c.update();
                        saveOnBoardingStatus();
                        Get.offAllNamed(AppConstants.navigatorPage);
                        loading = false;
                        c.update();
                      },
                child: Text(
                  loading ? "Loading..." : "Continue",
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(color: CustomColors.selectedNavBarColor),
                ),
              );
            })
          ],
        );
      },
    );

    loading = false;
    update();
  }



  @override
  void onInit() {
    getOnBoardsData();
    super.onInit();
  }
}
