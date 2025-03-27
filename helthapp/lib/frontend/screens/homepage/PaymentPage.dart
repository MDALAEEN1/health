import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? selectedPayment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add A Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your payment method for hospital clinic visits',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 16),
            _buildPaymentOption('Payment at the clinic'),
            _buildPaymentOption('Visa **** 1289',
                leadingIcon: Icons.credit_card),
            _buildPaymentOption('Mastercard **** 2109',
                leadingIcon: Icons.credit_card),
            _buildPaymentOption('Zahid Hasan',
                leadingIcon: Icons.account_circle),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Add New Card +',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {},
              child: Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, {IconData? leadingIcon}) {
    bool isSelected = selectedPayment == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = title;
        });
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.lightBlue.withOpacity(0.2)
              : Colors.transparent,
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            if (leadingIcon != null) Icon(leadingIcon, color: Colors.blue),
            SizedBox(width: 10),
            Expanded(child: Text(title)),
            Radio(
              value: title,
              groupValue: selectedPayment,
              activeColor: Colors.blue,
              onChanged: (value) {
                setState(() {
                  selectedPayment = value as String?;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
