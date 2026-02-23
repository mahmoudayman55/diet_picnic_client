import 'dart:developer';

import 'package:diet_picnic_client/core/meetings_service.dart';
import 'package:diet_picnic_client/models/meeting_model.dart';
import 'package:get/get.dart';

class MeetingsController extends GetxController {
  static MeetingsController get to => Get.find();

  final _service = MeetingsService();

  final RxList<MeetingModel> meetings = <MeetingModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMeetings();
  }

  /// All meetings where date >= today (upcoming)
  List<MeetingModel> get upcomingMeetings =>
      meetings.where((m) => m.isUpcoming).toList();

  /// All meetings where date < today (past)
  List<MeetingModel> get pastMeetings =>
      meetings.where((m) => m.isPast).toList();

  /// The very next upcoming meeting (closest date)
  MeetingModel? get nextMeeting =>
      upcomingMeetings.isNotEmpty ? upcomingMeetings.first : null;

  Future<void> fetchMeetings() async {
    try {
      isLoading.value = true;
      final result = await _service.getAllMeetings();
      log("message");


      meetings.assignAll(result);
      log(meetings.first.time.toString());
     log( meetings.length.toString());
      log(meetings.first.date.toString());
    } catch (e) {
      log('MeetingsController: error fetching meetings: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
