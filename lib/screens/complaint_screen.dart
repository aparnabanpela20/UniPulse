import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/complaint_provider.dart';
import 'complaint_success_screen.dart';

class ComplaintScreen extends StatefulWidget {
  final String role;
  const ComplaintScreen({super.key, required this.role});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  String? selectedDepartment;
  String? selectedCategory;

  final TextEditingController complaintController = TextEditingController();
  final TextEditingController solutionController = TextEditingController();

  final List<String> departments = [
    'Computer Science',
    'Mechanical Engineering',
    'Electrical Engineering',
    'Civil Engineering',
  ];

  final List<String> categories = [
    "Infrastructure",
    "Academics",
    "Hostel",
    "Mental Well-being",
    "Others",
  ];

  void submitComplaint() {
    if (selectedDepartment == null ||
        selectedCategory == null ||
        complaintController.text.isEmpty ||
        solutionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final complaintProvider = Provider.of<ComplaintProvider>(
      context,
      listen: false,
    );

    complaintProvider.addComplaint(
      complaint: complaintController.text,
      solution: solutionController.text,
      givenBy: "User",
      role: widget.role,
      department: selectedDepartment!,
      category: selectedCategory!,
    );

    complaintController.clear();
    solutionController.clear();
    setState(() {
      selectedDepartment = null;
      selectedCategory = null;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ComplaintSuccessScreen(role: widget.role),
      ),
    );
  }

  Widget _label(String text, Color primary) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
      ),
    );
  }

  // 🔒 unchanged
  Widget _dropdown({
    required List<String> items,
    required String? value,
    required String hint,
    required Function(String?) onChanged,
    required Color primary,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primary.withOpacity(0.3)),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
            value: value,
            hint: Text(hint),
            isExpanded: true,
            iconEnabledColor: primary,
          ),
        ),
      ),
    );
  }

  // 🔒 unchanged
  Widget _textBox({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
    required Color primary,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primary.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          cursorColor: primary,
          decoration: InputDecoration(hintText: hint, border: InputBorder.none),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final secondary = theme.colorScheme.secondary;

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
            // Title section
            Text(
              "What’s your complaint?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Share the issue so we can address it effectively.",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 24),

            // Form container
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label("Department", primary),
                    _dropdown(
                      items: departments,
                      value: selectedDepartment,
                      hint: "Select Department",
                      onChanged: (val) {
                        setState(() {
                          selectedDepartment = val;
                        });
                      },
                      primary: primary,
                    ),

                    const SizedBox(height: 16),

                    _label("Complaint Category", primary),
                    _dropdown(
                      items: categories,
                      value: selectedCategory,
                      hint: "Select category",
                      onChanged: (value) {
                        setState(() => selectedCategory = value);
                      },
                      primary: primary,
                    ),

                    const SizedBox(height: 16),

                    _label("Complaint", primary),
                    _textBox(
                      controller: complaintController,
                      hint: "Describe your complaint",
                      maxLines: 5,
                      primary: primary,
                    ),

                    const SizedBox(height: 16),

                    _label("Preferred Solution", primary),
                    _textBox(
                      controller: solutionController,
                      hint: "Suggest a possible solution",
                      maxLines: 3,
                      primary: primary,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Submit button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  "Submit Complaint",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
