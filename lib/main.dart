import 'package:flutter/material.dart';
//admin
import 'package:dishari/src/admin/admin_profile.dart';
import 'package:dishari/src/admin/history_screen.dart';
import 'package:dishari/src/admin/inventory_management.dart';
import 'package:dishari/src/admin/reports_analytics.dart';
import 'package:dishari/src/admin/staff_rostering.dart';
import 'package:dishari/src/admin/user_management.dart';
import 'package:dishari/src/admin/admin_dashboard.dart';
//doctor
import 'package:dishari/src/doctor/emergency_cases.dart';
import 'package:dishari/src/doctor/patient_records.dart';
import 'package:dishari/src/doctor/doctor_dashboard.dart';
import 'package:dishari/src/doctor/prescription_page.dart';
import 'package:dishari/src/doctor/setting.dart';
import 'package:dishari/src/doctor/doctor_profile.dart';
//lab
import 'package:dishari/src/lab_test/lab_tester_home.dart';

//dispenser
import 'package:dishari/src/dispenser/dispenser_dashboard.dart';
import 'package:dishari/src/dispenser/dispenser_profile.dart';
//patient
import 'package:dishari/src/patient/patient_dashboard.dart';
import 'package:dishari/src/patient/patient_profile.dart';
import 'package:dishari/src/patient/patient_prescriptions.dart';
import 'package:dishari/src/patient/patient_report.dart';
import 'package:dishari/src/patient/patient_report_upload.dart';
import 'package:dishari/src/patient/patient_lab_test_availability.dart';
import 'package:dishari/src/patient/patient_ambulance_staff.dart';
import 'package:dishari/src/patient/patient_signup.dart';
//login
import 'package:dishari/src/universal_login.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical Center Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,

      ),
      initialRoute: '/',
      routes: {
        //roots
        '/': (context) => const HomePage(),
        //admin routes
        '/admin-dashboard': (context) => const AdminDashboard(),
        '/admin-profile': (context) => const AdminProfile(),
        '/admin-user-management': (context) => const UserManagement(),
        '/admin-inventory-management': (context) => const InventoryManagement(),
        '/admin-reports-analytics': (context) => const ReportsAnalytics(),
        '/admin-history': (context) => const HistoryScreen(),
        '/admin-staff-rostering': (context) => const StaffRostering(),
        //doctor routes
        '/doctor-dashboard': (context) => const DoctorDashboard(),
        '/doctor-profile': (context) => const ProfilePage(),
        '/Doctor-patient-record': (context) => const PatientRecordsPage(),
        '/Doctor-emergency-cases': (context) => const EmergencyCasesPage(),
        '/Doctor-prescription-template': (context) => const PrescriptionPage(),
        '/doctor-setting': (context) => const Setting(),

        //dispenser routes
        '/dispenser-dashboard': (context) => const DispenserDashboard(),
        '/dispenser-profile': (context) => const DispenserProfile(),
        //lab tester routes
        '/lab-dashboard': (context) => const LabTesterHome(),

        //patient routes
        '/patient-dashboard': (context) => const PatientDashboard(),
        '/patient-profile': (context) => const PatientProfilePage(),
        '/patient-prescriptions': (context) => const PatientPrescriptions(),
        '/patient-reports': (context) => const PatientReports(),
        '/patient-report-upload': (context) => const PatientReportUpload(),
        '/patient-lab-availability': (context) => const PatientLabTestAvailability(),
        '/patient-ambulance-staff': (context) => const PatientAmbulanceStaff(),
        '/patient-signup': (context) => const PatientSignupPage(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text("Page not found"),),
        ),
      ),
    );
  }
}