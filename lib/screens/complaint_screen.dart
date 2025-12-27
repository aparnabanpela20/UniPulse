import 'package:campus_signal/models/complaint.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/complaint_provider.dart';
import 'complaint_success_screen.dart';
import 'view_complaint_screen.dart';

class ComplaintScreen extends StatefulWidget {
  final String role;
  final String user;
  const ComplaintScreen({super.key, required this.role, required this.user});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  String? selectedDepartment;
  String? selectedCategory;
  bool _isSubmitting = false;

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

  Future<void> submitComplaint() async {
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

    setState(() {
      _isSubmitting = true;
    });
    try {
      complaintProvider.addComplaint(
        Complaint(
          complaint: complaintController.text,
          solution: solutionController.text,
          givenBy: widget.user,
          role: widget.role,
          department: selectedDepartment!,
          category: selectedCategory!,
          createdAt: DateTime.now(),
        ),
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
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to submit complaint. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _label(String text, Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, const Color(0xFFF8FAFF)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3F51B5).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: primary.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            items: items.map((item) {
              return DropdownMenuItem(value: item, child: Text(item));
            }).toList(),
            onChanged: onChanged,
            value: value,
            hint: Text(hint, style: TextStyle(color: Colors.grey[500])),
            isExpanded: true,
            iconEnabledColor: primary,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, const Color(0xFFF8FAFF)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3F51B5).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: primary.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          cursorColor: primary,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[500]),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
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
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ViewComplaintScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.list_alt, color: Colors.white),
              tooltip: "View all complaints",
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF8FAFF),
                  Color(0xFFEEF2FF),
                  Color(0xFFE0E7FF),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.white.withOpacity(0.9),
                          const Color(0xFFF1F5F9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A237E).withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "What's your complaint?",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: primary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Share the issue so we can address it effectively.",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
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
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [secondary, const Color(0xFF6366F1)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primary.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: submitComplaint,
                        borderRadius: BorderRadius.circular(16),
                        child: const Center(
                          child: Text(
                            "Submit Complaint",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
