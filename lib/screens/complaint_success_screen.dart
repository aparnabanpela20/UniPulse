import '/screens/view_complaint_screen.dart';
import 'package:flutter/material.dart';
import 'selection_screen.dart';
import 'complaint_screen.dart';

class ComplaintSuccessScreen extends StatelessWidget {
  final String role;
  const ComplaintSuccessScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;

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
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/logo.png", height: 72),
              const SizedBox(height: 24),
              Text(
                "Complaint Submitted",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Your complaint has been successfully submitted.\n"
                "It will be reviewed and resolved soon.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ViewComplaintScreen(),
                    ),
                  );
                },
                child: const Text("View all Complaints"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
