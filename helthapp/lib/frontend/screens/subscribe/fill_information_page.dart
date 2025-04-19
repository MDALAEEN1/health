import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class FillInformationPage extends StatelessWidget {
  final String planTitle;

  const FillInformationPage({super.key, required this.planTitle});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController bloodTypeController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    String _generateRandomInsuranceNumber() {
      final random = Random();
      return List.generate(10, (_) => random.nextInt(10)).join();
    }

    final TextEditingController insuranceNumberController =
        TextEditingController(text: _generateRandomInsuranceNumber());

    void _submitForm() {
      if (_formKey.currentState!.validate()) {
        FirebaseFirestore.instance.collection('subscriptions').add({
          'planTitle': planTitle,
          'fullName': nameController.text,
          'bloodType': bloodTypeController.text,
          'phone': phoneController.text,
          'insuranceNumber': insuranceNumberController.text,
          'insuranceType': planTitle,
          'timestamp': FieldValue.serverTimestamp(),
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Subscription successful!')),
          );
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Fill Information - $planTitle"),
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
              TextFormField(
                controller: bloodTypeController,
                decoration: const InputDecoration(labelText: 'Blood Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your blood type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
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
              const SizedBox(height: 10),
              TextFormField(
                controller: insuranceNumberController,
                decoration:
                    const InputDecoration(labelText: 'Insurance Number'),
                readOnly: true,
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
