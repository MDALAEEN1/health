import 'package:flutter/material.dart';
import 'package:helthapp/frontend/screens/subscribe/fill_information_page.dart';

class PricingPlansPage extends StatefulWidget {
  @override
  _PricingPlansPageState createState() => _PricingPlansPageState();
}

class _PricingPlansPageState extends State<PricingPlansPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pricing Plans",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      backgroundColor: Colors.blue.shade700,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                PricingCard(
                  title: "Basic",
                  price: "\$9/year",
                  users: "1 user",
                  features: [
                    "Basic sharing",
                    "Standard support",
                    "Multi-device access",
                    "Secure cloud backup"
                  ],
                  color: Colors.green,
                ),
                PricingCard(
                  title: "Premium",
                  price: "\$24/year",
                  users: "3 users",
                  features: [
                    "One-to-one sharing",
                    "Emergency access",
                    "Advanced multi-factor options",
                    "Priority tech support",
                    "1GB encrypted storage"
                  ],
                  color: Colors.blue,
                ),
                PricingCard(
                  title: "Pro",
                  price: "\$49/year",
                  users: "5 users",
                  features: [
                    "All premium features",
                    "Family sharing",
                    "Dedicated account manager",
                    "Unlimited encrypted storage"
                  ],
                  color: Colors.purple,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // نقاط المؤشر أسفل PageView
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: _currentIndex == index ? 12 : 8,
                height: _currentIndex == index ? 12 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.white : Colors.white54,
                ),
              );
            }),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final String users;
  final List<String> features;
  final Color color;

  const PricingCard({
    super.key,
    required this.title,
    required this.price,
    required this.users,
    required this.features,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 20),

            // أيقونة
            Icon(Icons.star, size: 50, color: color),

            const SizedBox(height: 10),

            // عنوان الخطة
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // السعر
            Text(
              price,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // عدد المستخدمين
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                users,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // المزايا
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children:
                    features.map((feature) => FeatureItem(feature)).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // زر الاشتراك
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FillInformationPage(planTitle: title),
                  ),
                );
              },
              child: const Text(
                "Select",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ويدجت لعناصر الميزات
class FeatureItem extends StatelessWidget {
  final String text;
  const FeatureItem(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.blue, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
