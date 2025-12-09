import 'package:flutter/material.dart';
import 'package:dishari/src/universal_login.dart';
import 'patient_dashboard.dart';

class PatientSignupPage extends StatefulWidget {
  const PatientSignupPage({super.key});

  @override
  State<PatientSignupPage> createState() => _PatientSignupPageState();
}

class _PatientSignupPageState extends State<PatientSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final Color kPrimaryColor = const Color(0xFF00796B); // Deep Teal
  bool _isPasswordVisible = false;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _allergiesController =
  TextEditingController(); // optional

  // Patient type selection (STUDENT / TEACHER / STAFF)
  String _patientType = 'STUDENT';

  // Custom Input Decoration for better look
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kPrimaryColor.withValues(alpha: 0.7)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: kPrimaryColor.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: kPrimaryColor.withValues(alpha: 0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: kPrimaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match!')),
        );
        return;
      }

      // SRS Compliance: Placeholder for actual registration logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registration successful for ${_nameController.text}. Redirecting to Dashboard...',
          ),
        ),
      );

      // Navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PatientDashboard()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _studentIdController.dispose();
    _departmentController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _bloodGroupController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[50], // Light background for contrast
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              // Header
              Text(
                'Create Patient Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Register with your institution details.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 30),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Full Name
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration('Full Name', Icons.person),
                      validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 15),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(
                        'Email Address',
                        Icons.email,
                      ),
                      validator: (value) =>
                      value!.isEmpty || !value.contains('@')
                          ? 'Enter a valid email'
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // Phone Number
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration('Phone Number', Icons.phone),
                      validator: (value) =>
                      value!.isEmpty ? 'Enter phone number' : null,
                    ),
                    const SizedBox(height: 15),

                    // Patient Type dropdown (STUDENT / TEACHER / STAFF)
                    DropdownButtonFormField<String>(
                      value: _patientType,
                      decoration: _inputDecoration(
                        'Patient Type',
                        Icons.person_search,
                      ),
                      items: ['STUDENT', 'TEACHER', 'STAFF']
                          .map(
                            (type) => DropdownMenuItem(
                          value: type,
                          child: Text(
                            type[0] + type.substring(1).toLowerCase(),
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _patientType = val ?? 'STUDENT';
                        });
                      },
                    ),
                    const SizedBox(height: 15),

                    // Student ID (only required & visible when patient type is STUDENT)
                    if (_patientType == 'STUDENT') ...[
                      TextFormField(
                        controller: _studentIdController,
                        keyboardType: TextInputType.text,
                        decoration: _inputDecoration('Student ID', Icons.badge),
                        validator: (value) {
                          if (_patientType == 'STUDENT' &&
                              (value == null || value.isEmpty)) {
                            return 'Enter your Student ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                    ],

                    // Department
                    TextFormField(
                      controller: _departmentController,
                      decoration: _inputDecoration('Department', Icons.school),
                    ),
                    const SizedBox(height: 15),

                    // Blood Group
                    TextFormField(
                      controller: _bloodGroupController,
                      decoration: _inputDecoration(
                        'Blood Group (e.g., O+)',
                        Icons.bloodtype,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Allergies
                    TextFormField(
                      controller: _allergiesController,
                      decoration: _inputDecoration(
                        'Allergies (Optional)',
                        Icons.warning,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: _inputDecoration('Password', Icons.lock)
                          .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: kPrimaryColor.withValues(alpha: 0.7),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) => value!.length < 6
                          ? 'Password must be at least 6 characters'
                          : null,
                    ),
                    const SizedBox(height: 15),

                    // Confirm Password Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_isPasswordVisible,
                      decoration: _inputDecoration(
                        'Confirm Password',
                        Icons.lock_reset,
                      ),
                      validator: (value) {
                        if (value!.isEmpty)
                          return 'Please confirm your password';
                        if (value != _passwordController.text)
                          return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // Sign Up Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'SIGN UP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Already registered?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already Registered?',
                    style: TextStyle(fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const HomePage(), // Assuming HomePage is the login page
                        ),
                      );
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
