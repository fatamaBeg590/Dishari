import 'package:flutter/material.dart';

class ChangeRequestRostering extends StatefulWidget {
  final String userRole; // 'doctor', 'lab_staff', 'dispenser'
  final String userName;

  const ChangeRequestRostering({
    super.key,
    required this.userRole,
    required this.userName,
  });

  @override
  State<ChangeRequestRostering> createState() => _ChangeRequestRosteringState();
}

class _ChangeRequestRosteringState extends State<ChangeRequestRostering> {
  List<Map<String, dynamic>> _shifts = [];
  List<Map<String, dynamic>> _shiftChangeRequests = [];

  @override
  void initState() {
    super.initState();
    _initializeShifts();
  }

  void _initializeShifts() {
    _shifts = [
      {
        'id': '1',
        'type': 'Morning',
        'time': '9:00 AM - 3:00 PM',
        'date': '2024-01-20',
        'assignedStaff': widget.userName,
        'staffRole': widget.userRole,
        'status': 'scheduled',
      },
      {
        'id': '2',
        'type': 'Afternoon',
        'time': '3:00 PM - 9:00 PM',
        'date': '2024-01-21',
        'assignedStaff': widget.userName,
        'staffRole': widget.userRole,
        'status': 'scheduled',
      },
      {
        'id': '3',
        'type': 'Night',
        'time': '9:00 PM - 9:00 AM',
        'date': '2024-01-22',
        'assignedStaff': widget.userName,
        'staffRole': widget.userRole,
        'status': 'confirmed',
      },
    ];

    _shiftChangeRequests = [
      {
        'shiftId': '1',
        'shiftType': 'Morning',
        'shiftDate': '2024-01-20',
        'staffName': widget.userName,
        'staffRole': widget.userRole,
        'reason': 'Family emergency',
        'requestDate': '2024-01-18',
        'status': 'pending',
      },
    ];
  }

  void _requestShiftChange(String shiftId, String reason) {
    final shift = _shifts.firstWhere((s) => s['id'] == shiftId);

    setState(() {
      _shiftChangeRequests.add({
        'shiftId': shiftId,
        'shiftType': shift['type'],
        'shiftDate': shift['date'],
        'staffName': widget.userName,
        'staffRole': widget.userRole,
        'reason': reason,
        'requestDate': DateTime.now().toString().split(' ')[0],
        'status': 'pending',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Shift change request submitted for admin approval'),
      ),
    );
  }

  void _showShiftChangeDialog(Map<String, dynamic> shift) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Shift Change'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Role: ${_getRoleDisplayName(widget.userRole)}'),
            Text('Shift: ${shift['type']}'),
            Text('Date: ${shift['date']}'),
            Text('Time: ${shift['time']}'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for change',
                border: OutlineInputBorder(),
                hintText:
                'Please provide a valid reason for shift change...',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                _requestShiftChange(shift['id'], reasonController.text);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please provide a reason')),
                );
              }
            },
            child: const Text('Submit Request'),
          ),
        ],
      ),
    );
  }

  String _getRoleDisplayName(String role) {
    switch (role) {
      case 'doctor':
        return 'Doctor';
      case 'lab_staff':
        return 'Lab Staff';
      case 'dispenser':
        return 'Dispenser';
      default:
        return 'Staff';
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'doctor':
        return Colors.blue;
      case 'lab_staff':
        return Colors.green;
      case 'dispenser':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'doctor':
        return Icons.medical_services;
      case 'lab_staff':
        return Icons.science;
      case 'dispenser':
        return Icons.medication;
      default:
        return Icons.person;
    }
  }

  Color _getShiftColor(String shiftType) {
    switch (shiftType) {
      case 'Morning':
        return Colors.orange.shade100;
      case 'Afternoon':
        return Colors.blue.shade100;
      case 'Night':
        return Colors.purple.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'scheduled':
        return Colors.blue.shade100;
      case 'confirmed':
        return Colors.green.shade100;
      case 'cancelled':
        return Colors.red.shade100;
      case 'completed':
        return Colors.grey.shade300;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _getRequestStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getRequestStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.pending;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_getRoleDisplayName(widget.userRole)} Schedule'),
        foregroundColor: _getRoleColor(widget.userRole),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Material(
              color: _getRoleColor(widget.userRole).withOpacity(0.1),
              child: TabBar(
                labelColor: _getRoleColor(widget.userRole),
                unselectedLabelColor: Colors.grey,
                indicatorColor: _getRoleColor(widget.userRole),
                tabs: const [
                  Tab(icon: Icon(Icons.schedule), text: 'My Schedule'),
                  Tab(icon: Icon(Icons.pending_actions), text: 'My Requests'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // My Schedule Tab
                  _shifts.isEmpty
                      ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No shifts assigned',
                          style:
                          TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: _shifts.length,
                    itemBuilder: (context, index) {
                      final shift = _shifts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getShiftColor(shift['type']),
                            child: Icon(
                              _getRoleIcon(widget.userRole),
                              color: _getRoleColor(widget.userRole),
                            ),
                          ),
                          title: Text(
                            '${shift['type']} Shift',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date: ${shift['date']}'),
                              Text('Time: ${shift['time']}'),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      shift['status']
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _getStatusColor(
                                            shift['status'])
                                            .computeLuminance() >
                                            0.5
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    backgroundColor:
                                    _getStatusColor(shift['status']),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(
                                      _getRoleDisplayName(widget.userRole),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    backgroundColor: _getRoleColor(
                                        widget.userRole)
                                        .withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: shift['status'] == 'scheduled'
                              ? IconButton(
                            icon: Icon(Icons.edit,
                                color: _getRoleColor(widget.userRole)),
                            onPressed: () =>
                                _showShiftChangeDialog(shift),
                          )
                              : null,
                        ),
                      );
                    },
                  ),

                  // My Requests Tab
                  _shiftChangeRequests.isEmpty
                      ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pending_actions,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No shift change requests',
                          style:
                          TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: _shiftChangeRequests.length,
                    itemBuilder: (context, index) {
                      final request = _shiftChangeRequests[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                            _getRequestStatusColor(request['status']),
                            child: Icon(
                              _getRequestStatusIcon(request['status']),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            '${request['shiftType']} Shift - ${request['shiftDate']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Reason: ${request['reason']}'),
                              Text('Requested: ${request['requestDate']}'),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      request['status']
                                          .toString()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white),
                                    ),
                                    backgroundColor:
                                    _getRequestStatusColor(
                                        request['status']),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(
                                      _getRoleDisplayName(widget.userRole),
                                      style:
                                      const TextStyle(fontSize: 12),
                                    ),
                                    backgroundColor: _getRoleColor(
                                        widget.userRole)
                                        .withOpacity(0.2),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
