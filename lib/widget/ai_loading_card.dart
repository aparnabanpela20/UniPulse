import 'package:flutter/material.dart';

class AiLoadingCard extends StatelessWidget {
  const AiLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.08), primary.withOpacity(0.03)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primary.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              "AI is analyzing complaints and generating insights…",
              style: TextStyle(fontWeight: FontWeight.w600, color: primary),
            ),
          ),
          const Icon(Icons.auto_awesome, color: Colors.orange),
        ],
      ),
    );
  }
}
