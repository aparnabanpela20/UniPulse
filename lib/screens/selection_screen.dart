import 'package:campus_signal/widget/role_card.dart';

import '/screens/admin_screen.dart';
import 'complaint_screen.dart';
import 'package:flutter/material.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  String? selectedCollege;
  String? selectedRole;
  bool isLoading = false;

  final List<String> colleges = [
    'Guru Ghasidas Vishwavidyalaya',
    'Chouksey Engineering College',
    'Atal Bihari Vishwavidyalaya',
  ];
  final TextEditingController nameController = TextEditingController();

  void _continue() {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter your name")));
      return;
    }

    if (selectedCollege == null && selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select college and role")),
      );
      return;
    }

    if (selectedCollege == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select college")));
      return;
    }

    if (selectedRole == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select role")));
      return;
    }

    if (selectedRole == "Student" || selectedRole == "Professors") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ComplaintScreen(role: selectedRole!)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AdminScreen()),
      );
    }
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

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Text(
                    "Welcome to UniPulse",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Name
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Your Name",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          hintText: "Enter your name",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // College
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Your College",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: const Text("Select a college"),
                          value: selectedCollege,
                          isExpanded: true,
                          iconEnabledColor: primary,
                          items: colleges.map((college) {
                            return DropdownMenuItem(
                              value: college,
                              child: Text(college),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCollege = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Role
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Select Role",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      RoleCard(
                        icon: Icons.person,
                        title: "Student",
                        isSelected: selectedRole == "Student",
                        onTap: () {
                          setState(() {
                            selectedRole = "Student";
                          });
                        },
                      ),
                      const SizedBox(width: 12),
                      RoleCard(
                        icon: Icons.school,
                        title: "Professors",
                        isSelected: selectedRole == "Professors",
                        onTap: () {
                          setState(() {
                            selectedRole = "Professors";
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Admin Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedRole = "Admin";
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: selectedRole == "Admin" ? secondary : primary,
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Admin",
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedRole == "Admin" ? secondary : primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Continue
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _continue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        "Continue",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
