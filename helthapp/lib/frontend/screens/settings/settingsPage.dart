import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الإعدادات"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Account Settings
          _buildSectionHeader("إعدادات الحساب"),
          _buildSettingsItem(
            icon: Icons.person_outline,
            title: "تحديث المعلومات الشخصية",
            onTap: () {
              // Navigate to update personal information page
            },
          ),
          _buildSettingsItem(
            icon: Icons.lock_outline,
            title: "تغيير كلمة المرور",
            onTap: () {
              // Navigate to change password page
            },
          ),

          // Notifications
          _buildSectionHeader("الإشعارات"),
          _buildSettingsItem(
            icon: Icons.notifications_outlined,
            title: "إعدادات الإشعارات",
            onTap: () {
              // Navigate to notification settings page
            },
          ),

          // Insurance Settings
          _buildSectionHeader("إعدادات التأمين"),
          _buildSettingsItem(
            icon: Icons.card_membership_outlined,
            title: "إدارة بطاقات التأمين",
            onTap: () {
              // Navigate to manage insurance cards page
            },
          ),
          _buildSettingsItem(
            icon: Icons.history_outlined,
            title: "سجل المطالبات",
            onTap: () {
              // Navigate to claims history page
            },
          ),

          // Appointment Settings
          _buildSectionHeader("إعدادات المواعيد"),
          _buildSettingsItem(
            icon: Icons.calendar_today_outlined,
            title: "إدارة المواعيد",
            onTap: () {
              // Navigate to manage appointments page
            },
          ),
          _buildSettingsItem(
            icon: Icons.history,
            title: "سجل المواعيد",
            onTap: () {
              // Navigate to appointment history page
            },
          ),

          // General Settings
          _buildSectionHeader("إعدادات عامة"),
          _buildSettingsItem(
            icon: Icons.language_outlined,
            title: "تغيير اللغة",
            onTap: () {
              // Navigate to language settings page
            },
          ),
          _buildSettingsItem(
            icon: Icons.help_outline,
            title: "مساعدة ودعم",
            onTap: () {
              // Navigate to help and support page
            },
          ),
          _buildSettingsItem(
            icon: Icons.info_outline,
            title: "حول التطبيق",
            onTap: () {
              // Navigate to about page
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required Function() onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
