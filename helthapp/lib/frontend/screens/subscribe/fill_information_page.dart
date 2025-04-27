import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class FillInformationPage extends StatefulWidget {
  final String planTitle;

  const FillInformationPage({super.key, required this.planTitle});

  @override
  _FillInformationPageState createState() => _FillInformationPageState();
}

class _FillInformationPageState extends State<FillInformationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController insuranceNumberController =
      TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();

  String? userId;
  String selectedCountryCode = '+90'; // Default country code

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid; // Get the userId from Firebase Authentication
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        final data = userDoc.data();
        setState(() {
          nameController.text = data?['firstName'] ?? '';
          bloodTypeController.text = data?['bloodType'] ?? '';
          phoneController.text = data?['phone'] ?? '';
          insuranceNumberController.text =
              data?['insuranceNumber'] ?? _generateRandomInsuranceNumber();

          // Calculate expiry date to be one year from the timestamp
          final timestamp = data?['timestamp'] as Timestamp?;
          if (timestamp != null) {
            final DateTime startDate = timestamp.toDate();
            final DateTime calculatedExpiryDate =
                startDate.add(const Duration(days: 365)); // Add 1 year
            expiryDateController.text =
                calculatedExpiryDate.toLocal().toString().split(' ')[0];
          } else {
            expiryDateController.text = 'No expiry date available';
          }
        });
      } else {
        setState(() {
          insuranceNumberController.text = _generateRandomInsuranceNumber();
        });
      }
    }
  }

  String _generateRandomInsuranceNumber() {
    final random = Random();
    return List.generate(10, (_) => random.nextInt(10)).join();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      final DateTime currentDate = DateTime.now();
      final DateTime expiryDate =
          currentDate.add(const Duration(days: 365)); // Add 1 year

      final data = {
        'uid': user.uid, // Store the user's UID
        'planTitle': widget.planTitle,
        'fullName': nameController.text,
        'bloodType': bloodTypeController.text,
        'phone': phoneController.text,
        'insuranceNumber': insuranceNumberController.text,
        'insuranceType': widget.planTitle,
        'timestamp': FieldValue.serverTimestamp(),
        'expiryDate': expiryDate, // Add expiry date
      };

      if (userId != null) {
        FirebaseFirestore.instance
            .collection('subscriptions')
            .doc(userId)
            .set(data)
            .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Subscription updated successfully!')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        });
      } else {
        FirebaseFirestore.instance
            .collection('subscriptions')
            .add(data)
            .then((docRef) {
          setState(() {
            userId = docRef.id;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Subscription created successfully!')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fill Information - ${widget.planTitle}"),
        backgroundColor: Colors.blue.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: bloodTypeController.text.isNotEmpty
                    ? bloodTypeController.text
                    : null,
                decoration: const InputDecoration(labelText: 'Blood Type'),
                items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                    .map((bloodType) => DropdownMenuItem(
                          value: bloodType,
                          child: Text(bloodType),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    bloodTypeController.text = value ?? '';
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your blood type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: selectedCountryCode,
                      decoration:
                          const InputDecoration(labelText: 'Country Code'),
                      items: [
                        '+90', // Turkey
                        '+357', // Cyprus
                      ]
                          .map((code) => DropdownMenuItem(
                                value: code,
                                child: Text(code),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCountryCode = value ?? '+90';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      controller: phoneController,
                      decoration:
                          const InputDecoration(labelText: 'Phone Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (!RegExp(r'^\d+$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: insuranceNumberController,
                decoration:
                    const InputDecoration(labelText: 'Insurance Number'),
                readOnly: true, // Make the field read-only
                style: const TextStyle(color: Colors.grey), // Grey out the text
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: expiryDateController,
                decoration: const InputDecoration(
                    labelText: 'Subscription Expiry Date'),
                readOnly: true, // Make the field read-only
                style: const TextStyle(color: Colors.grey), // Grey out the text
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 10),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
