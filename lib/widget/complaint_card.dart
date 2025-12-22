import 'package:flutter/material.dart';

class ComplaintCard extends StatelessWidget {
  final String complaint;
  final String solution;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Color primary;
  final Color secondary;
  bool isTopPriority = false;
  ComplaintCard({
    super.key,
    required this.complaint,
    required this.solution,
    required this.isExpanded,
    required this.onToggle,
    required this.primary,
    required this.secondary,
    this.isTopPriority = false,
  });
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
              ? Border(left: BorderSide(color: Colors.redAccent, width: 4))
              : null,
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              complaint,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
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
                "Preferred Solution",
                style: TextStyle(fontWeight: FontWeight.w600, color: primary),
              ),
              const SizedBox(height: 4),
              Text(solution),
            ],
          ],
        ),
      ),
    );
    ;
  }
}
