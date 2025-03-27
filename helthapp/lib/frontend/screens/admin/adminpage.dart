import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  List<String> plans = ["Basic", "Standard", "Premium"];
  String? selectedPlan;

  /// إضافة مركز جديد إلى Firestore
  void addCenter() async {
    if (_nameController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        selectedPlan != null) {
      Map<String, String> newCenter = {
        "name": _nameController.text,
        "location": _locationController.text,
        "plan": selectedPlan!,
      };

      // حفظ البيانات في Firestore
      await FirebaseFirestore.instance.collection("centers").add(newCenter);

      // مسح الحقول بعد الإضافة
      _nameController.clear();
      _locationController.clear();
      setState(() {
        selectedPlan = null;
      });
    }
  }

  /// حذف مركز من Firestore
  void removeCenter(String docId) async {
    // عرض نافذة تأكيد قبل الحذف
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this center?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // إغلاق نافذة التأكيد
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                // حذف المركز من Firestore
                await FirebaseFirestore.instance
                    .collection("centers")
                    .doc(docId)
                    .delete();
                Navigator.of(context).pop(); // إغلاق نافذة التأكيد
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin - Accredited Centers"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Center Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: "Location"),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedPlan,
              decoration: InputDecoration(labelText: "Select Plan"),
              items: plans.map((plan) {
                return DropdownMenuItem(
                  value: plan,
                  child: Text(plan),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPlan = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: addCenter,
              child: Text("Add Center"),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("centers")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No centers available"));
                  }

                  var centers = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: centers.length,
                    itemBuilder: (context, index) {
                      var center = centers[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(center["name"]),
                          subtitle: Text(
                              "Location: ${center["location"]}\nPlan: ${center["plan"]}"),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeCenter(center.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
