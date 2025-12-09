import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dishari/src/universal_login.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  // Initial values
  final String initialName = "Md Sabbir Ahamed";
  final String initialEmail = "sabbir2517@student.nstu.edu.bd";
  final String initialPhone = "+8801********";
  final String initialBloodGroup = "B+";
  final String initialAllergies = "Dust, Dal";
  final String initialDepartment = "Computer Science & Engineering";
  final String initialSession = "2022-2023";
  final String initialEmergencyContact = "+8801712345678";

  // Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _IDController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bloodGroupController;
  late final TextEditingController _allergiesController;
  late final TextEditingController _departmentController;
  late final TextEditingController _sessionController;

  // Profile image
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  // Track if changes made
  bool _isChanged = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: initialName);
    _emailController = TextEditingController(text: initialEmail);
    _IDController = TextEditingController(text: "ASH2225005M");
    _phoneController = TextEditingController(text: initialPhone);
    _bloodGroupController = TextEditingController(text: initialBloodGroup);
    _allergiesController = TextEditingController(text: initialAllergies);
    _departmentController = TextEditingController(text: initialDepartment);
    _sessionController = TextEditingController(text: initialSession);


    // Listeners to track changes
    _nameController.addListener(_checkChanges);
    _emailController.addListener(_checkChanges);
    _IDController.addListener(_checkChanges);
    _phoneController.addListener(_checkChanges);
    _bloodGroupController.addListener(_checkChanges);
    _allergiesController.addListener(_checkChanges);
    _departmentController.addListener(_checkChanges);
    _sessionController.addListener(_checkChanges);

  }

  void _checkChanges() {
    final changed = _nameController.text != initialName ||
        _emailController.text != initialEmail ||
        _phoneController.text != initialPhone ||
        _bloodGroupController.text != initialBloodGroup ||
        _allergiesController.text != initialAllergies ||
        _departmentController.text != initialDepartment ||
        _sessionController.text != initialSession ||
        _profileImage != null;

    if (changed != _isChanged) {
      setState(() {
        _isChanged = changed;
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
      _checkChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double responsiveWidth(double w) => size.width * w / 375;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Profile"),
        foregroundColor: Colors.blue,
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsiveWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // Profile Picture
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? const Icon(Icons.person, size: 60, color: Colors.black54)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Full Name
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: const Icon(Icons.person, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Email (read-only)
              TextField(
                controller: _emailController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.mail, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // University ID (read-only)
              TextField(
                controller: _IDController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "University ID",
                  prefixIcon: const Icon(Icons.badge, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Phone Number
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  prefixIcon: const Icon(Icons.phone, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Blood Group (read-only)
              TextField(
                controller: _bloodGroupController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Blood Group",
                  prefixIcon: const Icon(Icons.bloodtype, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Allergies
              TextField(
                controller: _allergiesController,
                decoration: InputDecoration(
                  labelText: "Allergies (if any)",
                  prefixIcon: const Icon(Icons.health_and_safety, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Department (read-only)
              TextField(
                controller: _departmentController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Department",
                  prefixIcon: const Icon(Icons.school, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Session (read-only)
              TextField(
                controller: _sessionController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Session",
                  prefixIcon: const Icon(Icons.calendar_month, color: Colors.blue),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Save Changes Button
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isChanged
                      ? () {
                    // TODO: Save updated profile
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Changes Saved!"),
                      ),
                    );
                    setState(() {
                      _isChanged = false;
                    });
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
