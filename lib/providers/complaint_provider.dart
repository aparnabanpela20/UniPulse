import 'package:flutter/material.dart';
import '../models/complaint.dart';

class ComplaintProvider extends ChangeNotifier {
  final List<Complaint> _complaints = [
    Complaint(
      id: "1",
      complaint: "Water shortage in hostel during mornings",
      solution: "Install additional water tanks and ensure regular supply",
      givenBy: "Rahul Sharma",
      role: "Student",
      department: "Mechanical Engineering",
      category: "Hostel",
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Complaint(
      id: "2",
      complaint: "Wi-Fi connectivity is very slow in library",
      solution: "Upgrade routers and increase bandwidth",
      givenBy: "Ananya Verma",
      role: "Student",
      department: "Computer Science",
      category: "Infrastructure",
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Complaint(
      id: "3",
      complaint: "Syllabus not completed before internal exams",
      solution: "Conduct extra revision lectures",
      givenBy: "Dr. Amit Kumar",
      role: "Professors",
      department: "Electrical Engineering",
      category: "Academics",
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Complaint(
      id: "4",
      complaint: "Poor lighting in parking area at night",
      solution: "Install additional street lights for safety",
      givenBy: "Sneha Patel",
      role: "Student",
      department: "Civil Engineering",
      category: "Infrastructure",
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Complaint(
      id: "5",
      complaint: "Canteen hygiene needs improvement",
      solution: "Regular inspections and staff hygiene training",
      givenBy: "Prof. R. Mehta",
      role: "Professors",
      department: "Mechanical Engineering",
      category: "Others",
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
  ];

  List<Complaint> get complaints {
    return List.unmodifiable(_complaints);
  }

  void addComplaint({
    required String complaint,
    required String solution,
    required String givenBy,
    required String role,
    required String department,
    required String category,
  }) {
    final newComplaint = Complaint(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      complaint: complaint,
      solution: solution,
      givenBy: givenBy,
      role: role,
      department: department,
      category: category,
      createdAt: DateTime.now(),
    );

    _complaints.add(newComplaint);
    notifyListeners();
  }

  List<Complaint> getComplaintsByDuration(Duration duration) {
    final now = DateTime.now();
    return _complaints.where((c) {
      return now.difference(c.createdAt) <= duration;
    }).toList();
  }

  List<Complaint> getTopPriorityComplaints({int limit = 3}) {
    List<Complaint> source = _complaints;

    // Latest first
    source.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return source.take(limit).toList();
  }
}
