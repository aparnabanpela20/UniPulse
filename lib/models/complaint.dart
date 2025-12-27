import 'package:cloud_firestore/cloud_firestore.dart';

enum ComplaintStatus { notStarted, working, completed }

class Complaint {
  late String id;
  final String complaint;
  final String solution;
  final String givenBy;
  final String role;
  final String department;
  final String category;
  final DateTime createdAt;
  ComplaintStatus status;
  int upvotes;

  Complaint({
    this.id = '',
    required this.complaint,
    required this.solution,
    required this.role,
    required this.givenBy,
    required this.department,
    required this.category,
    required this.createdAt,
    this.status = ComplaintStatus.notStarted,
    this.upvotes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      "complaint": complaint,
      "solution": solution,
      "givenBy": givenBy,
      "role": role,
      "department": department,
      "category": category,
      "createdAt": createdAt,
      "status": status.name,
      "upvotes": upvotes,
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map, String documentId) {
    final createdAtField = map['createdAt'];
    return Complaint(
      id: documentId,
      complaint: map['complaint'] ?? '',
      solution: map['solution'] ?? '',
      givenBy: map['givenBy'] ?? '',
      role: map['role'] ?? '',
      department: map['department'] ?? '',
      category: map['category'] ?? '',
      createdAt: createdAtField is Timestamp
          ? createdAtField.toDate()
          : DateTime.parse(createdAtField),
      status: ComplaintStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ComplaintStatus.notStarted,
      ),
      upvotes: map['upvotes'] ?? 0,
    );
  }
}
