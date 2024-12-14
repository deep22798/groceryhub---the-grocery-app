import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/controller/cartcontroller.dart';
import 'package:grocery/controller/dashboardcontroller.dart';
import 'package:grocery/view/cart/cart.dart';
import 'package:grocery/view/checkout/checkout.dart';
import 'package:grocery/view/items/itemdetails.dart';
import 'package:shimmer/shimmer.dart';

class Itemscreen extends StatefulWidget {
  final String category;
  Itemscreen({super.key, required this.category});

  @override
  State<Itemscreen> createState() => _ItemscreenState();
}

class _ItemscreenState extends State<Itemscreen> {
  final DashboardController dashboardController = Get.put(DashboardController());
  final CartController cartController = Get.put(CartController());
  var filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = dashboardController.filterItemsByName(widget.category);
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItems = dashboardController.filterItemsByName(widget.category);
      } else {
        filteredItems = filteredItems
            .where((item) => item.productGroup
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _sortItems(String sortType) {
    setState(() {
      if (sortType == 'Price: Low to High') {
        filteredItems.sort((a, b) =>
            (double.tryParse(a.salePrice.toString()) ?? 0.0)
                .compareTo(double.tryParse(b.salePrice.toString()) ?? 0.0));
      }
      else if (sortType == 'Price: High to Low') {
        filteredItems.sort((a, b) =>
            (double.tryParse(b.salePrice.toString()) ?? 0.0)
                .compareTo(double.tryParse(a.salePrice.toString()) ?? 0.0));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.category.toString() == '' ? 'All Products' : widget.category.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
          actions: [
            // Filter Icon with PopupMenuButton
            PopupMenuButton<String>(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onSelected: (value) {
                _sortItems(value);
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'Price: Low to High',
                    child: Text('Price: Low to High'),
                  ),
                  const PopupMenuItem(
                    value: 'Price: High to Low',
                    child: Text('Price: High to Low'),
                  ),
                ];
              },
            ),
            Obx(()=>InkWell(
              onTap: (){
                Get.to(()=>Cart());
              },
              child: Container(
                  height: 60,width: 60,
                  child: Stack(
                    children: [
                      Center(child: Icon(Icons.shopping_cart,size: 35,)),
                      Align(alignment: Alignment.topRight,
                        child: Card(
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle
                            ),height: 25,width: 25,
                            child: Center(child: Text("${cartController.cartList.length.toString()}")),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
            ),
          ],
          actionsIconTheme: const IconThemeData(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => _filterItems(value),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      hintText: 'Search items by name or category',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() {
                    if (dashboardController.loading.value) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 8, // Number of shimmer items
                              itemBuilder: (context, index) {
                                return Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 8.0),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                    if (filteredItems.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }
                    return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return InkWell(
                          onTap: (){
                            Get.to(()=>Itemdetails(product: item, productname: item.itmNam,));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                            elevation: 5,
                            shadowColor: Colors.orange,
                            margin: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.orange),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Image.asset(
                                          index % 2 == 0
                                              ? 'assets/images/group1.jpg'
                                              : 'assets/images/group2.jpg',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 5,
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.itmNam,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              Text(
                                                'MRP: ₹ ${item.mrp}', // Assuming item has a price
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                'Price: ₹ ${item.salePrice}', // Assuming item has a price
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                    SizedBox(width: 10,),
                                      Expanded(
                                        child: MaterialButton(onPressed: (){
                                          cartController.addToCart(item);
                                        },
                                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Text("Add to cart",style: const TextStyle(
                                                color: Colors.white,
                                              ),),SizedBox(width: 10,),
                                              Icon(Icons.add_shopping_cart),
                                            ],
                                          ),color: Colors.orange,
                                        ),
                                      ),SizedBox(width: 10,),
                                      Expanded(
                                        child: MaterialButton(onPressed: (){Get.to(() => CheckoutPage(), arguments: item);},
                                        child: Text("Buy Now",style: const TextStyle(
                                          color: Colors.white,
                                        ),),color: Colors.green,
                                        ),
                                      ),SizedBox(width: 10,),

                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
