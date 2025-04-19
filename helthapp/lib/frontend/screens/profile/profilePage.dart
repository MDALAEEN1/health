import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الملف الشخصي"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Profile Header
          _buildProfileHeader(),

          SizedBox(height: 16),

          // Personal Information
          _buildSectionHeader("المعلومات الشخصية"),
          _buildProfileItem(
            icon: Icons.person_outline,
            title: "الاسم الكامل",
            value: "أحمد محمد",
          ),
          _buildProfileItem(
            icon: Icons.email_outlined,
            title: "البريد الإلكتروني",
            value: "ahmed@example.com",
          ),
          _buildProfileItem(
            icon: Icons.phone_outlined,
            title: "رقم الهاتف",
            value: "+966 123 456 789",
          ),

          // Insurance Information
          _buildSectionHeader("معلومات التأمين"),
          _buildProfileItem(
            icon: Icons.card_membership_outlined,
            title: "نوع التأمين",
            value: "طبي شامل",
          ),
          _buildProfileItem(
            icon: Icons.date_range_outlined,
            title: "تاريخ انتهاء التأمين",
            value: "12/2025",
          ),

          // Actions
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              // Navigate to edit profile page
            },
            icon: Icon(Icons.edit),
            label: Text("تعديل الملف الشخصي"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                NetworkImage("https://example.com/path/to/profile/image.jpg"),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            "أحمد محمد",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "ahmed@example.com",
            style: TextStyle(fontSize: 16, color: Colors.grey),
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

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(fontSize: 16)),
      subtitle: Text(value, style: TextStyle(fontSize: 14, color: Colors.grey)),
    );
  }
}
