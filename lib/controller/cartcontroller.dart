import 'dart:convert';
import 'package:get/get.dart';
import 'package:grocery/model/itemmastermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartController extends GetxController {
  var cartList = <ItemMasterModel>[].obs; // List of ItemMasterModel instead of dynamic

  @override
  void onInit() {
    super.onInit();
    loadCartItems(); // Load saved cart items when the controller initializes
  }

  // Add item to the cart
  void addToCart(ItemMasterModel item) {
    // Check if the item already exists in the cart
    bool itemExists = cartList.any((cartItem) => cartItem.itmNam == item.itmNam); // Using dot notation

    if (itemExists) {
      Get.snackbar('Notice', '${item.itmNam} is already in the cart');
    } else {
      cartList.add(item);
      saveCartItems(); // Save cart after adding an item
      Get.snackbar('Success', '${item.itmNam} added to cart');
    }
  }

  // Remove item from the cart
  void removeFromCart(ItemMasterModel item) {
    cartList.removeWhere((cartItem) => cartItem.itmNam == item.itmNam); // Using dot notation
    saveCartItems(); // Save cart after removing an item
    Get.snackbar('Removed', '${item.itmNam} removed from cart');
  }

// Save cart items to SharedPreferences
  Future<void> saveCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cartItems = cartList.map((item) => jsonEncode(item.toJson())).toList();
    await prefs.setStringList('cartItems', cartItems);
  }

// Load cart items from SharedPreferences
  Future<void> loadCartItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cartItems');
    if (cartItems != null) {
      cartList.value = cartItems.map((item) => ItemMasterModel.fromJson(jsonDecode(item))).toList();
    }
  }

}
