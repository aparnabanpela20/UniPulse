enum ComplaintStatus { notStarted, working, completed }

class Complaint {
  final String id;
  final String complaint;
  final String solution;
  final String givenBy;
  final String role;
  final String department;
  final String category;
  final DateTime createdAt;
  ComplaintStatus status;

  Complaint({
    required this.id,
    required this.complaint,
    required this.solution,
    required this.role,
    required this.givenBy,
    required this.department,
    required this.category,
    required this.createdAt,
    this.status = ComplaintStatus.notStarted,
  });
}
