import 'package:diet_picnic_client/controller/all_reviews_controller.dart';
import 'package:diet_picnic_client/controller/app_update_controller.dart';
import 'package:diet_picnic_client/controller/books_controller.dart';
import 'package:diet_picnic_client/controller/change_password_controller.dart';
import 'package:diet_picnic_client/controller/diet_controller.dart';
import 'package:diet_picnic_client/controller/exercise_system_controller.dart';
import 'package:diet_picnic_client/controller/home_controller.dart';
import 'package:diet_picnic_client/controller/login_controller.dart';
import 'package:diet_picnic_client/controller/meetings_controller.dart';
import 'package:diet_picnic_client/controller/offer_details_controller.dart';
import 'package:diet_picnic_client/controller/offer_packages_controller.dart';
import 'package:diet_picnic_client/controller/on_boarding_controller.dart';
import 'package:diet_picnic_client/controller/package_details_controller.dart';
import 'package:diet_picnic_client/controller/register_controller.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/controller/videos_controller.dart';
import 'package:diet_picnic_client/controller/water_reminder_controller.dart';
import 'package:diet_picnic_client/controller/body_composition_controller.dart';
import 'package:diet_picnic_client/view/all_reviews_view.dart';
import 'package:diet_picnic_client/view/app_update_view.dart';
import 'package:diet_picnic_client/view/books_view.dart';
import 'package:diet_picnic_client/view/change_password_view.dart';
import 'package:diet_picnic_client/view/diet_view.dart';
import 'package:diet_picnic_client/view/exercise_system_view.dart';
import 'package:diet_picnic_client/view/login_view.dart';
import 'package:diet_picnic_client/view/meetings_view.dart';
import 'package:diet_picnic_client/view/navigator_view.dart';
import 'package:diet_picnic_client/view/offer_details_view.dart';
import 'package:diet_picnic_client/view/offer_packages_view.dart';
import 'package:diet_picnic_client/view/on_boarding/onboarding_view.dart';
import 'package:diet_picnic_client/view/package_details_view.dart';
import 'package:diet_picnic_client/view/register_view.dart';
import 'package:diet_picnic_client/view/videos_view.dart';
import 'package:diet_picnic_client/view/water_reminder_view.dart';
import 'package:diet_picnic_client/view/body_composition_view.dart';
import 'package:diet_picnic_client/modules/clients/data/repositories/firebase_exam_repository.dart';
import 'package:diet_picnic_client/modules/clients/presentation/controllers/exam_test_controller.dart';
import 'package:diet_picnic_client/modules/clients/presentation/controllers/exams_controller.dart';
import 'package:diet_picnic_client/modules/clients/presentation/views/exam_results_view.dart';
import 'package:diet_picnic_client/modules/clients/presentation/views/exam_test_view.dart';
import 'package:diet_picnic_client/modules/clients/presentation/views/exams_view.dart';
import 'package:get/get.dart';

import 'app_constants.dart';

class GetRoutes {
  static const home = '/home';

  static final pages = <GetPage>[
    GetPage(
      name: AppConstants.onBoarding,
      binding: BindingsBuilder(() {
        Get.put(OnBoardingController());
      }),
      page: () => OnBoardingView(),
    ),
    GetPage(
      name: AppConstants.loginPage,
      binding: BindingsBuilder(() {
        Get.put(UserController());

        Get.put(
          LoginController(),
        );
      }),
      page: () => LoginView(),
    ),
    GetPage(
      name: AppConstants.reviewsPage,
      binding: BindingsBuilder(() {
        Get.put(AllReviewsController());
      }),
      page: () => AllReviewsView(),
    ),
    GetPage(
      name: AppConstants.changePasswordPage,
      binding: BindingsBuilder(() {
        Get.put(ChangePasswordController());
      }),
      page: () => ChangePasswordView(),
    ),
    GetPage(
      name: AppConstants.videosPage,
      binding: BindingsBuilder(() {
        Get.put(VideosController());
      }),
      page: () => VideosView(),
    ),
    GetPage(
      name: AppConstants.booksPage,
      binding: BindingsBuilder(() {
        Get.put(BooksController());
      }),
      page: () => BooksView(),
    ),
    GetPage(
      name: AppConstants.updatePage,
      binding: BindingsBuilder(() {
        Get.put(AppUpdateController(), permanent: true);
      }),
      page: () => AppUpdateView(),
    ),
    GetPage(
      name: AppConstants.registerPage,
      binding: BindingsBuilder(() {
        Get.put(
          RegisterController(),
        );
      }),
      page: () => RegisterView(),
    ),
    GetPage(
      name: AppConstants.navigatorPage,
      binding: BindingsBuilder(() {
        Get.put(HomeController());
        Get.put(MeetingsController());
      }),
      page: () => NavigatorView(),
    ),
    GetPage(
      name: AppConstants.meetingsPage,
      binding: BindingsBuilder(() {
        // MeetingsController is already put by the navigator binding
        // This ensures it's available if navigated directly
        if (!Get.isRegistered<MeetingsController>()) {
          Get.put(MeetingsController());
        }
      }),
      page: () => const MeetingsView(),
    ),
    GetPage(
      name: AppConstants.packageDetailsPage,
      binding: BindingsBuilder(() {
        Get.put(
          PackageDetailsController(),
        );
      }),
      page: () => PackageDetailsView(),
    ),
    GetPage(
      name: AppConstants.offerPackagesPage,
      binding: BindingsBuilder(() {
        Get.put(
          OfferPackagesController(),
        );
      }),
      page: () => OfferPackagesView(),
    ),
    GetPage(
      name: AppConstants.offersDetailsPage,
      binding: BindingsBuilder(() {
        Get.put(
          OfferDetailsController(),
        );
      }),
      page: () => OfferDetailsView(),
    ),
    GetPage(
        name: AppConstants.dietPage,
        binding: BindingsBuilder(() {
          Get.put(
            DietController(),
          );
        }),
        page: () => DietView()),
    GetPage(
        name: AppConstants.exerciseSystemsPage,
        binding: BindingsBuilder(() {
          Get.put(
            ExerciseSystemController(),
          );
        }),
        page: () => ExerciseSystemView(),
        arguments: true),
    GetPage(
      name: AppConstants.waterReminderPage,
      binding: BindingsBuilder(() {
        Get.put(WaterReminderController());
      }),
      page: () => const WaterReminderView(),
    ),
    GetPage(
      name: AppConstants.bodyCompositionPage,
      binding: BindingsBuilder(() {
        Get.put(BodyCompositionController());
      }),
      page: () => const BodyCompositionView(),
    ),
    GetPage(
      name: AppConstants.examsPage,
      binding: BindingsBuilder(() {
        Get.lazyPut(() => FirebaseExamRepository());
        Get.put(ExamsController(Get.find<FirebaseExamRepository>()));
      }),
      page: () => const ExamsView(),
    ),
    GetPage(
      name: AppConstants.examTestPage,
      binding: BindingsBuilder(() {
        final exam = Get.arguments;
        Get.lazyPut(() => FirebaseExamRepository());
        Get.put(ExamTestController(Get.find<FirebaseExamRepository>(), exam));
      }),
      page: () => const ExamTestView(),
    ),
    GetPage(
      name: AppConstants.examResultsPage,
      page: () => const ExamResultsView(),
    ),
  ];
}
