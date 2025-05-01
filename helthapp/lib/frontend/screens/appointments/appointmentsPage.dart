import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'previousAppointmentsPage.dart'; // Import the previous appointments page

class AppointmentsPage extends StatelessWidget {
  Future<String> _getDoctorName(String doctorId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();
    return docSnapshot.exists
        ? docSnapshot['name'] ?? 'اسم غير معروف'
        : 'اسم غير معروف';
  }

  Future<void> _deleteAndMoveAppointment(
      String appointmentId, Map<String, dynamic> appointmentData) async {
    try {
      // Add the appointment to the "previous_appointments" collection
      await FirebaseFirestore.instance
          .collection('previous_appointments')
          .doc(appointmentId)
          .set(appointmentData);

      // Delete the appointment from the "appointments" collection
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .delete();
    } catch (e) {
      print("Error moving appointment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("المواعيد"),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PreviousAppointmentsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('appointments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "لا توجد مواعيد حالياً",
                style: TextStyle(fontSize: 18),
              ),
            );
          }
          final appointments = snapshot.data!.docs;
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              final doctorId = appointment['doctorId'];
              final appointmentId = appointment.id; // Get the document ID
              return FutureBuilder<String>(
                future: _getDoctorName(doctorId),
                builder: (context, doctorSnapshot) {
                  final doctorName = doctorSnapshot.data ?? 'جاري التحميل...';
                  return ListTile(
                    title: FutureBuilder<String>(
                      future: _getDoctorName(doctorId),
                      builder: (context, snapshot) {
                        return Text(snapshot.data ?? 'جاري التحميل...');
                      },
                    ),
                    subtitle: Text(
                        "${appointment['date_of_birth'] ?? 'بدون تاريخ'} - د. $doctorName"),
                    leading: Icon(Icons.calendar_today),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _deleteAndMoveAppointment(appointmentId,
                            appointment.data() as Map<String, dynamic>);
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
