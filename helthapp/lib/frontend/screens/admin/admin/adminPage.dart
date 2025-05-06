import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firebase Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:uuid/uuid.dart'; // Import UUID package for generating unique IDs

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> fetchDoctors() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('doctors').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> fetchSubscribers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('subscribers').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> createDoctorAccount(
      String email, String password, String name, String category) async {
    try {
      // Create user in Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user?.uid ??
          const Uuid().v4(); // Use Auth UID or generate one

      // Add doctor details to Firestore
      await FirebaseFirestore.instance.collection('doctors').doc(uid).set({
        'uid': uid,
        'email': email,
        'name': name,
        'specialization': 'General',
        'category': category, // Add category
      });
    } catch (e) {
      throw Exception("Failed to create doctor account: $e");
    }
  }

  void showCreateDoctorDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();
    String selectedCategory = 'pro'; // Default category

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create New Doctor Account"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: const [
                  DropdownMenuItem(value: 'Pro', child: Text('Pro')),
                  DropdownMenuItem(value: 'Premuim', child: Text('Premuim')),
                  DropdownMenuItem(value: 'Basic', child: Text('Basic')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    selectedCategory = value;
                  }
                },
                decoration: const InputDecoration(labelText: "Category"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                if (name.isNotEmpty &&
                    email.isNotEmpty &&
                    password.isNotEmpty) {
                  await createDoctorAccount(
                      email, password, name, selectedCategory);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Doctor account created!")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("All fields are required!")),
                  );
                }
              },
              child: const Text("Create"),
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
        title: const Text("Admin Page"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () => showCreateDoctorDialog(context),
              child: const Text("Create New Doctor Account"),
            ),
            Section(
              title: "Registered Users",
              future: fetchUsers(),
              itemBuilder: (item) => ListTile(
                title: Text(item['name'] ?? 'No Name'),
                subtitle: Text(item['email'] ?? 'No Email'),
              ),
            ),
            Section(
              title: "Doctors",
              future: fetchDoctors(),
              itemBuilder: (item) => ListTile(
                title: Text(item['name'] ?? 'No Name'),
                subtitle: Text(item['specialization'] ?? 'No Specialization'),
              ),
            ),
            Section(
              title: "Subscribed Users",
              future: fetchSubscribers(),
              itemBuilder: (item) => ListTile(
                title: Text(item['name'] ?? 'No Name'),
                subtitle:
                    Text("Subscription: ${item['subscriptionType'] ?? 'None'}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final Future<List<Map<String, dynamic>>> future;
  final Widget Function(Map<String, dynamic>) itemBuilder;

  const Section({
    required this.title,
    required this.future,
    required this.itemBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data available."));
                }

                final data = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) => itemBuilder(data[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
