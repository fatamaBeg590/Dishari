import 'package:flutter/material.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    double responsiveWidth(double w) => width * w / 375;
    double responsiveHeight(double h) => height * h / 812;

    // Replace dummy notifications with dynamic data (example)
    final List<Map<String, dynamic>> notifications = [
      // This should be fetched from backend or local storage
      {
        "icon": Icons.medical_services,
        "title": "Prescription Reminder",
        "subtitle": "Time to see your updated prescription."
      },
      {
        "icon": Icons.science,
        "title": "Lab Report Result",
        "subtitle": "Your latest test results are in."
      },
    ];

    Widget buildActionCard({
      required IconData icon,
      required String label,
      required VoidCallback onTap,
      Color startColor = Colors.greenAccent,
      Color endColor = Colors.green,
      double width = 0,
    }) {
      return TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadowColor: Colors.black26,
          elevation: 4,
        ),
        onPressed: onTap,
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 22),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [startColor.withOpacity(0.8), endColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: endColor.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, size: 28, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(responsiveWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: responsiveHeight(20)),

              // Avatar + Info
              Center(
                child: Column(
                  children: [
                    Container(
                      width: responsiveWidth(100),
                      height: responsiveWidth(100),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.grey[300]!, Colors.grey[400]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person,
                          size: 50, color: Colors.black54),
                    ),
                    SizedBox(height: responsiveHeight(14)),
                    const Text(
                      "Welcome, Sabbir!",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: responsiveHeight(4)),
                    const Text(
                      "Your Student ID: ASH2225005M",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: responsiveHeight(24)),

              // Notifications
              const Text(
                "Notifications",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: responsiveHeight(12)),

              Column(
                children: notifications.map((notif) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(notif["icon"], color: Colors.green, size: 28),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notif["title"],
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  notif["subtitle"],
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 16, color: Colors.black38),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              SizedBox(height: responsiveHeight(28)),

              // Quick Actions
              const Text(
                "Quick Actions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: responsiveHeight(12)),

              LayoutBuilder(
                builder: (context, constraints) {
                  double itemWidth =
                      (constraints.maxWidth - responsiveWidth(16)) / 2;

                  return Wrap(
                    spacing: responsiveWidth(16),
                    runSpacing: responsiveHeight(16),
                    children: [
                      buildActionCard(
                        icon: Icons.person,
                        label: "Profile",
                        onTap: () {
                          Navigator.pushNamed(context, '/patient-profile');
                        },
                        width: itemWidth,
                      ),
                      buildActionCard(
                        icon: Icons.medication,
                        label: "Prescriptions",
                        onTap: () {
                          Navigator.pushNamed(context, '/patient-prescriptions');
                        },
                        width: itemWidth,
                      ),
                      buildActionCard(
                        icon: Icons.description,
                        label: "My Reports",
                        onTap: () {
                          Navigator.pushNamed(context, '/patient-reports');
                        },
                        width: itemWidth,
                      ),
                      buildActionCard(
                        icon: Icons.upload_file,
                        label: "Upload Results",
                        onTap: () {
                          Navigator.pushNamed(context, '/patient-report-upload');
                        },
                        width: itemWidth,
                        startColor: Colors.blueAccent,
                        endColor: Colors.blue,
                      ),
                      buildActionCard(
                        icon: Icons.science_outlined,
                        label: "Lab Test Availability",
                        onTap: () {
                          Navigator.pushNamed(context, '/patient-lab-availability');
                        },
                        width: itemWidth,
                        startColor: Colors.tealAccent,
                        endColor: Colors.teal,
                      ),
                      buildActionCard(
                        icon: Icons.local_hospital,
                        label: "See Ambulance & Staff",
                        onTap: () {
                          Navigator.pushNamed(context, '/patient-ambulance-staff');
                        },
                        width: itemWidth,
                        startColor: Colors.orangeAccent,
                        endColor: Colors.deepOrange,
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: responsiveHeight(20)),
            ],
          ),
        ),
      ),
    );
  }
}
