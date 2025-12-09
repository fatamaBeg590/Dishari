// lab_test_booking.dart (Updated Code with English text and correct currency symbol)

import 'package:flutter/material.dart';
import 'lab_test_list.dart'; // Assumed LabTest class and labTests list are available from this file

class LabTestBooking extends StatefulWidget {
  final String patientId;
  final String patientType;

  const LabTestBooking({
    super.key,
    required this.patientId,
    required this.patientType,
  });

  @override
  State<LabTestBooking> createState() => _LabTestBookingState();
}

class _LabTestBookingState extends State<LabTestBooking> {
  final List<LabTest> _selectedTests = [];
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    // Pre-populate with a single test for demo purposes if needed
    // _toggleTestSelection(labTests.first);
  }

  void _toggleTestSelection(LabTest test) {
    setState(() {
      if (_selectedTests.contains(test)) {
        _selectedTests.remove(test);
      } else {
        _selectedTests.add(test);
      }
      _calculateTotal();
    });
  }

  void _calculateTotal() {
    _totalAmount = 0.0;
    for (var test in _selectedTests) {
      _totalAmount += test.getFee(widget.patientType);
    }
  }

  void _proceedToPayment() {
    if (_selectedTests.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one test')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirm Booking"),
          content: Text(
            "Booking ${_selectedTests.length} tests for Patient ID: ${widget.patientId} (Type: ${widget.patientType}).\n\nTotal Fee: ৳${_totalAmount.toStringAsFixed(2)}",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _confirmBooking();
              },
              child: const Text('Confirm & Pay'),
            ),
          ],
        );
      },
    );
  }

  void _confirmBooking() {

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Booking successful! Total ৳${_totalAmount.toStringAsFixed(2)} booked for ${widget.patientId}.'),
      ),
    );

    Navigator.pop(context, true);
    Navigator.pop(context, true);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Lab Tests'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Patient Info Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patient ID:',
                        style: TextStyle(
                            fontSize: 12, color: Colors.blue.shade800),
                      ),
                      Text(
                        widget.patientId,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                _buildFeeChip(
                    'Type', 0, true), // Placeholder chip for patient type
                _buildFeeChip(
                    widget.patientType.toUpperCase(),
                    // Pass a dummy fee to show the type
                    widget.patientType == 'student'
                        ? 0
                        : widget.patientType == 'employee'
                        ? 0
                        : 0,
                    true),
              ],
            ),
          ),

          // List of available tests
          Expanded(
            child: ListView.builder(
              itemCount: labTests.length,
              itemBuilder: (context, index) {
                final test = labTests[index];
                final isSelected = _selectedTests.contains(test);
                final fee = test.getFee(widget.patientType);

                return Card(
                  elevation: isSelected ? 4 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? Colors.blue.shade100
                          : Colors.grey.shade100,
                      child: Icon(
                        Icons.medical_services_outlined,
                        color: isSelected ? Colors.blue.shade700 : Colors.grey,
                      ),
                    ),
                    title: Text(
                      test.testName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.blue.shade800 : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      test.description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '৳${fee.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.blue.shade700
                                : Colors.green.shade700,
                          ),
                        ),
                        if (isSelected)
                          const Text(
                            'Selected',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    onTap: () => _toggleTestSelection(test),
                  ),
                );
              },
            ),
          ),

          // Bottom Action Button
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _proceedToPayment,
                icon: const Icon(Icons.shopping_cart),
                label: Text(
                    'Book (${_selectedTests.length}) | Total Fee: ৳${_totalAmount.toStringAsFixed(2)}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget to display fee types as chips
  Widget _buildFeeChip(String label, double amount, bool isActive) {
    return Chip(
      // Corrected the currency symbol and formatting
      label: Text(
        amount > 0 ? '$label: ৳${amount.toStringAsFixed(0)}' : label,
      ),
      backgroundColor: isActive ? Colors.blue.shade100 : Colors.grey.shade200,
      labelStyle: TextStyle(
        fontSize: 10,
        color: isActive ? Colors.blue.shade800 : Colors.grey.shade600,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      ),
      padding: const EdgeInsets.all(0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
