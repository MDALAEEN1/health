import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:helthapp/frontend/screens/homepage/PharmacyProfilePage.dart';

class PharmacyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight * 0.2,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pharmacies').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final pharmacies = snapshot.data!.docs;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: pharmacies.length,
            itemBuilder: (context, index) {
              final doc = pharmacies[index];
              final pharmacy = doc.data() as Map<String, dynamic>;
              final pharmacyId = doc.id;

              return _buildPharmacyCard(
                pharmacyId,
                pharmacy['name'] ?? 'No Name',
                pharmacy['location'] ?? 'Unknown Location',
                pharmacy['image'] ?? 'https://via.placeholder.com/150',
                screenHeight,
                screenWidth,
                context: context,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPharmacyCard(String pharmacyId, String name, String location,
      String image, double screenHeight, double screenWidth,
      {required BuildContext context}) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PharmacyProfilePage(pharmacyId: pharmacyId),
          ),
        );
      },
      child: Container(
        width: screenWidth * 0.4,
        margin: EdgeInsets.only(right: screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.03),
              child: Image.network(
                image,
                height: screenHeight * 0.10,
                width: screenWidth * 0.4,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: screenHeight * 0.13,
                  width: screenWidth * 0.4,
                  color: Colors.grey[200],
                  child: Icon(Icons.photo, size: screenWidth * 0.1),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(name,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04)),
            Text(location,
                style: TextStyle(
                    color: Colors.grey[600], fontSize: screenWidth * 0.035)),
          ],
        ),
      ),
    );
  }
}
