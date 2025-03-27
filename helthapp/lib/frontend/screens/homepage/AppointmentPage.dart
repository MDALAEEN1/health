import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String? selectedBloodGroup;
  String? gender;

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
              _buildLabeledTextField('Name', 'Enter your name', Icons.person),
              _buildLabeledTextField(
                  'Date of Birth', 'dd/mm/yyyy', Icons.calendar_today),
              _buildLabeledTextField(
                  'Mobile Number', 'Enter your number', Icons.phone),
              SizedBox(height: 16),
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
                  maxLines: 3),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () {},
                child: Text('Continue', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledTextField(String label, String hint, IconData icon,
      {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        TextField(
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
}
