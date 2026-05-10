import 'dart:developer';

import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/models/OnBoarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
      title: "مرحباً بك في دايت بيكنيك",
      content: "نقدم لك أفضل الأنظمة الغذائية والرياضية المصممة خصيصاً لك.",
      img: 'assets/images/diet.png',
    ),
    OnBoarding(
      id: 1,
      title: "أنظمة رياضية مخصصة",
      content: "مجموعة متنوعة من التمارين الرياضية لمساعدتك على تحقيق أهدافك.",
      img: 'assets/images/workout.png',
    ),
    OnBoarding(
      id: 2,
      title: "متابعة مستمرة وتقييم",
      content:
          "سجل وزنك وقياساتك بانتظام وتواصل مع أطبائنا للحصول على استشارات مستمرة.",
      img: 'assets/images/tracking.png',
    ),
    OnBoarding(
      id: 3,
      title: "مسابقات وجوائز",
      content:
          "مسابقات دايت بيكنيك لا تنتهي, شارك وأربح اقوى العروض والخصومات!",
      img: 'assets/animation/tr.png',
    ),
    OnBoarding(
      id: 4,
      title: "دايت بيكنيك",
      content:
          "دايت بيكنيك هو خيارك الأمثل لحياة صحية ومتوازنة، مع نخبة من أفضل الأطباء والمتخصصين في التغذية.",
      img: 'assets/images/logob.png',
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
    final getStorage = GetStorage();
    await getStorage.write('hasSeenOnboarding', true);
  }

  /// Navigate to the login screen.
  void submit(BuildContext context) async {
    saveOnBoardingStatus();
    Get.offAllNamed(AppConstants.navigatorPage);
  }

  @override
  void onInit() {
    getOnBoardsData();
    super.onInit();
  }
}
