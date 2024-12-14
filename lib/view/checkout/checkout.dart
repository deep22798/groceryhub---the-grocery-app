import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Get the product details from arguments
  final product = Get.arguments;

  @override
  void initState() {
    super.initState();
    _loadSavedAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                  decoration: InputDecoration(
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
                ListTile(
                  title: const Text('Morning (9 AM - 12 PM)'),
                  leading: Radio<String>(
                    value: 'Morning (9 AM - 12 PM)',
                    groupValue: deliverySchedule,
                    onChanged: (value) => setState(() => deliverySchedule = value),
                  ),
                ),
                ListTile(
                  title: const Text('Afternoon (12 PM - 3 PM)'),
                  leading: Radio<String>(
                    value: 'Afternoon (12 PM - 3 PM)',
                    groupValue: deliverySchedule,
                    onChanged: (value) => setState(() => deliverySchedule = value),
                  ),
                ),
                ListTile(
                  title: const Text('Evening (3 PM - 6 PM)'),
                  leading: Radio<String>(
                    value: 'Evening (3 PM - 6 PM)',
                    groupValue: deliverySchedule,
                    onChanged: (value) => setState(() => deliverySchedule = value),
                  ),
                ),
              ],
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Payment Selection'),
            content: Column(
              children: [
                ListTile(
                  title: const Text('Credit/Debit Card'),
                  leading: Radio<String>(
                    value: 'Credit/Debit Card',
                    groupValue: paymentMethod,
                    onChanged: (value) => setState(() => paymentMethod = value),
                  ),
                ),
                ListTile(
                  title: const Text('UPI (Google Pay, PhonePe)'),
                  leading: Radio<String>(
                    value: 'UPI (Google Pay, PhonePe)',
                    groupValue: paymentMethod,
                    onChanged: (value) => setState(() => paymentMethod = value),
                  ),
                ),
                ListTile(
                  title: const Text('Cash on Delivery'),
                  leading: Radio<String>(
                    value: 'Cash on Delivery',
                    groupValue: paymentMethod,
                    onChanged: (value) => setState(() => paymentMethod = value),
                  ),
                ),
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
            content: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.snackbar('Success', 'Order has been placed successfully!');
                  },
                  child: const Text('Place Order'),
                ),
              ],
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
    } else {
      Get.snackbar('Success', 'Order has been placed successfully!');
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  // Load saved addresses from SharedPreferences
  void _loadSavedAddresses() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList('saved_addresses') ?? [];
    setState(() {
      savedAddresses = savedList;
    });
  }

  // Save a new address (up to 3 addresses)
  void _saveAddress() async {
    if (deliveryAddress != null && deliveryAddress!.isNotEmpty) {
      // Add the new address to the list
      if (!savedAddresses.contains(deliveryAddress)) {
        savedAddresses.add(deliveryAddress!);
        if (savedAddresses.length > 3) {
          savedAddresses.removeAt(0); // Remove the oldest address if more than 3
        }
        // Save updated addresses to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('saved_addresses', savedAddresses);
        setState(() {}); // Trigger a rebuild to show updated addresses
      }
    }
  }
}
