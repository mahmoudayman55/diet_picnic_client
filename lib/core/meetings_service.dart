import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/models/meeting_model.dart';

class MeetingsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MeetingModel>> getAllMeetings() async {
    final snapshot = await _firestore.collection('meetings').get();

    final meetings = snapshot.docs
        .map((doc) => MeetingModel.fromJson(doc.data(), doc.id))
        .toList();

    // Sort ascending by date then time
    meetings.sort((a, b) {
      final dateCompare = a.date.compareTo(b.date);
      if (dateCompare != 0) return dateCompare;
      return a.time.compareTo(b.time);
    });

    return meetings;
  }
}
