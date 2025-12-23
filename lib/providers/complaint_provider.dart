import 'package:flutter/material.dart';
import '../models/complaint.dart';

class ComplaintProvider extends ChangeNotifier {
  final List<Complaint> _complaints = [
    Complaint(
      id: '1',
      complaint:
          'Canteen hygiene has significantly deteriorated over the past few weeks. '
          'Food trays are often not cleaned properly, waste bins overflow during lunch hours, '
          'and several students have complained about stomach issues after eating.',
      solution:
          'Conduct daily hygiene inspections, introduce staff hygiene training, '
          'increase cleaning staff during peak hours, and enforce strict food safety checks.',
      givenBy: 'Neha Sharma',
      role: 'Student',
      department: 'Computer Science',
      category: 'Infrastructure',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      status: ComplaintStatus.notStarted,
    ),

    Complaint(
      id: '2',
      complaint:
          'Wi-Fi connectivity in the central library is extremely slow, especially during exams. '
          'Students are unable to access online journals, submit assignments, or attend online lectures.',
      solution:
          'Upgrade network bandwidth, install additional routers on each floor, '
          'and perform regular network audits during peak usage hours.',
      givenBy: 'Prof. R. Mehta',
      role: 'Professors',
      department: 'Mechanical Engineering',
      category: 'Academics',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      status: ComplaintStatus.working,
    ),

    Complaint(
      id: '3',
      complaint:
          'Street lights near the hostel parking area do not function properly at night. '
          'This creates safety concerns, especially for students returning late from labs or library.',
      solution:
          'Repair faulty lights immediately, install additional LED lights, '
          'and conduct monthly maintenance checks to ensure proper illumination.',
      givenBy: 'Rahul Verma',
      role: 'Student',
      department: 'Electrical Engineering',
      category: 'Infrastructure',
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      status: ComplaintStatus.completed,
    ),

    Complaint(
      id: '4',
      complaint:
          'The syllabus for the core subject has not been completed even though internal exams '
          'are scheduled next week. Students are anxious and unprepared for the assessment.',
      solution:
          'Arrange extra revision lectures, provide recorded sessions, '
          'and adjust exam syllabus coverage in coordination with faculty.',
      givenBy: 'Neha Kulkarni',
      role: 'Student',
      department: 'Civil Engineering',
      category: 'Academics',
      createdAt: DateTime.now().subtract(const Duration(hours: 10)),
      status: ComplaintStatus.working,
    ),

    Complaint(
      id: '5',
      complaint:
          'Hostel water supply is irregular in the mornings, causing delays for students '
          'getting ready for classes. Sometimes water is unavailable for over an hour.',
      solution:
          'Install additional water storage tanks, ensure timely pump operation, '
          'and create a backup supply schedule during peak hours.',
      givenBy: 'Suresh Patil',
      role: 'Student',
      department: 'Mechanical Engineering',
      category: 'Hostel',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: ComplaintStatus.notStarted,
    ),

    Complaint(
      id: '6',
      complaint:
          'Several students have reported increased stress and anxiety due to academic pressure, '
          'lack of counseling sessions, and limited mental health support on campus.',
      solution:
          'Introduce weekly counseling hours, organize mental health awareness workshops, '
          'and appoint a full-time student counselor.',
      givenBy: 'Dr. Anjali Rao',
      role: 'Professors',
      department: 'Computer Science',
      category: 'Mental Well-being',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      status: ComplaintStatus.completed,
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
    final filtered = _complaints.where((c) {
      return now.difference(c.createdAt) <= duration;
    }).toList();

    filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return filtered;
  }

  List<Complaint> getTopPriorityComplaints({int limit = 3}) {
    List<Complaint> source = _complaints;

    // Latest first
    source.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return source.take(limit).toList();
  }

  void updateComplaintStatus(String complaintId, ComplaintStatus newStatus) {
    final index = _complaints.indexWhere((c) => c.id == complaintId);

    if (index != -1) {
      _complaints[index].status = newStatus;
      notifyListeners();
    }
  }
}
