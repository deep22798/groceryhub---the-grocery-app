import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/model/itemmastermodel.dart';
import 'package:grocery/controller/cartcontroller.dart';
import 'package:grocery/view/cart/cart.dart';
import 'package:grocery/view/checkout/checkout.dart';

class Itemdetails extends StatefulWidget {
  final ItemMasterModel product;
  final String productname;

  Itemdetails({super.key, required this.product, required this.productname});

  @override
  State<Itemdetails> createState() => _ItemdetailsState();
}

class _ItemdetailsState extends State<Itemdetails> {
  // Get instance of the CartController
  final CartController cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productname.toString(),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          Obx(() => InkWell(
            onTap: () {
              Get.to(() => Cart());
            },
            child: Container(
              height: 60,
              width: 60,
              child: Stack(
                children: [
                  Center(child: Icon(Icons.shopping_cart, size: 35)),
                  Align(
                    alignment: Alignment.topRight,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        height: 25,
                        width: 25,
                        child: Center(child: Text("${cartController.cartList.length.toString()}")),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
        backgroundColor: Colors.orange,
        actionsIconTheme: const IconThemeData(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.product.imageFile != null
                  ? Center(
                child: Image.network(
                  widget.product.imageFile!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/group1.jpg', fit: BoxFit.cover, height: 200, width: 200);
                  },
                ),
              )
                  : Center(
                child: Image.asset('assets/images/no_image.png', height: 200, width: 200),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  widget.product.itmNam ?? 'No Name Available',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('MRP', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('₹ ${widget.product.mrp ?? 'N/A'}', style: const TextStyle(fontSize: 16, color: Colors.red)),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Sale Price', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('₹ ${widget.product.salePrice ?? 'N/A'}', style: const TextStyle(fontSize: 16, color: Colors.green)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const Text('Product Details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildDetailRow('Item Code', widget.product.itmCd),
              _buildDetailRow('Item Name', widget.product.itmNam),
              _buildDetailRow('Generic Name', widget.product.genname),
              _buildDetailRow('Department', widget.product.department),
              _buildDetailRow('Color', widget.product.iColor),
              _buildDetailRow('Size', widget.product.iSize),
              _buildDetailRow('Material', widget.product.material),
              _buildDetailRow('Product Group', widget.product.productGroup),
              _buildDetailRow('Final Stock', widget.product.finalStock),
              _buildDetailRow('GST Item Code', widget.product.gstitmcd),
              _buildDetailRow('HSN Code', widget.product.stkhsnCode),
              _buildDetailRow('SGST Rate', widget.product.stksgstRate),
              _buildDetailRow('CGST Rate', widget.product.stkcgstRate),
              _buildDetailRow('IGST Rate', widget.product.stkigstRate),
              _buildDetailRow('PLU Code', widget.product.plucode),
              _buildDetailRow('Wholesale Price', widget.product.wsPrice),
              _buildDetailRow('Units', widget.product.units),
              _buildDetailRow('Type', widget.product.type),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            heroTag: 'addToCart', // Unique tag for this button
            onPressed: () {
              cartController.addToCart(widget.product);
            },
            label: const Text('Add to Cart'),
            icon: const Icon(Icons.add_shopping_cart),
            backgroundColor: Colors.orange,
          ),
          FloatingActionButton.extended(
            heroTag: 'buyNow', // Unique tag for this button
            onPressed: () {
              // Navigate to CheckoutPage and pass the product details
              Get.to(() => CheckoutPage(), arguments: widget.product);
            },
            label: const Text('Buy Now'),
            icon: const Icon(Icons.shopping_bag),
            backgroundColor: Colors.green,
          ),

        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildDetailRow(String title, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$title:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value?.toString() ?? 'N/A',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
