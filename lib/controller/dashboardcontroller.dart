import 'dart:convert';

import 'package:get/get.dart';
import 'package:grocery/model/itemgroupmodel.dart';
import 'package:grocery/model/itemmastermodel.dart';
import 'package:grocery/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardController extends GetxController{

  var loading =true.obs;
  var itemsList = <ItemMasterModel>[].obs;
  var itemsGroupList = <ItemGroupModel>[].obs;
  List<ItemMasterModel> filterItemsByName(String itemName) {
    return itemsList.where((item) =>
    item.department?.toLowerCase().contains(itemName.toLowerCase()) ?? false
    ).toList();
  }
  void filterAndDisplay(String searchQuery) {
    var filteredItems = filterItemsByName(searchQuery);
    // Display the filtered items (e.g., in a ListView)
    for (var item in filteredItems) {
      print("Item Name: ${item.department}, Department: ${item.productGroup}");
    }
  }


  Future<void> fetchItemMaster() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('itemmaster');

    if (jsonData != null) {
      // Decode the stored JSON string into a list
      List<dynamic> decodedData = jsonDecode(jsonData);
      itemsList.value = decodedData.map((e) => ItemMasterModel.fromJson(e)).toList();
      print("Fetch Successfully");
      loading(false);
    } else {
      try {
        final response = await http.post(
          Uri.parse(Constants.BASEURL),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            "title": "GetStockItemListJason",
            "description": "GetItemList"
          },
        ).timeout(const Duration(seconds: 10));

        print("Response status code: ${response.statusCode}");
        print("Response body of Item list: ${response.body}");

        if (response.statusCode == 200) {
          // Extracting the JSON part of the response
          final jsonResponse = response.body.split('||JasonEnd')[0].trim();

          // Decode the JSON (from string to list)
          final decodedJson = json.decode(jsonResponse);

          // Store the JSON as a string in SharedPreferences
          await prefs.setString('itemmaster', jsonEncode(decodedJson)); // 🔥 Use jsonEncode here

          print("SetString Successfully");
          print("Decoded JSON: $decodedJson");

          // Parse the list into a list of ItemMasterModel
          itemsList.value = List<ItemMasterModel>.from(
              decodedJson.map((data) => ItemMasterModel.fromJson(data))
          );

          print("Parsed Itemmaster Data: ${itemsList.toString()}");
        } else {
          Get.snackbar('Error', 'Failed to fetch data: ${response.statusCode}');
        }
      } catch (e) {
        print("Error occurred: $e");
        Get.snackbar('Error', 'An error occurred: $e');
      } finally {
        loading(false);
      }
    }
  }

  Future<void> fetchItemGroups() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('categorymaster');

    if (jsonData != null) {
      // Decode the stored JSON string into a list
      List<dynamic> decodedData = jsonDecode(jsonData);
      itemsGroupList.value =
          decodedData.map((e) => ItemGroupModel.fromJson(e)).toList();
      print("Fetch Successfully");
      loading(false);
    } else {
      try {
        final response = await http.post(
          Uri.parse(Constants.BASEURL),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            "title": "GetGroupMasterList",
            "description": "Request For GroupList",
            "ReqGroupType": "D",
            "ReqGroupName": "",
            "ReqSerType": "0"
          },
        ).timeout(const Duration(seconds: 10));

        print("Response status code: ${response.statusCode}");
        print("Response body of Item list: ${response.body}");


        // Check if the request was successful
        if (response.statusCode == 200) {
          // Extracting the JSON part of the response
          final jsonResponse = response.body.split('||JasonEnd')[0].trim();

          // Decode the JSON
          final decodedJson = json.decode(jsonResponse);

          // Store the JSON as a string in SharedPreferences
          await prefs.setString('categorymaster', jsonEncode(decodedJson)); // 🔥 Use jsonEncode here

          print("SetString Successfully for category");
          print("Decoded JSON: $decodedJson");

          print("fjbdsfdsjkfbdjksbksf" + decodedJson.toString());
          itemsGroupList.value = List<ItemGroupModel>.from(
              decodedJson.map((data) => ItemGroupModel.fromJson(data))
          );
          print("Parsed Itemgroup master Data: ${itemsGroupList.toString()}");
        } else {
          Get.snackbar('Error', 'Failed to fetch data: ${response.statusCode}');
        }
      } catch (e) {
        // Log the error for debugging purposes
        print("Error occurred: $e");
        Get.snackbar('Error', 'An error occurred: $e');
      } finally {
        // loading(false);
      }
    }
  }




  final List<String> imageList = [
    'https://img.freepik.com/free-photo/organic-vegetables-close-up-beautiful-young-woman-shopping-supermarket-buying-fresh-organic-vegetables_169016-2200.jpg?ga=GA1.1.349801002.1731152754&semt=ais_hybrid',
    'https://img.freepik.com/free-photo/girl-red-holding-different-vegetables-fruits-store_627829-9483.jpg?ga=GA1.1.349801002.1731152754&semt=ais_hybrid',
    'https://img.freepik.com/free-photo/shopping-cart-full-with-groceries-dark-backgrounds_1268-29511.jpg?ga=GA1.1.349801002.1731152754&semt=ais_hybrid',
    'https://img.freepik.com/free-photo/vegan-african-american-adult-feels-excited-about-ethically-sourced-bulk-products_482257-105116.jpg?ga=GA1.1.349801002.1731152754&semt=ais_hybrid',
    'https://img.freepik.com/free-photo/man-woman-with-medical-masks-out-grocery-shopping-with-shopping-cart_23-2149483207.jpg?ga=GA1.1.349801002.1731152754&semt=ais_hybrid',
    'https://img.freepik.com/free-photo/man-woman-shopping-grocery-store_23-2149483173.jpg?ga=GA1.1.349801002.1731152754&semt=ais_hybrid',
  ];

}