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
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: primary.withOpacity(0.4), width: 1.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: primary,
            ),
          ),

          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _complaintCard({
    required String complaint,
    required String solution,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Color primary,
    required Color secondary,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primary.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              complaint,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onToggle,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: secondary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isExpanded ? "Hide Solution" : "Show Solution",
                  style: TextStyle(color: secondary),
                ),
              ),
            ),
            if (isExpanded) ...[
              const SizedBox(height: 10),
              Text(
                "Prefferred Solution:",
                style: TextStyle(fontWeight: FontWeight.w600, color: primary),
              ),

              const SizedBox(height: 4),
              Text(solution),
            ],
          ],
        ),
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
        title: Text("UNIPULSE", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Admin Dashboard",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),

            const SizedBox(height: 20),

            _sectionContainer(
              title: "Top Priority Complaints",
              primary: primary,
              child: Column(
                children: List.generate(topPriorityComplaints.length, (index) {
                  final item = topPriorityComplaints[index];
                  final isExpanded = expandedTopPriority.contains(index);

                  return _complaintCard(
                    complaint: item.complaint,
                    solution: item.solution,
                    isExpanded: isExpanded,
                    onToggle: () {
                      setState(() {
                        isExpanded
                            ? expandedTopPriority.remove(index)
                            : expandedTopPriority.add(index);
                      });
                    },
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
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: primary.withOpacity(0.3)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedFilter,
                          isExpanded: true,
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

                            return _complaintCard(
                              complaint: item.complaint,
                              solution: item.solution,
                              isExpanded: isExpanded,
                              onToggle: () {
                                setState(() {
                                  isExpanded
                                      ? expandedPast.remove(index)
                                      : expandedPast.add(index);
                                });
                              },
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
