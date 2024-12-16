import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PlacedOrdersScreen extends StatefulWidget {
  @override
  State<PlacedOrdersScreen> createState() => _PlacedOrdersScreenState();
}

class _PlacedOrdersScreenState extends State<PlacedOrdersScreen> {
  List<Map<String, dynamic>> savedOrders = [];

  @override
  void initState() {
    super.initState();
    _loadSavedOrders();
  }

  void _loadSavedOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ordersJson = prefs.getString('saved_orders');
    if (ordersJson != null) {
      savedOrders = List<Map<String, dynamic>>.from(jsonDecode(ordersJson));
    }
    setState(() {});
  }

  // Function to create the PDF receipt
  Future<void> _printReceipt(Map<String, dynamic> order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text('Receipt', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Product: ${order['productName']}'),
              pw.Text('Delivery Address: ${order['deliveryAddress']}'),
              pw.Text('Schedule: ${order['deliverySchedule']}'),
              pw.Text('Payment: ${order['paymentMethod']}'),
            ],
          );
        },
      ),
    );

    // Printing the PDF
    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('My orders', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
      ),
      body: ListView.builder(
        itemCount: savedOrders.length,
        itemBuilder: (context, index) {
          final order = savedOrders[index];
          return Container(
            color: Colors.white,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              child: Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.orange)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Product: ${order['productName']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Delivery Address: ${order['deliveryAddress']}'),
                        Text('Schedule: ${order['deliverySchedule']}'),
                        Text('Payment: ${order['paymentMethod']}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.print),
                      onPressed: () {
                        _printReceipt(order);
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
