import 'package:flutter/material.dart';
import 'package:helthapp/frontend/screens/profile/profilePage.dart';
import 'package:helthapp/frontend/screens/subscribe/subscribe.dart';
import 'package:helthapp/frontend/screens/settings/settingsPage.dart';
import 'package:helthapp/frontend/screens/appointments/appointmentsPage.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              "أحمد محمد",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              "ahmed@example.com",
              style: TextStyle(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              backgroundImage:
                  NetworkImage("https://example.com/path/to/profile/image.jpg"),
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.blue,
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue[700]!, Colors.blue[400]!],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  title: "الملف الشخصي",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
                _buildDrawerItem(
                    icon: Icons.subscript,
                    title: "الاشتراكات",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PricingPlansPage()),
                      );
                    }),
                _buildDrawerItem(
                  icon: Icons.calendar_today_outlined,
                  title: "المواعيد",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppointmentsPage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: "الإعدادات",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(height: 1),
                ),
                _buildDrawerItem(
                  icon: Icons.exit_to_app,
                  title: "تسجيل الخروج",
                  onTap: () => _handleLogout(context),
                  textColor: Colors.red,
                  iconColor: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required Function() onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 8),
      leading: Icon(
        icon,
        color: iconColor ?? Colors.blue[700],
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: textColor ?? Colors.black87,
        ),
      ),
      onTap: onTap,
      minLeadingWidth: 24,
      dense: true,
    );
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تأكيد تسجيل الخروج"),
        content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Add your logout logic here
            },
            child: Text(
              "تسجيل الخروج",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
