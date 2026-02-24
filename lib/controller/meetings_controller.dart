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

  /// All meetings that haven't expired yet (running or upcoming)
  List<MeetingModel> get upcomingMeetings =>
      meetings.where((m) => !m.hasExpired).toList();

  /// All meetings that have expired (past)
  List<MeetingModel> get pastMeetings =>
      meetings.where((m) => m.hasExpired).toList();

  /// The very next available meeting (running or upcoming)
  MeetingModel? get nextMeeting =>
      meetings.firstWhereOrNull((m) => !m.hasExpired);

  Future<void> fetchMeetings() async {
    try {
      isLoading.value = true;
      final result = await _service.getAllMeetings();

      meetings.assignAll(result);
    } catch (e) {
      log('MeetingsController: error fetching meetings: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
