import 'package:campus_signal/models/ai_state_model.dart';
import 'package:campus_signal/widget/ai_loading_card.dart';
import 'package:campus_signal/widget/complaint_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';
import '../providers/complaint_provider.dart';
import '../models/complaint.dart';
import '../providers/ai_provider.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  final ValueNotifier<String> selectedFilter = ValueNotifier<String>("1 Day");
  final Set<int> expandedTopPriority = {};
  final Set<int> expandedPast = {};
  bool isAiEnabled = false;
  bool _hasTriggeredAI = false;

  static const double kSectionHeight = 600;

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

  void _triggerGlobalAIOnce(List<Complaint> complaints) {
    if (!isAiEnabled || _hasTriggeredAI) return;

    _hasTriggeredAI = true;

    final complaintsMap = {for (var c in complaints) c.id: c.toMap()};
    print("Triggering global ai ");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("Calling AI API...");

      ref.read(aiProvider.notifier).fetchGlobalInsights(complaintsMap);
    });
  }

  List<Complaint> getTopPriorityComplaints(List<Complaint> complaints) {
    final aiState = ref.watch(aiProvider);

    List<Complaint> topPriorityComplaint;

    if (isAiEnabled &&
        aiState.globalInsights != null &&
        aiState.globalInsights!['topPriorityComplaintIds'] != null) {
      print("Using AI to determine top priority complaints ❤️❤️");
      final aiIds = List<String>.from(
        aiState.globalInsights!['topPriorityComplaintIds'],
      );

      topPriorityComplaint = complaints
          .where((c) => aiIds.contains(c.id))
          .toList();
    } else {
      // fallback (same logic as before, but inline)
      print("Using fallback to determine top priority complaints 💔💔");
      final unresolved = complaints
          .where((c) => c.status != ComplaintStatus.completed)
          .toList();

      unresolved.sort((a, b) {
        final upvoteCompare = b.upvotes.compareTo(a.upvotes);
        if (upvoteCompare != 0) return upvoteCompare;
        return b.createdAt.compareTo(a.createdAt);
      });

      topPriorityComplaint = unresolved.take(3).toList();
    }
    return topPriorityComplaint;
  }

  Widget _sectionContainer({
    required String title,
    required Color primary,
    required Widget child,
    bool highlight = true,
  }) {
    return Container(
      width: double.infinity,
      height: kSectionHeight, // ⭐ SAME HEIGHT FOR ALL SECTIONS
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
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Color(0xFFF8FAFF)],
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
            // 🔹 Header (fixed)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primary.withOpacity(0.1), primary.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                  if (isAiEnabled)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.auto_awesome,
                        size: 18,
                        color: Colors.orange.shade400,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔥 Scrollable content area
            Expanded(
              child: Builder(
                builder: (context) {
                  final ScrollController controller = ScrollController();

                  return Scrollbar(
                    controller: controller,
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      controller: controller,
                      physics: const BouncingScrollPhysics(),
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupedComplaintsSection(
    List<Complaint> allComplaints,
    Color primary,
    Color secondary,
  ) {
    final aiState = ref.watch(aiProvider);

    if (!isAiEnabled ||
        aiState.globalInsights == null ||
        aiState.globalInsights!['groups'] == null) {
      return const SizedBox.shrink();
    }

    final groups =
        List<Map<String, dynamic>>.from(
          aiState.globalInsights!['groups'],
        ).where((group) {
          final complaintIds = List<String>.from(group['complaintIds']);
          return complaintIds.length >= 2;
        });

    return _sectionContainer(
      title: "Grouped Complaints",
      primary: primary,
      child: groups.isEmpty
          ? Center(
              child: Text(
                "No grouped complaints found",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            )
          : Column(
              children: groups.map((group) {
                final String title = group['groupTitle'];
                final List<String> complaintIds = List<String>.from(
                  group['complaintIds'],
                );

                final groupComplaints = allComplaints
                    .where((c) => complaintIds.contains(c.id))
                    .toList();

                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: primary.withOpacity(0.2)),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Group title
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Icon(
                            Icons.folder_copy_outlined,
                            size: 18,
                            color: primary,
                          ),

                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width - 120,
                            ),
                            child: Text(
                              title,
                              softWrap: true,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: primary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // 🔹 Complaints inside group
                      Column(
                        children: groupComplaints.map((complaint) {
                          return ComplaintCard(
                            complaint: complaint,
                            primary: primary,
                            secondary: secondary,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              }).toList(),
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
    final aiState = ref.watch(aiProvider);

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
        actions: [
          Tooltip(
            message: isAiEnabled
                ? "AI Assistance Enabled"
                : "Enable AI Assistance",
            child: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isAiEnabled = !isAiEnabled;
                    _hasTriggeredAI = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: isAiEnabled
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF4285F4), // Google Blue
                              Color(0xFF9A4DFF), // Gemini Purple
                              Color(0xFFDB4437), // Soft Red/Pink
                            ],
                          )
                        : null,
                    border: Border.all(
                      color: isAiEnabled
                          ? Colors.transparent
                          : Colors.white.withOpacity(0.7),
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    size: 20,
                    color: isAiEnabled ? Colors.white : Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
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
              _buildAiGlobalStatus(aiState, primary),
              Row(
                children: [
                  Text(
                    "Admin Dashboard",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                  if (isAiEnabled)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.auto_awesome,
                        size: 18,
                        color: Colors.orange.shade400,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "Overview of campus complaints",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              StreamBuilder<List<Complaint>>(
                stream: context.read<ComplaintProvider>().complaintsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text("No complaints found");
                  }

                  final complaints = snapshot.data!;
                  _triggerGlobalAIOnce(complaints);

                  final topPriorityComplaint = getTopPriorityComplaints(
                    complaints,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🔹 Top Priority Complaints
                      _sectionContainer(
                        title: "Top Priority Complaints",
                        primary: primary,
                        highlight: true,
                        child: Column(
                          children: topPriorityComplaint.map((item) {
                            return ComplaintCard(
                              complaint: item,
                              primary: primary,
                              secondary: secondary,
                              isTopPriority: true,
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 🔹 Grouped Complaints (SEPARATE SECTION)
                      _buildGroupedComplaintsSection(
                        complaints,
                        primary,
                        secondary,
                      ),
                    ],
                  );
                },
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

  Widget _buildAiGlobalStatus(AIStateModel aiState, Color primary) {
    if (!isAiEnabled) return const SizedBox.shrink();

    // ⏳ AI loading
    if (aiState.isGlobalLoading) {
      return const AiLoadingCard();
    }

    // ✅ AI ready
    if (aiState.globalInsights != null) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF6366F1).withOpacity(0.15),
              const Color(0xFF8B5CF6).withOpacity(0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF6366F1).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Color(0xFF6366F1), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "AI insights applied across the dashboard",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4F46E5),
                ),
              ),
            ),
            const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
