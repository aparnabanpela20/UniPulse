import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/complaint.dart';
import 'package:provider/provider.dart';
import '../providers/complaint_provider.dart';

class ComplaintDetailScreen extends StatefulWidget {
  final Complaint complaint;

  const ComplaintDetailScreen({super.key, required this.complaint});

  @override
  State<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  late ComplaintStatus status;

  @override
  void initState() {
    super.initState();
    status = widget.complaint.status;
  }

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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final secondary = theme.colorScheme.secondary;

    final complaintProvider = Provider.of<ComplaintProvider>(
      context,
      listen: false,
    );

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

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Complaint Title
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  widget.complaint.complaint,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Complaint Details
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _infoRow("Submitted By", widget.complaint.givenBy),
                    _infoRow("Role", widget.complaint.role),
                    _infoRow("Department", widget.complaint.department),
                    _infoRow("Category", widget.complaint.category),
                    _infoRow(
                      "Submitted On",
                      DateFormat(
                        'dd MMM yyyy • hh:mm a',
                      ).format(widget.complaint.createdAt),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// 🔹 Preferred Solution
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Preferred Solution",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.complaint.solution,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔹 Status Section (Admin Action)
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: ComplaintStatus.values.map((s) {
                        return ChoiceChip(
                          label: Text(_statusText(s)),
                          selected: status == s,
                          selectedColor: _statusColor(s).withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: status == s ? _statusColor(s) : Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (_) {
                            setState(() {
                              status = s;
                            });

                            complaintProvider.updateComplaintStatus(
                              widget.complaint.id,
                              s,
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
