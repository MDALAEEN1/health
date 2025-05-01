import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helthapp/frontend/auth/loginPage.dart';

class DoctorHomePage extends StatefulWidget {
  const DoctorHomePage({super.key});

  @override
  State<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? doctorData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
  }

  Future<void> _loadDoctorData() async {
    try {
      final uid = _auth.currentUser!.uid;
      final docSnapshot = await _firestore.collection('doctors').doc(uid).get();

      if (docSnapshot.exists) {
        setState(() {
          doctorData = docSnapshot.data();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        _showSnackBar("No doctor data found.");
      }
    } catch (e) {
      setState(() => isLoading = false);
      _showSnackBar("Error loading data: $e");
    }
  }

  void _showSnackBar(String message, {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  void _showEditDialog() {
    final nameController =
        TextEditingController(text: doctorData?['name'] ?? '');
    final specializationController =
        TextEditingController(text: doctorData?['specialization'] ?? '');
    final phoneController =
        TextEditingController(text: doctorData?['phone'] ?? '');
    final locationController =
        TextEditingController(text: doctorData?['location'] ?? '');
    final experienceController =
        TextEditingController(text: doctorData?['experience'].toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Doctor Profile"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name')),
              TextField(
                  controller: specializationController,
                  decoration:
                      const InputDecoration(labelText: 'Specialization')),
              TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Phone')),
              TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'Location')),
              TextField(
                controller: experienceController,
                decoration:
                    const InputDecoration(labelText: 'Experience (years)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                final uid = _auth.currentUser!.uid;
                await _firestore.collection('doctors').doc(uid).update({
                  'name': nameController.text,
                  'specialization': specializationController.text,
                  'phone': phoneController.text,
                  'location': locationController.text,
                  'experience': int.tryParse(experienceController.text) ?? 0,
                });

                Navigator.pop(context);
                _loadDoctorData();
                _showSnackBar("Profile updated successfully!",
                    backgroundColor: Colors.green);
              } catch (e) {
                _showSnackBar("Error updating profile: $e");
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, {IconData? icon}) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
      leading: Icon(icon ?? Icons.info_outline),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : doctorData == null
              ? const Center(child: Text("No data found."))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView(
                    children: [
                      const Icon(Icons.person,
                          size: 100, color: Colors.deepPurple),
                      const SizedBox(height: 20),
                      _buildInfoTile("Name", doctorData!['name'],
                          icon: Icons.person),
                      _buildInfoTile(
                          "Specialization", doctorData!['specialization'],
                          icon: Icons.work),
                      _buildInfoTile("Email", doctorData!['email'],
                          icon: Icons.email),
                      _buildInfoTile(
                          "Phone", doctorData!['phone']?.toString() ?? 'N/A',
                          icon: Icons.phone),
                      _buildInfoTile(
                          "Location", doctorData!['location'] ?? 'N/A',
                          icon: Icons.location_on),
                      _buildInfoTile("Experience",
                          "${doctorData!['experience']} years" ?? 'N/A',
                          icon: Icons.timeline),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _showEditDialog,
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit Profile"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Divider(),
                      const Text("Appointments",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('appointments')
                            .where('doctorId',
                                isEqualTo: _auth.currentUser!.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                "Something went wrong: ${snapshot.error}");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Text("No appointments found.");
                          }

                          return Column(
                            children: snapshot.data!.docs.map((doc) {
                              final data = doc.data() as Map<String, dynamic>;

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(data['name'] ?? 'No Name'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Phone: ${data['phone']}"),
                                      Text(
                                          "Problem: ${data['problem_description']}"),
                                      Text("DOB: ${data['date_of_birth']}"),
                                      Text("Gender: ${data['gender']}"),
                                      Text("Blood: ${data['blood_group']}"),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:
                                              const Text("Delete Appointment"),
                                          content: const Text(
                                              "Are you sure you want to delete this appointment?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: const Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        await _firestore
                                            .collection('appointments')
                                            .doc(doc.id)
                                            .delete();
                                        _showSnackBar("Appointment deleted",
                                            backgroundColor: Colors.green);
                                      }
                                    },
                                  ),
                                  isThreeLine: true,
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
