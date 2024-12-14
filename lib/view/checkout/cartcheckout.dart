import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/controller/cartcontroller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartCheckoutPage extends StatefulWidget {
  @override
  State<CartCheckoutPage> createState() => _CartCheckoutPageState();
}

class _CartCheckoutPageState extends State<CartCheckoutPage> {
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

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:grocery/controller/cartcontroller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CartCheckoutPage extends StatefulWidget {
//   @override
//   State<CartCheckoutPage> createState() => _CartCheckoutPageState();
// }
//
// class _CartCheckoutPageState extends State<CartCheckoutPage> {
//   final CartController cartController = Get.find<CartController>();
//   final TextEditingController addressController = TextEditingController();
//   String selectedDeliverySchedule = "Select Delivery Schedule";
//   String selectedPaymentMethod = "Select Payment Method";
//
//   String? deliveryAddress;
//   String? deliverySchedule;
//   String? paymentMethod;
//
//   // To store the addresses
//   List<String> savedAddresses = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Checkout',
//           style: const TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.orange,
//         actionsIconTheme: const IconThemeData(color: Colors.white),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(  // Wrap the entire content to make it scrollable
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Display Cart Items
//               Text(
//                 'Items in Cart',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 10),
//
//               // Cart List
//               ListView.builder(
//                 shrinkWrap: true,  // Makes the ListView take only the space it needs
//                 physics: NeverScrollableScrollPhysics(),  // Prevent scrolling in ListView
//                 itemCount: cartController.cartList.length,
//                 itemBuilder: (context, index) {
//                   final item = cartController.cartList[index];
//                   return Card(
//                     elevation: 2,
//                     margin: const EdgeInsets.symmetric(vertical: 5),
//                     child: ListTile(
//                       leading: Image.asset(
//                         'assets/images/group1.jpg',
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                       ),
//                       title: Text(item.itmNam),
//                       subtitle: Text('Price: ₹${item.salePrice}'),
//                     ),
//                   );
//                 },
//               ),
//
//               // Address Input
//               SizedBox(height: 20),
//               Text(
//                 'Enter Delivery Address',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               TextField(
//                 onChanged: (value) => deliveryAddress = value,
//                 decoration: InputDecoration(
//                   labelText: 'Enter your delivery address',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: _saveAddress,
//                 child: const Text('Save Address'),
//               ),
//               const SizedBox(height: 10),
//               if (savedAddresses.isNotEmpty)
//                 DropdownButton<String>(
//                   hint: const Text('Select a saved address'),
//                   value: deliveryAddress,
//                   onChanged: (value) {
//                     setState(() {
//                       deliveryAddress = value;
//                     });
//                   },
//                   items: savedAddresses.map((String address) {
//                     return DropdownMenuItem<String>(
//                       value: address,
//                       child: Text(address),
//                     );
//                   }).toList(),
//                 ),
//               SizedBox(height: 20),
//
//               // Delivery Schedule
//               Text(
//                 'Select Delivery Schedule',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               ListTile(
//                 title: const Text('Morning (9 AM - 12 PM)'),
//                 leading: Radio<String>(
//                   value: 'Morning (9 AM - 12 PM)',
//                   groupValue: deliverySchedule,
//                   onChanged: (value) => setState(() => deliverySchedule = value),
//                 ),
//               ),
//               ListTile(
//                 title: const Text('Afternoon (12 PM - 3 PM)'),
//                 leading: Radio<String>(
//                   value: 'Afternoon (12 PM - 3 PM)',
//                   groupValue: deliverySchedule,
//                   onChanged: (value) => setState(() => deliverySchedule = value),
//                 ),
//               ),
//               ListTile(
//                 title: const Text('Evening (3 PM - 6 PM)'),
//                 leading: Radio<String>(
//                   value: 'Evening (3 PM - 6 PM)',
//                   groupValue: deliverySchedule,
//                   onChanged: (value) => setState(() => deliverySchedule = value),
//                 ),
//               ),
//
//               SizedBox(height: 20),
//
//               // Payment Method
//               Text(
//                 'Select Payment Method',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               DropdownButton<String>(
//                 value: selectedPaymentMethod,
//                 isExpanded: true,
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedPaymentMethod = newValue!;
//                   });
//                 },
//                 items: <String>[
//                   'Select Payment Method',
//                   'Cash on Delivery',
//                   'Credit/Debit Card',
//                   'UPI',
//                 ].map<DropdownMenuItem<String>>((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//               ),
//               SizedBox(height: 30),
//
//               // Place Order Button
//               ElevatedButton(
//                 onPressed: () {
//                   if (addressController.text.isEmpty ||
//                       selectedDeliverySchedule == 'Select Delivery Schedule' ||
//                       selectedPaymentMethod == 'Select Payment Method') {
//                     Get.snackbar('Error', 'Please complete all the fields');
//                   } else {
//                     // Handle Order Placement Logic
//                     Get.snackbar('Success', 'Order Placed Successfully');
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 14),
//                   textStyle: TextStyle(fontSize: 18),
//                 ),
//                 child: Text('Place Order'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Load saved addresses from SharedPreferences
//   void _loadSavedAddresses() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<String> savedList = prefs.getStringList('saved_addresses') ?? [];
//     setState(() {
//       savedAddresses = savedList;
//     });
//   }
//
//   // Save a new address (up to 3 addresses)
//   void _saveAddress() async {
//     if (deliveryAddress != null && deliveryAddress!.isNotEmpty) {
//       // Add the new address to the list
//       if (!savedAddresses.contains(deliveryAddress)) {
//         savedAddresses.add(deliveryAddress!);
//         if (savedAddresses.length > 3) {
//           savedAddresses.removeAt(0); // Remove the oldest address if more than 3
//         }
//         // Save updated addresses to SharedPreferences
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setStringList('saved_addresses', savedAddresses);
//         setState(() {}); // Trigger a rebuild to show updated addresses
//       }
//     }
//   }
// }
