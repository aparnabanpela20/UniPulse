import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/complaint.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final CollectionReference _complaintCollection = FirebaseFirestore.instance
      .collection('complaints');

  Future<void> addComplaint(Complaint complaint) async {
    await _complaintCollection.add({
      ...complaint.toMap(),
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Stream<List<Complaint>> getComplaints() {
    return _complaintCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Complaint.fromMap(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }

  Future<void> updateStatus(String complaintId, ComplaintStatus status) async {
    await _complaintCollection.doc(complaintId).update({"status": status.name});
  }

  Future<void> upvoteComplaint(String complaintId) async {
    await _complaintCollection.doc(complaintId).update({
      'upvotes': FieldValue.increment(1),
    });
  }
}
