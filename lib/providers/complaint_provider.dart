import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../services/firestore_service.dart';

class ComplaintProvider extends ChangeNotifier {
  final Set<String> _upvotedComplaintIds = {};

  final FirestoreService _fireStoreService = FirestoreService();

  Stream<List<Complaint>> get complaintsStream {
    return _fireStoreService.getComplaints();
  }

  Future<void> addComplaint(Complaint complaint) async {
    await _fireStoreService.addComplaint(complaint);
    notifyListeners();
  }

  void updateComplaintStatus(
    String complaintId,
    ComplaintStatus newStatus,
  ) async {
    await _fireStoreService.updateStatus(complaintId, newStatus);
    notifyListeners();
  }

  void upvoteComplaint(String complaintId) {
    if (_upvotedComplaintIds.contains(complaintId)) {
      return;
    }
    _fireStoreService.upvoteComplaint(complaintId);
    _upvotedComplaintIds.add(complaintId);
    notifyListeners();
  }

  bool hasUserUpvoted(String complaintId) {
    return _upvotedComplaintIds.contains(complaintId);
  }
}
