import 'package:campus_signal/widget/complaint_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/complaint_provider.dart';
import '../models/complaint.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String selectedFilter = "1 Day";

  final Set<int> expandedTopPriority = {};
  final Set<int> expandedPast = {};

  Duration _getDurationFromFilter(String filter) {
    switch (filter) {
      case "1 Hour":
        return const Duration(hours: 1);
      case "1 Day":
        return const Duration(days: 1);
      case "1 Week":
        return const Duration(days: 7);
      default:
        return const Duration(days: 1);
    }
  }

  Widget _sectionContainer({
    required String title,
    required Color primary,
    required Widget child,
    bool highlight = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? primary.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final secondary = theme.colorScheme.secondary;

    final complaintProvider = Provider.of<ComplaintProvider>(context);

    final Duration selectedDuration = _getDurationFromFilter(selectedFilter);

    final List<Complaint> allComplaints = complaintProvider
        .getComplaintsByDuration(selectedDuration);

    final List<Complaint> topPriorityComplaints = complaintProvider
        .getTopPriorityComplaints();

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
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Admin Dashboard",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Overview of campus complaints",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 24),

            _sectionContainer(
              title: "Top Priority Complaints",
              primary: primary,
              highlight: true,
              child: Column(
                children: List.generate(topPriorityComplaints.length, (index) {
                  final item = topPriorityComplaints[index];
                  final isExpanded = expandedTopPriority.contains(index);

                  return ComplaintCard(
                    complaint: item,
                    isTopPriority: true,
                    primary: primary,
                    secondary: secondary,
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            _sectionContainer(
              title: "Past Complaints",
              primary: primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedFilter,
                            iconEnabledColor: primary,
                            items: const [
                              DropdownMenuItem(
                                value: "1 Hour",
                                child: Text("Last 1 Hour"),
                              ),
                              DropdownMenuItem(
                                value: "1 Day",
                                child: Text("Last 1 Day"),
                              ),
                              DropdownMenuItem(
                                value: "1 Week",
                                child: Text("Last 1 Week"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedFilter = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  allComplaints.isEmpty
                      ? Center(
                          child: Text(
                            "No complaints submitted yet",
                            style: TextStyle(color: primary),
                          ),
                        )
                      : Column(
                          children: List.generate(allComplaints.length, (
                            index,
                          ) {
                            final item = allComplaints[index];
                            final isExpanded = expandedPast.contains(index);

                            return ComplaintCard(
                              complaint: item,
                              primary: primary,
                              secondary: secondary,
                            );
                          }),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
