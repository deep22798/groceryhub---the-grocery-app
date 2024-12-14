import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/controller/cartcontroller.dart';
import 'package:grocery/view/checkout/cartcheckout.dart';

class Cart extends StatefulWidget {
  Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final CartController cartController = Get.find<CartController>(); // GetX Controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        actionsIconTheme: const IconThemeData(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (cartController.cartList.isEmpty) {
          return const Center(
            child: Text(
              'Your cart is empty.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartList.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartList[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      leading: Image.asset(
                        'assets/images/group1.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        item.itmNam,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Price: ₹${item.salePrice}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          cartController.removeFromCart(item); // Remove item from cart
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => CartCheckoutPage()); // Navigate to Checkout Page
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Proceed to Checkout'),
              ),
            ),
          ],
        );
      }),
    );
  }
}
