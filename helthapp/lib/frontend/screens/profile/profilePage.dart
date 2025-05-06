import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<Map<String, dynamic>> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    String userId = user.uid;

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> _fetchSubscriptionData(String userId) async {
    DocumentSnapshot subscriptionDoc =
        await _firestore.collection('subscriptions').doc(userId).get();
    return subscriptionDoc.data() as Map<String, dynamic>;
  }

  void _saveChanges(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'firstName': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    });
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            tooltip: _isEditing ? "Save Changes" : "Edit Profile",
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("An error occurred while loading data"));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No data available"));
          }

          final userData = snapshot.data!;
          if (!_isEditing) {
            _nameController.text = userData['firstName'] ?? "";
            _emailController.text = userData['email'] ?? "";
            _phoneController.text = userData['phone'] ?? "";
          }

          return FutureBuilder<Map<String, dynamic>>(
            future:
                _fetchSubscriptionData(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, subscriptionSnapshot) {
              if (subscriptionSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (subscriptionSnapshot.hasError) {
                return Center(
                    child:
                        Text("An error occurred while loading subscriptions"));
              } else if (!subscriptionSnapshot.hasData ||
                  subscriptionSnapshot.data == null) {
                return Center(child: Text("No subscription data available"));
              }

              final subscriptionData = subscriptionSnapshot.data!;
              return ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  // Profile Header
                  _buildProfileHeader(userData),

                  SizedBox(height: 16),

                  // Personal Information
                  _buildSectionHeader("Personal Information"),
                  _buildEditableProfileItem(
                    icon: Icons.person_outline,
                    title: "Full Name",
                    controller: _nameController,
                    isEditing: _isEditing,
                  ),
                  _buildEditableProfileItem(
                    icon: Icons.email_outlined,
                    title: "Email",
                    controller: _emailController,
                    isEditing: _isEditing,
                  ),
                  _buildEditableProfileItem(
                    icon: Icons.phone_outlined,
                    title: "Phone Number",
                    controller: _phoneController,
                    isEditing: _isEditing,
                  ),

                  // Insurance Information (non-editable)
                  _buildSectionHeader("Insurance Information"),
                  _buildProfileItem(
                    icon: Icons.card_membership_outlined,
                    title: "Insurance Type",
                    value: subscriptionData['insuranceType'] ?? "Not Available",
                  ),
                  _buildProfileItem(
                    icon: Icons.date_range_outlined,
                    title: "Insurance Expiry Date",
                    value: subscriptionData['expiryDate'] != null
                        ? DateFormat('yyyy-MM-dd')
                            .format(subscriptionData['expiryDate'].toDate())
                        : "Not Available",
                  ),

                  if (_isEditing)
                    ElevatedButton(
                      onPressed: () {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          _saveChanges(user.uid);
                        }
                      },
                      child: Text("Save Changes"),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> userData) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: userData['profileImage'] != null
                ? NetworkImage(userData['profileImage'])
                : null,
            child: userData['profileImage'] == null
                ? Icon(Icons.person, size: 50, color: Colors.white)
                : null,
          ),
          SizedBox(height: 8),
          Text(
            (userData['firstName'] ?? "Not Available") +
                " " +
                (userData['lastName'] ?? "Not Available"),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            userData['email'] ?? "Not Available",
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

  Widget _buildEditableProfileItem({
    required IconData icon,
    required String title,
    required TextEditingController controller,
    required bool isEditing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: isEditing
          ? TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: title,
                border: OutlineInputBorder(),
              ),
            )
          : Text(title, style: TextStyle(fontSize: 16)),
      subtitle: isEditing
          ? null
          : Text(controller.text,
              style: TextStyle(fontSize: 14, color: Colors.grey)),
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
