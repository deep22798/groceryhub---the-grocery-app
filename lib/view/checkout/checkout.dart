import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonEncode and jsonDecode

class CheckoutPage extends StatefulWidget {
  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _currentStep = 0;

  String? deliveryAddress;
  String? deliverySchedule;
  String? paymentMethod;

  // To store the addresses
  List<String> savedAddresses = [];
  // To store the orders
  List<Map<String, dynamic>> savedOrders = [];

  // Get the product details from arguments
  final product = Get.arguments;

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
    _loadSavedOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Buy Now', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        onStepTapped: (step) => setState(() => _currentStep = step),
        steps: [
          Step(
            title: const Text('Delivery Address'),
            content: Column(
              children: [
                TextField(
                  onChanged: (value) => deliveryAddress = value,
                  decoration: const InputDecoration(
                    labelText: 'Enter your delivery address',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _saveAddress,
                  child: const Text('Save Address'),
                ),
                const SizedBox(height: 10),
                if (savedAddresses.isNotEmpty)
                  DropdownButton<String>(
                    hint: const Text('Select a saved address'),
                    value: deliveryAddress,
                    onChanged: (value) {
                      setState(() {
                        deliveryAddress = value;
                      });
                    },
                    items: savedAddresses.map((String address) {
                      return DropdownMenuItem<String>(
                        value: address,
                        child: Text(address),
                      );
                    }).toList(),
                  ),
              ],
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Delivery Schedule'),
            content: Column(
              children: [
                _buildRadioOption('Morning (9 AM - 12 PM)'),
                _buildRadioOption('Afternoon (12 PM - 3 PM)'),
                _buildRadioOption('Evening (3 PM - 6 PM)'),
              ],
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Payment Selection'),
            content: Column(
              children: [
                _buildPaymentOption('Credit/Debit Card'),
                _buildPaymentOption('UPI (Google Pay, PhonePe)'),
                _buildPaymentOption('Cash on Delivery'),
              ],
            ),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Review Order'),
            content: Column(
              children: [
                Text('Delivery Address: $deliveryAddress'),
                Text('Delivery Schedule: $deliverySchedule'),
                Text('Payment Method: $paymentMethod'),
                const SizedBox(height: 16),
                Text('Product Name: ${product?.itmNam ?? "N/A"}'),
                Text('Product Price: ₹${product?.salePrice ?? "N/A"}'),
                Text('Product Code: ${product?.itmCd ?? "N/A"}'),
              ],
            ),
            isActive: _currentStep >= 3,
            state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Place Order'),
            content: ElevatedButton(
              onPressed: _placeOrder,
              child: const Text('Place Order'),
            ),
            isActive: _currentStep >= 4,
            state: _currentStep > 4 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }

  void _onStepContinue() {
    if (_currentStep < 4) {
      setState(() => _currentStep += 1);
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  void _loadSavedAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    savedAddresses = prefs.getStringList('saved_addresses') ?? [];
    setState(() {});
  }

  void _loadSavedOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ordersJson = prefs.getString('saved_orders');
    if (ordersJson != null) {
      savedOrders = List<Map<String, dynamic>>.from(jsonDecode(ordersJson));
    }
    setState(() {});
  }

  void _saveAddress() async {
    if (deliveryAddress != null && deliveryAddress!.isNotEmpty) {
      if (!savedAddresses.contains(deliveryAddress)) {
        savedAddresses.add(deliveryAddress!);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('saved_addresses', savedAddresses);
        setState(() {});
      }
    }
  }

  void _placeOrder() async {
    if (deliveryAddress == null || deliverySchedule == null || paymentMethod == null) {
      Get.snackbar('Error', 'Please complete all steps before placing the order');
      return;
    }

    Map<String, dynamic> order = {
      'deliveryAddress': deliveryAddress,
      'deliverySchedule': deliverySchedule,
      'paymentMethod': paymentMethod,
      'productName': product?.itmNam ?? 'N/A',
      'productPrice': product?.salePrice ?? 'N/A',
      'productCode': product?.itmCd ?? 'N/A',

    };

    savedOrders.add(order);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_orders', jsonEncode(savedOrders));

    Get.snackbar('Success', 'Order has been placed successfully!');
  }

  Widget _buildRadioOption(String value) {
    return ListTile(
      title: Text(value),
      leading: Radio<String>(
        value: value,
        groupValue: deliverySchedule,
        onChanged: (newValue) => setState(() => deliverySchedule = newValue),
      ),
    );
  }

  Widget _buildPaymentOption(String value) {
    return ListTile(
      title: Text(value),
      leading: Radio<String>(
        value: value,
        groupValue: paymentMethod,
        onChanged: (newValue) => setState(() => paymentMethod = newValue),
      ),
    );
  }
}
