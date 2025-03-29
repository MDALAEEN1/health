import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  final String doctorId; // استقبال معرّف الطبيب

  const AppointmentPage({required this.doctorId, Key? key}) : super(key: key);

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController problemController = TextEditingController();

  String? selectedBloodGroup;
  String? gender;
  bool isLoading = false; // للتحكم في حالة التحميل عند الحفظ

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Appointment')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabeledTextField('Name', 'Enter your name', Icons.person,
                  controller: nameController),
              _buildLabeledTextField(
                  'Date of Birth', 'dd/mm/yyyy', Icons.calendar_today,
                  controller: dobController),
              _buildLabeledTextField(
                  'Mobile Number', 'Enter your number', Icons.phone,
                  controller: phoneController),
              SizedBox(height: 16),

              // اختيار فصيلة الدم
              Text('Blood Group',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: ['AB+', 'AB-', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-']
                    .map((bg) => ChoiceChip(
                          label: Text(bg),
                          selected: selectedBloodGroup == bg,
                          selectedColor: Colors.lightBlue,
                          onSelected: (selected) {
                            setState(() {
                              selectedBloodGroup = selected ? bg : null;
                            });
                          },
                        ))
                    .toList(),
              ),
              SizedBox(height: 16),

              // اختيار الجنس
              Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio(
                    value: 'Male',
                    groupValue: gender,
                    activeColor: Colors.lightBlue,
                    onChanged: (value) {
                      setState(() {
                        gender = value as String?;
                      });
                    },
                  ),
                  Text('Male'),
                  SizedBox(width: 20),
                  Radio(
                    value: 'Female',
                    groupValue: gender,
                    activeColor: Colors.lightBlue,
                    onChanged: (value) {
                      setState(() {
                        gender = value as String?;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 16),

              _buildLabeledTextField(
                  'Write your problem', 'Describe your issue', Icons.edit,
                  controller: problemController, maxLines: 3),
              SizedBox(height: 16),

              // زر الحجز
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: isLoading
                    ? null
                    : _confirmAppointment, // تعطيل الزر عند التحميل
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Continue', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(String label, String hint, IconData icon,
      {int maxLines = 1, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.lightBlue),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.lightBlue.withOpacity(0.5)),
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Future<void> _confirmAppointment() async {
    if (nameController.text.isEmpty ||
        dobController.text.isEmpty ||
        phoneController.text.isEmpty ||
        problemController.text.isEmpty ||
        selectedBloodGroup == null ||
        gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    setState(() {
      isLoading = true; // تفعيل حالة التحميل
    });

    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'doctorId': widget.doctorId,
        'name': nameController.text,
        'date_of_birth': dobController.text,
        'phone': phoneController.text,
        'blood_group': selectedBloodGroup,
        'gender': gender,
        'problem_description': problemController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Appointment booked successfully!")),
      );

      Navigator.pop(context); // الرجوع إلى الصفحة السابقة بعد الحجز
    } catch (e) {
      print("Error saving appointment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to book appointment. Try again.")),
      );
    }

    setState(() {
      isLoading = false; // إيقاف التحميل
    });
  }
}
