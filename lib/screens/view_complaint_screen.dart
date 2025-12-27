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

  Widget _complaintCard(
    BuildContext context,
    Complaint complaint,
    Color primary,
    Color secondary,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary.withOpacity(0.1), secondary.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          complaint.complaint,
          style: TextStyle(color: primary, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "Status: ${_statusText(complaint.status)}",
          style: TextStyle(
            color: _statusColor(complaint.status),
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: primary),
        onTap: () {
          // Navigate to complaint detail screen
        },
      ),
    );
  }

  Widget _emptyState(Color primary) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "No complaints submitted yet",
            style: TextStyle(color: primary, fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final secondary = theme.colorScheme.secondary;

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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder<List<Complaint>>(
            stream: context.read<ComplaintProvider>().complaintsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: _emptyState(primary));
              }

              final complaints = snapshot.data!;

              return ListView.builder(
                itemBuilder: (context, index) {
                  final complaint = complaints[index];

                  return _complaintCard(context, complaint, primary, secondary);
                },
                itemCount: complaints.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
