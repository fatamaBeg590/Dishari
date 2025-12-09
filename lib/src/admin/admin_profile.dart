import 'package:flutter/material.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final Color primaryColor = const Color(0xFF00796B); // Deep Teal

  // State variables for Notification Settings (SRS Requirement)
  bool _lowStockAlerts = true;
  bool _rosteringRequestAlerts = true;

  // --- Utility Functions for Actions ---

  void _showChangePasswordDialog() {
    // Simplified dialog for changing password
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(decoration: InputDecoration(labelText: "Current Password", border: OutlineInputBorder()), obscureText: true),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: "New Password",
                border: const OutlineInputBorder(),
                // Example of strong password hint
                hintText: 'Min 8 chars, 1 capital, 1 number',
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password changed successfully! (Dummy Action)")));
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: const Text("Update", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _initiateDatabaseAction(String action) {
    // Dummy action for Database/Logs
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$action initiated... (Dummy Action)")));
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) {
        // StatefulBuilder to manage dialog's internal state (toggles)
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Notification Settings"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text("Inventory Low Stock Alerts"),
                    subtitle: Text(_lowStockAlerts ? "ON" : "OFF"),
                    value: _lowStockAlerts,
                    onChanged: (bool value) {
                      setStateDialog(() {
                        _lowStockAlerts = value; // Update dialog state
                      });
                      setState(() {
                        _lowStockAlerts = value; // Update main widget state
                      });
                    },
                    activeColor: primaryColor,
                  ),
                  SwitchListTile(
                    title: const Text("Staff Rostering Requests"),
                    subtitle: Text(_rosteringRequestAlerts ? "ON" : "OFF"),
                    value: _rosteringRequestAlerts,
                    onChanged: (bool value) {
                      setStateDialog(() {
                        _rosteringRequestAlerts = value; // Update dialog state
                      });
                      setState(() {
                        _rosteringRequestAlerts = value; // Update main widget state
                      });
                    },
                    activeColor: primaryColor,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // Get screen width to calculate 60% for the button
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.6; // 60% of the screen width

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Admin Profile & Settings", style: TextStyle(color: Colors.blueAccent)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // User Info Card
            Center(
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: primaryColor.withOpacity(0.1),
                        child: Icon(Icons.admin_panel_settings, size: 50, color: primaryColor),
                      ),
                      const SizedBox(height: 20),
                      const Text("Admin User",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const Text("admin@healthcare.org",
                          style: TextStyle(fontSize: 16, color: Colors.black54)),
                      const Text("Role: System Administrator", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // System Settings Section
            const Text("System Controls", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const Divider(color: Colors.grey),

            // 1. Notification Settings
            ListTile(
              leading: Icon(Icons.notifications_active, color: Colors.amber.shade700),
              title: const Text("Notification Settings"),
              subtitle: Text(_lowStockAlerts || _rosteringRequestAlerts ? "Active" : "Disabled"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showNotificationSettings,
            ),

            // 2. Change Password
            ListTile(
              leading: Icon(Icons.security, color: primaryColor),
              title: const Text("Change Password"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _showChangePasswordDialog,
            ),

            // 3. Database Backup & Logs
            ListTile(
              leading: const Icon(Icons.data_usage, color: Colors.blue),
              title: const Text("Database Backup & Logs"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _initiateDatabaseAction("Viewing Database Status/Logs"),
            ),
            const Divider(height: 30),

            // Logout (Width set to 60%)
            Center( // Center the button
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                width: buttonWidth, // Set the calculated 60% width
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Implement actual logout logic
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Logged out successfully!")));
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Log Out", style: TextStyle(color: Colors.white, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}