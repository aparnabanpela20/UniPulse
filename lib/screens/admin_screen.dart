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
  final ValueNotifier<String> selectedFilter = ValueNotifier<String>("1 Day");
  final Set<int> expandedTopPriority = {};
  final Set<int> expandedPast = {};

  Duration? _getDurationFromFilter(String filter) {
    switch (filter) {
      case "1 Hour":
        return const Duration(hours: 1);
      case "1 Day":
        return const Duration(days: 1);
      case "1 Week":
        return const Duration(days: 7);
      default:
        return null;
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
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: highlight
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary.withOpacity(0.05),
                  const Color(0xFF6366F1).withOpacity(0.05),
                  Colors.white.withOpacity(0.9),
                ],
              )
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, const Color(0xFFF8FAFF)],
              ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: primary.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary.withOpacity(0.1), primary.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    selectedFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final secondary = theme.colorScheme.secondary;

    final complaintProvider = Provider.of<ComplaintProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
              ],
            ),
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "UNIPULSE",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFF), Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SingleChildScrollView(
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
                child: StreamBuilder<List<Complaint>>(
                  stream: context.read<ComplaintProvider>().complaintsStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("No complaints found");
                    }

                    final complaints = snapshot.data!;

                    complaints.sort(
                      (a, b) => b.createdAt.compareTo(a.createdAt),
                    );

                    final topPriorityComplaint = complaints.take(3).toList();

                    return Column(
                      children: List.generate(topPriorityComplaint.length, (
                        index,
                      ) {
                        final item = topPriorityComplaint[index];
                        final isExpanded = expandedTopPriority.contains(index);

                        return ComplaintCard(
                          complaint: item,
                          primary: primary,
                          secondary: secondary,
                        );
                      }),
                    );
                  },
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
                              value: selectedFilter.value,
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
                                DropdownMenuItem(
                                  value: "All",
                                  child: Text("All Time"),
                                ),
                              ],
                              onChanged: (value) {
                                selectedFilter.value = value!;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    ValueListenableBuilder<String>(
                      valueListenable: selectedFilter,
                      builder: (context, filter, _) {
                        final duration = _getDurationFromFilter(filter);

                        return StreamBuilder<List<Complaint>>(
                          stream: context
                              .read<ComplaintProvider>()
                              .complaintsStream,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: const Text("No complaints found"),
                              );
                            }

                            final allComplaints = snapshot.data!;
                            final now = DateTime.now();

                            final filteredComplaints = duration == null
                                ? allComplaints
                                : allComplaints.where((c) {
                                    return now.difference(c.createdAt) <=
                                        duration;
                                  }).toList();

                            if (filteredComplaints.isEmpty) {
                              return Center(
                                child: const Text(
                                  "No complaints found in the selected duration",
                                ),
                              );
                            }

                            return Column(
                              children: List.generate(
                                filteredComplaints.length,
                                (index) {
                                  final item = filteredComplaints[index];
                                  final isExpanded = expandedPast.contains(
                                    index,
                                  );

                                  return ComplaintCard(
                                    complaint: item,
                                    primary: primary,
                                    secondary: secondary,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
