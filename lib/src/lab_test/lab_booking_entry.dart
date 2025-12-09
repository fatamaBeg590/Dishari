import 'package:flutter/material.dart';
import 'lab_test_booking.dart';

class PatientBookingEntry extends StatefulWidget {
  const PatientBookingEntry({super.key});

  @override
  State<PatientBookingEntry> createState() => _PatientBookingEntryState();
}

class _PatientBookingEntryState extends State<PatientBookingEntry> {
  final TextEditingController _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void _navigateToBooking(String patientId, String patientType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LabTestBooking(
          patientId: patientId,
          patientType: patientType,
        ),
      ),
    );
  }

  void _searchRegisteredPatient() {
    final patientId = _idController.text.trim();
    if (patientId.isEmpty) {
      _showSnackBar("Please enter a Patient ID");
      return;
    }

    String type;
    if (patientId.toUpperCase().startsWith('STU')) {
      type = 'student';
    } else if (patientId.toUpperCase().startsWith('EMP')) {
      type = 'employee';
    } else if (patientId.toUpperCase().startsWith('OUT')) {
      type = 'out_patient';
    } else {
      _showSnackBar("Unknown ID prefix! Please enter correct ID or use Walk-in.");
      return;
    }

    _navigateToBooking(patientId, type);
  }

  void _showWalkInDialog(String type) {
    String labelText = type == 'student' ? 'Student ID or Email' :
    type == 'employee' ? 'Employee ID or Email' :
    'Out Patient Name or Phone Number';

    String hintText = type == 'student' ? 'e.g., 2024001 or name@nstu.edu.bd' :
    type == 'employee' ? 'e.g., EMP123 or employee@nstu.edu.bd' :
    'e.g., John Doe or 017xxxxxxxx';

    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter ${type.toUpperCase()} Details'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final walkInId = controller.text.trim();
              if (walkInId.isEmpty) {
                _showSnackBar("Please enter valid ${type == 'out_patient' ? 'Name/Number' : 'ID/Email'}");
                return;
              }
              Navigator.pop(context);
              _navigateToBooking("WALKIN:$walkInId", type);
            },
            child: const Text('Start Booking'),
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Booking',),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // --- Section title (was _buildSection) ---
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '1. Search Registered Patient',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // --- Card for registered patient search ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text("Enter Patient ID (STU, EMP, or OUT prefix):"),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        labelText: 'Patient ID',
                        hintText: 'Example: STU2024001',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: _searchRegisteredPatient,
                      icon: const Icon(Icons.search),
                      label: const Text('Search and Start Booking'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 30),

            // --- Section title (was _buildSection) ---
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                '2. Walk-in Booking',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // --- Card for walk-in patient ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Select Patient Type for walk-in booking:"),
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      children: [

                        // --- Button (was _buildTypeButton) ---
                        ElevatedButton(
                          onPressed: () => _showWalkInDialog('student'),
                          child: const Text('Student'),
                        ),

                        // --- Button (was _buildTypeButton) ---
                        ElevatedButton(
                          onPressed: () => _showWalkInDialog('employee'),
                          child: const Text('Employee'),
                        ),

                        // --- Button (was _buildTypeButton) ---
                        ElevatedButton(
                          onPressed: () => _showWalkInDialog('out_patient'),
                          child: const Text('Out Patient'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
