import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helthapp/frontend/screens/homepage/DoctorDetailPage.dart';
import 'package:helthapp/frontend/screens/homepage/PharmacyProfilePage.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> services = [
    {'icon': Icons.local_pharmacy, 'title': 'Pharmacy'},
    {'icon': Icons.medical_services, 'title': 'Consultation'},
    {'icon': Icons.shopping_cart, 'title': 'In-store shopping'},
    {'icon': Icons.shopping_bag, 'title': 'Online shopping'},
  ];

  final List<Map<String, dynamic>> pharmacies = [
    {
      'name': 'Block Drug Store',
      'location': 'New York (3.6 km)',
      'image': 'assets/pills1.png'
    },
    {
      'name': 'Walgreens',
      'location': 'New York (4.2 km)',
      'image': 'assets/pills2.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Header Section
            UserAccountsDrawerHeader(
              accountName: Text(
                "أحمد محمد",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                "ahmed@example.com",
                style: TextStyle(fontSize: 14),
              ),
              currentAccountPicture: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(
                    "https://example.com/path/to/profile/image.jpg"),
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.blue,
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue[700]!, Colors.blue[400]!],
                ),
              ),
            ),

            // Main Menu Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Profile Section
                  _buildDrawerItem(
                    icon: Icons.person_outline,
                    title: "الملف الشخصي",
                    onTap: () => _navigateTo(context, '/profile'),
                  ),

                  // Settings Section
                  _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    title: "الإعدادات",
                    onTap: () => _navigateTo(context, '/settings'),
                  ),

                  // Divider with spacing
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Divider(height: 1),
                  ),

                  // Logout Section
                  _buildDrawerItem(
                    icon: Icons.exit_to_app,
                    title: "تسجيل الخروج",
                    onTap: () => _handleLogout(context),
                    textColor: Colors.red,
                    iconColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchField(screenHeight, screenWidth),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Container(
                      height: screenHeight * 0.27,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [Colors.blue.shade700, Colors.blue.shade900],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "بــطاقـة تـأمـين",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.medical_services,
                                  color: Colors.white, size: 30),
                            ],
                          ),

                          SizedBox(height: 30),

                          // Card Details
                          _buildDetailRow("اسم المؤمّن:", "أحمد محمد"),
                          _buildDetailRow("رقم البطاقة:", "•••• 5689"),
                          _buildDetailRow("نوع التأمين:", "طبي شامل"),
                          _buildDetailRow("تاريخ الانتهاء:", "12/2025"),

                          Spacer(),

                          // Footer
                        ],
                      ),
                    ),
                  )),
              _buildSectionWithViewAll('Services', screenWidth),
              SizedBox(height: screenHeight * 0.01),
              _buildServicesRow(screenHeight, screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildSectionWithViewAll('Pharmacy', screenWidth),
              SizedBox(height: screenHeight * 0.01),
              _buildPharmacyList(screenHeight, screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildSectionWithViewAll('Popular Doctors', screenWidth),
              SizedBox(height: screenHeight * 0.01),
              _buildDoctorsList(screenHeight, screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(double screenHeight, double screenWidth) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        prefixIcon: Icon(Icons.search, size: screenWidth * 0.06),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      ),
    );
  }

  Widget _buildSectionWithViewAll(String title, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'View all >',
            style: TextStyle(fontSize: screenWidth * 0.04),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesRow(double screenHeight, double screenWidth) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        mainAxisSpacing: screenHeight * 0.015,
        crossAxisSpacing: screenWidth * 0.02,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        return _buildServiceIcon(
          services[index]['icon'] as IconData,
          services[index]['title'] as String,
          screenWidth,
        );
      },
    );
  }

  Widget _buildServiceIcon(IconData icon, String title, double screenWidth) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            radius: screenWidth * 0.08,
            child: Icon(icon, color: Colors.blue, size: screenWidth * 0.08),
          ),
          SizedBox(height: screenWidth * 0.02),
          Text(
            title,
            style: TextStyle(fontSize: screenWidth * 0.03),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacyList(
    double screenHeight,
    double screenWidth,
  ) {
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
              final pharmacy = pharmacies[index].data() as Map<String, dynamic>;
              return _buildPharmacyCard(
                pharmacy['name'] ?? 'No Name',
                pharmacy['location'] ?? 'Unknown Location',
                pharmacy['image'] ?? 'assets/default_pharmacy.png',
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

  Widget _buildPharmacyCard(String name, String location, String image,
      double screenHeight, double screenWidth,
      {required BuildContext context}) {
    return InkWell(
      onTap: () {
        // للانتقال لصفحة الصيدلية
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PharmacyProfilePage(pharmacyId: 'pharmacy_document_id'),
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
              child: Image.asset(
                image,
                height: screenHeight * 0.10,
                width: screenWidth * 0.4,
                fit: BoxFit.cover,
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

Widget _buildDoctorsList(double screenHeight, double screenWidth) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('حدث خطأ في تحميل بيانات الأطباء'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }

      final doctors = snapshot.data!.docs;

      if (doctors.isEmpty) {
        return Center(child: Text('لا يوجد أطباء متاحين حالياً'));
      }

      return SizedBox(
        height: screenHeight * 0.25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index].data() as Map<String, dynamic>;
            return _buildDoctorCard(
              doctor: doctor,
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              context: context,
            );
          },
        ),
      );
    },
  );
}

// Helper method to build drawer items
Widget _buildDrawerItem({
  required IconData icon,
  required String title,
  required Function() onTap,
  Color? textColor,
  Color? iconColor,
}) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 8),
    leading: Icon(
      icon,
      color: iconColor ?? Colors.blue[700],
      size: 24,
    ),
    title: Text(
      title,
      style: TextStyle(
        fontSize: 16,
        color: textColor ?? Colors.black87,
      ),
    ),
    onTap: onTap,
    minLeadingWidth: 24,
    dense: true,
  );
}

// Navigation helper method
void _navigateTo(BuildContext context, String route) {
  Navigator.pop(context);
  Navigator.pushNamed(context, route);
}

// Logout handler
void _handleLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("تأكيد تسجيل الخروج"),
      content: Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("إلغاء"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
            // Add your logout logic here
          },
          child: Text(
            "تسجيل الخروج",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        SizedBox(width: 10),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

Widget _buildDoctorCard({
  required BuildContext context, // ✅ أضف الـ context هنا
  required Map<String, dynamic> doctor,
  required double screenHeight,
  required double screenWidth,
}) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DoctorProfilePage(doctorId: 'doctor_document_id'),
        ),
      );
    },
    child: Container(
      width: screenWidth * 0.45,
      margin: EdgeInsets.only(right: screenWidth * 0.03),
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
              doctor['image'] ?? 'https://via.placeholder.com/150',
              height: screenHeight * 0.15,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: Icon(Icons.person, size: 50, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor['name'] ?? 'دكتور غير معروف',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.04,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  doctor['specialization'] ?? 'تخصص غير محدد',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      doctor['rating']?.toString() ?? '0.0',
                      style: TextStyle(fontSize: screenWidth * 0.035),
                    ),
                    Spacer(),
                    Icon(Icons.medical_services, color: Colors.blue, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

//nononon
