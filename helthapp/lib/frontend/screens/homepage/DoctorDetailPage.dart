import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helthapp/frontend/screens/homepage/AppointmentPage.dart';

class DoctorProfilePage extends StatelessWidget {
  final String doctorId;

  const DoctorProfilePage({required this.doctorId});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('doctors')
            .doc("eIRcYKQjKiHjPRnOZTRX")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading doctor data'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: CircularProgressIndicator());
          }

          final doctor = snapshot.data!.data() as Map<String, dynamic>;

          return Stack(
            children: [
              // صورة الخلفية
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: screenHeight * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(doctor['image'] ?? ''),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // زر الرجوع
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // محتوى البطاقة
              Positioned(
                top: screenHeight * 0.35,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(screenWidth * 0.05),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          doctor['name'] ?? 'Doctor Name',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${doctor['specialization']} (${doctor['experience']} Experience)',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 20),

                        // معلومات سريعة
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoTile(
                                Icons.people,
                                doctor['patients']?.toString() ?? '0',
                                'Patient'),
                            _buildInfoTile(
                                Icons.star,
                                doctor['rating']?.toString() ?? '0.0',
                                'Rating'),
                            _buildInfoTile(Icons.monetization_on,
                                doctor['price'] ?? '0 SAR', 'Price'),
                          ],
                        ),
                        SizedBox(height: 20),

                        // أوقات العمل
                        Text('Working time',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(doctor['working_hours'] ?? 'Not specified'),
                        SizedBox(height: 20),

                        // معلومات عن الطبيب
                        Text('About',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          doctor['about'] ?? 'No information available',
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(height: 30),

                        // زر الحجز
                        Center(
                          child: ElevatedButton(
                            onPressed: () => _bookAppointment(context, doctor),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(screenWidth * 0.8, 50),
                            ),
                            child: Text('Book Appointment',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 30),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  void _bookAppointment(BuildContext context, Map<String, dynamic> doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentPage(),
      ),
    );
  }
}
