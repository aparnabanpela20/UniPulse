import 'package:flutter/material.dart';
import '../models/complaint.dart';
import '../screens/complaint_detail_screen.dart';

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final Color primary;
  final Color secondary;
  final bool isTopPriority;

  const ComplaintCard({
    super.key,
    required this.complaint,
    required this.primary,
    required this.secondary,
    this.isTopPriority = false,
  });

  Color _statusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.notStarted:
        return Colors.grey;
      case ComplaintStatus.working:
        return Colors.orange;
      case ComplaintStatus.completed:
        return Colors.green;
    }
  }

  String _statusText(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.notStarted:
        return "Not Started";
      case ComplaintStatus.working:
        return "Working";
      case ComplaintStatus.completed:
        return "Completed";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isTopPriority ? 3 : 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: isTopPriority
              ? const Border(
                  left: BorderSide(color: Colors.redAccent, width: 4),
                )
              : null,
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Complaint text
            Text(
              complaint.complaint,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            // Status + View Details
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(complaint.status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusText(complaint.status),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _statusColor(complaint.status),
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ComplaintDetailScreen(complaint: complaint),
                      ),
                    );
                  },
                  child: Text(
                    "View Details",
                    style: TextStyle(color: secondary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
