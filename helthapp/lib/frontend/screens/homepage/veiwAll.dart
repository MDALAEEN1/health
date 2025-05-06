import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helthapp/frontend/screens/homepage/DoctorDetailPage.dart';
import 'package:helthapp/frontend/screens/homepage/PharmacyProfilePage.dart';
import 'package:shimmer/shimmer.dart';

class ViewAllPage extends StatelessWidget {
  final String categoryType; // ✅ نوع القسم المرسل

  const ViewAllPage({Key? key, required this.categoryType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text("All $categoryType")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(categoryType)
            .snapshots(), // ✅ يجلب البيانات حسب النوع
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!.docs;

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final doc = items[index];
              final data = doc.data() as Map<String, dynamic>;
              final itemId = doc.id;

              return _buildItemCard(
                itemId,
                data['name'] ?? 'No Name',
                data['image'] ?? 'https://via.placeholder.com/150',
                screenHeight,
                screenWidth,
                data['specialization'] ?? 'No Specialization',
                data['category'] ?? 'No Specialization',
                context: context,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildItemCard(
      String itemId,
      String name,
      String image,
      double screenHeight,
      double screenWidth,
      String Specialization,
      String categorytype,
      {required BuildContext context}) {
    return InkWell(
      onTap: () {
        if (categoryType == "pharmacies") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PharmacyProfilePage(pharmacyId: itemId),
            ),
          );
        } else if (categoryType == "doctors") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorProfilePage(doctorId: itemId),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      splashColor: Colors.blue.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                image,
                height: screenHeight * 0.12,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: screenHeight * 0.12,
                      width: double.infinity,
                      color: Colors.grey[300],
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: screenHeight * 0.12,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Icon(Icons.photo,
                      size: screenWidth * 0.1, color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.042,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    if (categoryType == "doctors") ...[
                      Row(
                        children: [
                          Icon(Icons.medical_services,
                              color: Colors.blue, size: 18),
                          SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              Specialization, // Replace with actual data if available
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: screenWidth * 0.035,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "plan type: $categorytype",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: screenWidth * 0.035,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          SizedBox(width: 4),
                          Text(
                            '0.0', // Replace with actual data if available
                            style: TextStyle(
                              fontSize: screenWidth * 0.038,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios,
                              color: Colors.blueAccent, size: 16),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
