import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helthapp/frontend/screens/homepage/addcart/CardPreview%20.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String cardNumber = "";
  String expiryDate = "MM/YY";
  String nameOnCard = "اسم حامل البطاقة";
  String cardType = "unknown";

  void updateCardDisplay() {
    setState(() {
      cardNumber = cardNumberController.text;
      expiryDate = expiryDateController.text.isEmpty
          ? "MM/YY"
          : expiryDateController.text;
      nameOnCard = nameController.text.isEmpty
          ? "اسم حامل البطاقة"
          : nameController.text;
      _detectCardType(cardNumberController.text.replaceAll(RegExp(r'\s+'), ''));
    });
  }

  void _detectCardType(String cardNumber) {
    if (cardNumber.startsWith('4')) {
      setState(() => cardType = 'visa');
    } else if (cardNumber.startsWith('5')) {
      setState(() => cardType = 'mastercard');
    } else if (cardNumber.startsWith('3')) {
      setState(() => cardType = 'amex');
    } else {
      setState(() => cardType = 'unknown');
    }
  }

  String? _validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم البطاقة';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length != 16) {
      return 'يجب أن يتكون رقم البطاقة من 16 رقمًا';
    }
    return null;
  }

  String? _validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال تاريخ الانتهاء';
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(value)) {
      return 'التنسيق غير صحيح (MM/YY)';
    }
    return null;
  }

  String? _validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رمز التحقق';
    }
    if (value.length < 3 || value.length > 4) {
      return 'يجب أن يتكون رمز التحقق من 3-4 أرقام';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال اسم حامل البطاقة';
    }
    return null;
  }

  void _formatCardNumber() {
    final text = cardNumberController.text.replaceAll(RegExp(r'\D'), '');
    var formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) formatted += ' ';
      formatted += text[i];
    }
    cardNumberController.value = cardNumberController.value.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  void _formatExpiryDate() {
    final text = expiryDateController.text.replaceAll(RegExp(r'\D'), '');
    var formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2 && text.length > 2) formatted += '/';
      formatted += text[i];
    }
    expiryDateController.value = expiryDateController.value.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  @override
  void initState() {
    super.initState();
    cardNumberController.addListener(() {
      _formatCardNumber();
      updateCardDisplay();
    });
    expiryDateController.addListener(() {
      _formatExpiryDate();
      updateCardDisplay();
    });
    nameController.addListener(updateCardDisplay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة بطاقة جديدة'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CardPreview(
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  nameOnCard: nameOnCard,
                  cardType: cardType,
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Card Number",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: cardNumberController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.credit_card),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                      ],
                      validator: _validateCardNumber,
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('تاريخ الانتهاء (MM/YY)',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: expiryDateController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: _validateExpiryDate,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("CVV",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: cvvController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.lock),
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(4),
                            ],
                            validator: _validateCVV,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('اسم حامل البطاقة',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: _validateName,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('تمت إضافة البطاقة بنجاح')),
                        );
                      }
                    },
                    child: const Text(
                      'إضافة البطاقة',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
