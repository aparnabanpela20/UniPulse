import 'package:flutter/material.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  String? selectedDepartment;
  String? selectedCategory;

  final TextEditingController complaintController = TextEditingController();
  final TextEditingController solutionController = TextEditingController();

  final Map<int, Map<String, String>> complaintsMap = {};
  int complaintId = 0;

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

    complaintId++;
    complaintsMap[complaintId] = {
      "department": selectedDepartment!,
      "category": selectedCategory!,
      "complaint": complaintController.text,
      "solution": solutionController.text,
    };

    complaintController.clear();
    solutionController.clear();
    setState(() {
      selectedDepartment = null;
      selectedCategory = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Complaint submitted successfully")),
    );
  }

  Widget _label(String text, Color primary) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
    );
  }

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
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text("UniPulse"),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 20),
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

            const SizedBox(height: 20),

            _label("Complaint", primary),
            _textBox(
              controller: complaintController,
              hint: "Describe your complaint",
              maxLines: 5,
              primary: primary,
            ),

            const SizedBox(height: 20),

            _label("Preferred Solution", primary),
            _textBox(
              controller: solutionController,
              hint: "Suggest a possible solution",
              maxLines: 3,
              primary: primary,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
