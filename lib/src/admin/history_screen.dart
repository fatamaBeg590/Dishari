import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  final Color primaryColor = const Color(0xFF00796B); // Deep Teal

  // Sample history data with an action type for better icons
  final List<Map<String, dynamic>> historyItems = const [
    {
      "timestamp": "2025-09-01 09:21",
      "user": "Dr. Barsha Islam",
      "action": "Updated prescription #45622",
      "type": "update"
    },
    {
      "timestamp": "2025-09-01 08:10",
      "user": "Dispenser Sumon",
      "action": "Adjusted stock for Insulin (-3 Vials)",
      "type": "stock_out"
    },
    {
      "timestamp": "2025-08-31 14:35",
      "user": "Dr. Hasan Khan",
      "action": "Added new prescription #45621",
      "type": "create"
    },
    {
      "timestamp": "2025-08-31 11:50",
      "user": "Admin User",
      "action": "Restocked Paracetamol (+500 Tablets)",
      "type": "stock_in"
    },
    {
      "timestamp": "2025-08-30 10:00",
      "user": "Admin User",
      "action": "Approved Dr. Kim's leave request for Tuesday",
      "type": "admin_action"
    },
  ];

  IconData _getActionIcon(String type) {
    switch (type) {
      case 'create':
        return Icons.add_circle;
      case 'update':
        return Icons.edit_note;
      case 'stock_in':
        return Icons.arrow_circle_up;
      case 'stock_out':
        return Icons.arrow_circle_down;
      case 'admin_action':
        return Icons.verified_user;
      default:
        return Icons.history;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'create':
        return Colors.green;
      case 'update':
        return Colors.blue;
      case 'stock_in':
        return Colors.lightGreen;
      case 'stock_out':
        return Colors.red;
      case 'admin_action':
        return primaryColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historyItems.length,
        itemBuilder: (context, index) {
          final item = historyItems[index];
          final type = item['type'] as String;
          final icon = _getActionIcon(type);
          final color = _getIconColor(type);

          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color),
              ),
              title: Text(
                item['user'] as String, // User who made the change
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    item['action'] as String, // The actual action description
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('yyyy-MM-dd | HH:mm').format(
                        DateTime.parse(item['timestamp'] as String)),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    );
  }
}