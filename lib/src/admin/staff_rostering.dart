import 'package:flutter/material.dart';

class StaffRostering extends StatefulWidget {
  const StaffRostering({super.key});

  @override
  State<StaffRostering> createState() => _StaffRosteringState();
}

class _StaffRosteringState extends State<StaffRostering> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Color primaryColor = const Color(0xFF00796B); // Deep Teal
  bool _isCurrentWeek = true; // State to track which week is active

  // Dummy data: Roster for Current Week
  final List<Map<String, String>> _currentWeekRoster = [
    {"day": "Monday", "role_1": "Dr. Nasir", "role_2": "Rasid"},
    {"day": "Tuesday", "role_1": "Dr. Habiba Sultana", "role_2": "Sara Islam"},
    {"day": "Wednesday", "role_1": "Dr. Rakib", "role_2": "Mina (Reception)"},
    {"day": "Thursday", "role_1": "Dr. Ezaz", "role_2": "Wakil"},
    {"day": "Friday", "role_1": "Dr. Ahmed ", "role_2": "Maya"},
  ];

  // Dummy data: Roster for Next Week (Initially empty or copied from current)
  List<Map<String, String>> _nextWeekRoster = [
    {"day": "Monday", "role_1": "N/A", "role_2": "N/A"},
    {"day": "Tuesday", "role_1": "N/A", "role_2": "N/A"},
    {"day": "Wednesday", "role_1": "N/A", "role_2": "N/A"},
    {"day": "Thursday", "role_1": "N/A", "role_2": "N/A"},
    {"day": "Friday", "role_1": "N/A", "role_2": "N/A"},
  ];

  // Dummy Requests (SRS requirement: Approval for duty changes)
  List<Map<String, String>> requests = [
    {"name": "Dr. Sara Islam", "reason": "Family Emergency", "day": "Tuesday"},
    {"name": "Habiba Sultana", "reason": "Medical Leave", "day": "Tuesday"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Actions ---

  // Request Approval (No Change)
  void _handleRequest(Map<String, String> req, bool approve) {
    setState(() {
      requests.remove(req);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "${req['name']} request for ${req['day']} has been ${approve ? 'approved' : 'rejected'}"),
        backgroundColor: approve ? Colors.green : Colors.red,
      ),
    );
  }

  // // Next Week Roster Creation/Modification (New Functionality)
  // void _scheduleNextWeek() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text("Schedule Next Week Roster", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
  //       content: const Text("Would you like to copy the Current Week's schedule as a template or start fresh?"),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             // Option 1: Start Fresh (Leave as N/A) - Already in _nextWeekRoster default
  //             Navigator.pop(context);
  //             _openRosterEditor(_nextWeekRoster, isNewSchedule: true);
  //           },
  //           child: const Text("Start Fresh"),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Option 2: Copy Current Week as Template
  //             setState(() {
  //               _nextWeekRoster = List.from(_currentWeekRoster.map((e) => Map.from(e)));
  //               _isCurrentWeek = false; // Automatically switch to next week view
  //             });
  //             Navigator.pop(context);
  //             _openRosterEditor(_nextWeekRoster, isNewSchedule: true);
  //           },
  //           style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
  //           child: const Text("Copy Current Week", style: TextStyle(color: Colors.white)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Conflict Simulation (Simulated SRS Requirement)
  bool _checkConflict(String staffName, List<Map<String, String>> roster) {
    // Dummy check: If the staff name appears twice in the same roster, it's a conflict.
    // In a real system, this would check against staff availability for each day/shift.
    int count = 0;
    for (var dayRoster in roster) {
      if (dayRoster['role_1']!.contains(staffName) || dayRoster['role_2']!.contains(staffName)) {
        count++;
      }
    }
    return count > 1; // Simple example: check if they are scheduled more than once in the whole week.
  }

  // New: Roster Editor Dialog
  // Editable Roster Editor Dialog
  void _openRosterEditor(List<Map<String, String>> roster, {required bool isNewSchedule}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          isNewSchedule ? "Edit Next Week Schedule" : "Edit Current Week Schedule",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: roster.length,
            itemBuilder: (context, index) {
              final dayRoster = roster[index];
              // Text controllers for each role
              final TextEditingController role1Controller =
              TextEditingController(text: dayRoster['role_1']);
              final TextEditingController role2Controller =
              TextEditingController(text: dayRoster['role_2']);

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 1,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dayRoster['day']!,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      TextField(
                        controller: role1Controller,
                        decoration: const InputDecoration(
                          labelText: "Doctor / Staff (Day Shift)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: role2Controller,
                        decoration: const InputDecoration(
                          labelText: "Doctor / Staff (Night Shift)",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          icon: const Icon(Icons.save, color: Colors.white, size: 18),
                          label: const Text("Save Day", style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            setState(() {
                              dayRoster['role_1'] = role1Controller.text;
                              dayRoster['role_2'] = role2Controller.text;
                            });

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "${dayRoster['day']} updated successfully ✅"),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Conflict check
                            if (_checkConflict(role1Controller.text, roster)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "⚠️ CONFLICT DETECTED: Staff is overscheduled!",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }


  // --- Widgets ---

  Widget _buildWeekToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ToggleButtons(
        isSelected: [_isCurrentWeek, !_isCurrentWeek],
        onPressed: (index) {
          setState(() {
            _isCurrentWeek = index == 0;
          });
        },
        constraints: BoxConstraints.expand(width: (MediaQuery.of(context).size.width - 32) / 2, height: 40),
        color: primaryColor,
        selectedColor: Colors.white,
        fillColor: primaryColor,
        borderRadius: BorderRadius.circular(10),
        borderWidth: 0,
        borderColor: Colors.transparent,
        children: const [
          Text("Current Week", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("Next Week", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRosterView() {
    final activeRoster = _isCurrentWeek ? _currentWeekRoster : _nextWeekRoster;
    return ListView.builder(
      itemCount: activeRoster.length,
      itemBuilder: (context, index) {
        final dayRoster = activeRoster[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dayRoster['day']!,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.person, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(dayRoster['role_1']!, style: const TextStyle(fontSize: 15)),
                    ),
                    const VerticalDivider(),
                    const Icon(Icons.person_pin, color: Colors.blueGrey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(dayRoster['role_2']!, style: const TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestsView() {
    if (requests.isEmpty) {
      return Center(child: Text("✅ No Pending Leave/Shift Requests.", style: TextStyle(color: primaryColor)));
    }
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final req = requests[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: const Icon(Icons.pending_actions, color: Colors.orange),
            title: Text(req['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
                "Day: ${req['day']}\nReason: ${req['reason']}"),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () {
                    _handleRequest(req, true);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () {
                    _handleRequest(req, false);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- Main Build ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. Week Selector
          _buildWeekToggle(),

          // 2. TabBar
          PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TabBar(
              controller: _tabController,
              labelColor: primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: primaryColor,
              tabs: const [
                Tab(text: "Roster View", icon: Icon(Icons.calendar_view_week)),
                Tab(text: "Requests", icon: Icon(Icons.list_alt)),
              ],
            ),
          ),

          // 3. TabBarView
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildRosterView(),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildRequestsView(),
                ),
              ],
            ),
          ),
        ],
      ),

        // Floating Action Button for Roster Management
        floatingActionButton: Builder(
          builder: (context) {
            if (_isCurrentWeek) {
              // 🟢 Current Week Editing Button
              return FloatingActionButton.extended(
                onPressed: () => _openRosterEditor(_currentWeekRoster, isNewSchedule: false),
                label: const Text("Edit Current Week Roster", style: TextStyle(color: Colors.white)),
                icon: const Icon(Icons.edit_calendar, color: Colors.white),
                backgroundColor: Colors.teal, // or use primaryColor
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              );
            } else {
              // 🟠 Next Week Editing Button
              return FloatingActionButton.extended(
                onPressed: () => _openRosterEditor(_nextWeekRoster, isNewSchedule: true),
                label: const Text("Edit Next Week Roster", style: TextStyle(color: Colors.white)),
                icon: const Icon(Icons.edit_calendar, color: Colors.white),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              );
            }
          },
        ),
    );
  }
}