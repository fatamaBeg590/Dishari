import 'package:flutter/material.dart';

class TestResult {
  final String resultId;
  final String bookingId;
  final String patientName;
  final String testName;
  final String status;
  final String? resultValue;
  final String? normalRange;
  final String? attachmentPath;
  final DateTime? resultDate;

  TestResult({
    required this.resultId,
    required this.bookingId,
    required this.patientName,
    required this.testName,
    required this.status,
    this.resultValue,
    this.normalRange,
    this.attachmentPath,
    this.resultDate,
  });
}

class LabTestResults extends StatefulWidget {
  const LabTestResults({super.key});

  @override
  State<LabTestResults> createState() => _LabTestResultsState();
}

class _LabTestResultsState extends State<LabTestResults> {
  final List<TestResult> _testResults = [
    TestResult(
      resultId: "RES001",
      bookingId: "BK001",
      patientName: "Rafi Ahmed",
      testName: "CBC",
      status: "COMPLETED",
      resultValue: "Normal",
      normalRange: "Normal",
      resultDate: DateTime(2024, 1, 15),
    ),
    TestResult(
      resultId: "RES002",
      bookingId: "BK002",
      patientName: "Maya Rahman",
      testName: "Blood Glucose",
      status: "PENDING",
    ),
    TestResult(
      resultId: "RES003",
      bookingId: "BK003",
      patientName: "Barsha Khan",
      testName: "Lipid Profile",
      status: "COMPLETED",
      resultValue: "CHO: 180 mg/dL\nTG: 150 mg/dL",
      normalRange: "CHO: <200 mg/dL\nTG: <150 mg/dL",
      resultDate: DateTime(2024, 1, 14),
    ),
  ];

  final TextEditingController _resultController = TextEditingController();
  final TextEditingController _rangeController = TextEditingController();

  void _uploadResult(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Upload Test Result'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Patient: ${_testResults[index].patientName}'),
              Text('Test: ${_testResults[index].testName}'),
              const SizedBox(height: 16),
              TextFormField(
                controller: _resultController,
                decoration: const InputDecoration(
                  labelText: 'Result Value',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _rangeController,
                decoration: const InputDecoration(
                  labelText: 'Normal Range',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Or upload file:'),
              ElevatedButton.icon(
                onPressed: () => _selectFile(),
                icon: const Icon(Icons.attach_file),
                label: const Text('Choose File'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resultController.clear();
              _rangeController.clear();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveResult(index);
              Navigator.pop(context);
            },
            child: const Text('Save Result'),
          ),
        ],
      ),
    );
  }

  void _selectFile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File selection would be implemented here')),
    );
  }

  void _saveResult(int index) {
    setState(() {
      _testResults[index] = TestResult(
        resultId: _testResults[index].resultId,
        bookingId: _testResults[index].bookingId,
        patientName: _testResults[index].patientName,
        testName: _testResults[index].testName,
        status: "COMPLETED",
        resultValue: _resultController.text,
        normalRange: _rangeController.text,
        resultDate: DateTime.now(),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Result for ${_testResults[index].testName} uploaded successfully'),
        backgroundColor: Colors.green,
      ),
    );

    _resultController.clear();
    _rangeController.clear();
  }

  void _viewResultDetails(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${_testResults[index].testName} Result'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Patient: ${_testResults[index].patientName}'),
              Text('Booking ID: ${_testResults[index].bookingId}'),
              const SizedBox(height: 16),
              if (_testResults[index].resultValue != null) ...[
                const Text('Result:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_testResults[index].resultValue!),
                const SizedBox(height: 8),
                const Text('Normal Range:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(_testResults[index].normalRange ?? 'N/A'),
                const SizedBox(height: 8),
                Text('Date: ${_testResults[index].resultDate?.toString().split(' ')[0] ?? 'N/A'}'),
              ] else ...[
                const Text('Result pending...', style: TextStyle(color: Colors.orange)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (_testResults[index].status == "PENDING")
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _uploadResult(index);
              },
              child: const Text('Upload Result'),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "COMPLETED":
        return Colors.green;
      case "PENDING":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results Management'),
        backgroundColor: Colors.blue.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _testResults.length,
        itemBuilder: (context, index) {
          final result = _testResults[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getStatusColor(result.status).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  result.status == "COMPLETED" ? Icons.task_alt : Icons.pending,
                  color: _getStatusColor(result.status),
                ),
              ),
              title: Text(result.testName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Patient: ${result.patientName}'),
                  Text('Status: ${result.status}'),
                  if (result.resultDate != null)
                    Text('Date: ${result.resultDate!.toString().split(' ')[0]}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (result.status == "PENDING")
                    IconButton(
                      icon: const Icon(Icons.upload, color: Colors.blue),
                      onPressed: () => _uploadResult(index),
                    ),
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.green),
                    onPressed: () => _viewResultDetails(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTest(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Results'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Results'),
              leading: Radio<String>(
                value: 'all',
                groupValue: 'all',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('Pending Only'),
              leading: Radio<String>(
                value: 'pending',
                groupValue: 'all',
                onChanged: (value) {},
              ),
            ),
            ListTile(
              title: const Text('Completed Only'),
              leading: Radio<String>(
                value: 'completed',
                groupValue: 'all',
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _addNewTest() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add new test functionality would be implemented here')),
    );
  }
}