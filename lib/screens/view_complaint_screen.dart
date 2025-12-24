import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/complaint_provider.dart';
import '../models/complaint.dart';

class ViewComplaintScreen extends StatelessWidget {
  const ViewComplaintScreen({super.key});

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
        return "In Progress";
      case ComplaintStatus.completed:
        return "Completed";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

    final complaints = context.watch<ComplaintProvider>().complaints;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo.png', height: 28),
            const SizedBox(width: 8),
            const Text(
              "UNIPULSE",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: complaints.isEmpty
            ? Center(
                child: Text(
                  "No complaints submitted yet",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
            : ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  final complaint = complaints[complaints.length - 1 - index];

                  final provider = context.watch<ComplaintProvider>();
                  final hasUpvoted = provider.hasUserUpvoted(complaint.id);

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            complaint.complaint,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_drop_up,
                                  color: hasUpvoted
                                      ? Colors.grey
                                      : Colors.blueGrey,
                                  size: 24,
                                ),
                                onPressed: hasUpvoted
                                    ? null
                                    : () {
                                        context
                                            .read<ComplaintProvider>()
                                            .upvoteComplaint(complaint.id);
                                      },
                                tooltip: "Upvote",
                              ),
                              Text(
                                complaint.upvotes.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),

                          Text(
                            "Submitted by ${complaint.givenBy} • ${complaint.department}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _statusColor(
                                  complaint.status,
                                ).withOpacity(0.15),
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
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
