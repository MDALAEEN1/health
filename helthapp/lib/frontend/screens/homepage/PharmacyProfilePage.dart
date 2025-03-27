import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helthapp/frontend/screens/homepage/AppointmentPage.dart';

class PharmacyProfilePage extends StatelessWidget {
  final String pharmacyId;

  const PharmacyProfilePage({required this.pharmacyId});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.green.shade100,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pharmacies')
            .doc("WG35OwWM7BZ2JHIB6npY")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading pharmacy data'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: CircularProgressIndicator());
          }

          final pharmacy = snapshot.data!.data() as Map<String, dynamic>;

          return Stack(
            children: [
              // صورة الصيدلية
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: screenHeight * 0.4,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(pharmacy['image'] ?? ''),
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
                      children: [
                        Text(
                          pharmacy['name'] ?? 'Pharmacy Name',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          pharmacy['address'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 20),

                        // معلومات سريعة
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoTile(
                                Icons.star,
                                pharmacy['rating']?.toString() ?? '0.0',
                                'Rating'),
                            _buildInfoTile(Icons.access_time,
                                pharmacy['opening_hours'] ?? '--:--', 'Open'),
                            _buildInfoTile(
                                Icons.phone, pharmacy['phone'] ?? '--', 'Call'),
                          ],
                        ),
                        SizedBox(height: 20),

                        // الخدمات
                        Text('Services',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Wrap(
                          spacing: 10,
                          children:
                              (pharmacy['services'] as List<dynamic>? ?? [])
                                  .map((e) => Chip(
                                        label: Text(e.toString()),
                                        backgroundColor: Colors.green.shade100,
                                      ))
                                  .toList(),
                        ),
                        SizedBox(height: 20),

                        // الأدوية المتوفرة
                        Text('Available Medicines',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        _buildMedicineList(pharmacy['medicines']),
                        SizedBox(height: 20),

                        // زر الطلب
                        Center(
                          child: ElevatedButton(
                            onPressed: () => _placeOrder(context, pharmacy),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(screenWidth * 0.8, 50),
                            ),
                            child: Text('Order Medicine',
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
        Icon(icon, color: Colors.green, size: 30),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildMedicineList(List<dynamic>? medicines) {
    if (medicines == null || medicines.isEmpty) {
      return Text('No medicines listed', style: TextStyle(color: Colors.grey));
    }

    return Column(
      children: medicines
          .map((medicine) => ListTile(
                leading: Icon(Icons.medical_services, color: Colors.green),
                title: Text(medicine['name'] ?? 'Medicine'),
                subtitle: Text('${medicine['price'] ?? '--'} SAR'),
                trailing: IconButton(
                  icon: Icon(Icons.add_shopping_cart),
                  onPressed: () {},
                ),
              ))
          .toList(),
    );
  }

  void _placeOrder(BuildContext context, Map<String, dynamic> pharmacy) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppointmentPage(),
      ),
    );
  }
}
