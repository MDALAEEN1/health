import 'package:flutter/material.dart';
import 'package:helthapp/frontend/screens/homepage/DoctorList.dart';
import 'package:helthapp/frontend/screens/homepage/PharmacyList.dart';
import 'package:helthapp/frontend/screens/homepage/CustomDrawer.dart';
import 'package:helthapp/frontend/screens/homepage/veiwAll.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Map<String, dynamic>> services = [
    {'icon': Icons.local_pharmacy, 'title': 'Pharmacy'},
    {'icon': Icons.medical_services, 'title': 'Consultation'},
    {'icon': Icons.shopping_cart, 'title': 'In-store shopping'},
    {'icon': Icons.shopping_bag, 'title': 'Online shopping'},
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
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchField(context, screenHeight, screenWidth),
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
                          _buildDetailRow("اسم المؤمّن:", "أحمد محمد"),
                          _buildDetailRow("رقم البطاقة:", "•••• 5689"),
                          _buildDetailRow("نوع التأمين:", "طبي شامل"),
                          _buildDetailRow("تاريخ الانتهاء:", "12/2025"),
                          Spacer(),
                        ],
                      ),
                    ),
                  )),
              Text(
                "Services",
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              _buildServicesRow(screenHeight, screenWidth),
              SizedBox(height: screenHeight * 0.02),
              _buildSectionWithViewAll(
                  'Pharmacy', screenWidth, "pharmacies", context),
              SizedBox(height: screenHeight * 0.01),
              PharmacyList(),
              SizedBox(height: screenHeight * 0.02),
              _buildSectionWithViewAll(
                  'Popular Doctors', screenWidth, "doctors", context),
              SizedBox(height: screenHeight * 0.01),
              DoctorList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(
      BuildContext context, double screenHeight, double screenWidth) {
    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: CustomSearchDelegate(),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
        ),
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.015,
          horizontal: screenWidth * 0.04,
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: screenWidth * 0.06, color: Colors.grey),
            SizedBox(width: screenWidth * 0.02),
            Text(
              "Search",
              style:
                  TextStyle(color: Colors.grey, fontSize: screenWidth * 0.04),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionWithViewAll(String title, double screenWidth,
      String categoryType, BuildContext context) {
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewAllPage(categoryType: categoryType),
              ),
            );
          },
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
}

// Custom SearchDelegate for searching doctors and pharmacies
class CustomSearchDelegate extends SearchDelegate {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<QuerySnapshot>>(
      future: Future.wait([
        _firestore
            .collection('doctors') // Replace with your doctors collection name
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: query + '\uf8ff')
            .get(),
        _firestore
            .collection(
                'pharmacies') // Replace with your pharmacies collection name
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: query + '\uf8ff')
            .get(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData ||
            snapshot.data!.every((doc) => doc.docs.isEmpty)) {
          return Center(child: Text('No results found.'));
        }

        final doctorsResults = snapshot.data![0].docs;
        final pharmaciesResults = snapshot.data![1].docs;

        return ListView(
          children: [
            if (doctorsResults.isNotEmpty) ...[
              ListTile(
                title: Text('Doctors',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...doctorsResults.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text('Doctor'),
                  onTap: () {
                    // Handle doctor selection
                  },
                );
              }).toList(),
            ],
            if (pharmaciesResults.isNotEmpty) ...[
              ListTile(
                title: Text('Pharmacies',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...pharmaciesResults.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text('Pharmacy'),
                  onTap: () {
                    // Handle pharmacy selection
                  },
                );
              }).toList(),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Center(child: Text('Start typing to search.'));
    }

    return FutureBuilder<List<QuerySnapshot>>(
      future: Future.wait([
        _firestore
            .collection('doctors') // Replace with your doctors collection name
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: query + '\uf8ff')
            .get(),
        _firestore
            .collection(
                'pharmacies') // Replace with your pharmacies collection name
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: query + '\uf8ff')
            .get(),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData ||
            snapshot.data!.every((doc) => doc.docs.isEmpty)) {
          return Center(child: Text('No suggestions available.'));
        }

        final doctorsSuggestions = snapshot.data![0].docs;
        final pharmaciesSuggestions = snapshot.data![1].docs;

        return ListView(
          children: [
            if (doctorsSuggestions.isNotEmpty) ...[
              ListTile(
                title: Text('Doctors',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...doctorsSuggestions.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text('Doctor'),
                  onTap: () {
                    query = data['name'];
                    showResults(context);
                  },
                );
              }).toList(),
            ],
            if (pharmaciesSuggestions.isNotEmpty) ...[
              ListTile(
                title: Text('Pharmacies',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ...pharmaciesSuggestions.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['name']),
                  subtitle: Text('Pharmacy'),
                  onTap: () {
                    query = data['name'];
                    showResults(context);
                  },
                );
              }).toList(),
            ],
          ],
        );
      },
    );
  }
}
