import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreviousAppointmentsPage extends StatelessWidget {
  Future<String> _getDoctorName(String doctorId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();
    return docSnapshot.exists
        ? docSnapshot['name'] ?? 'اسم غير معروف'
        : 'اسم غير معروف';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("المواعيد السابقة"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('previous_appointments')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "لا توجد مواعيد سابقة حالياً",
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
              final date = (appointment.data() as Map<String, dynamic>)
                          .containsKey('date') ==
                      true
                  ? appointment['date']
                  : 'بدون موعد'; // Fallback for missing date
              return FutureBuilder<String>(
                future: _getDoctorName(doctorId),
                builder: (context, doctorSnapshot) {
                  final doctorName = doctorSnapshot.data ?? 'جاري التحميل...';
                  return ListTile(
                    title: Text(doctorName),
                    subtitle: Text(
                        "${appointment['date_of_birth'] ?? 'بدون تاريخ'} - $date"),
                    leading: Icon(Icons.history),
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
