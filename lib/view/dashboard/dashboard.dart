import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/controller/cartcontroller.dart';
import 'package:grocery/controller/dashboardcontroller.dart';
import 'package:grocery/view/cart/cart.dart';
import 'package:grocery/view/categories/categories.dart';
import 'package:grocery/view/items/itemdetails.dart';
import 'package:grocery/view/items/itemscreen.dart';
import 'package:grocery/view/orders/placedorder.dart';
import 'package:shimmer/shimmer.dart';

class Dashboard extends StatefulWidget {
   Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  final DashboardController dashboardController = Get.put(DashboardController());

  final CartController cartController = Get.put(CartController());


@override
  void initState() {
    super.initState();
    dashboardController.fetchItemGroups();
    dashboardController.fetchItemMaster();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('assets/images/logo.png',height: 160,),
                          Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(child: Text("Grocery HUB",style: GoogleFonts.alumniSans(fontSize: 50,fontWeight: FontWeight.bold,color: Colors.green.shade700))),
                              Container(child: Text("The complete grocery solution is here",style: TextStyle(color:Colors.orange),)),
                            ],
                          ),
                     InkWell(
                        onTap: (){
                          Get.to(()=>PlacedOrdersScreen());
                        },
                        child: Container(
                          height: 40,width: 40,
                          child: Center(child: Icon(Icons.card_travel_sharp,size: 35,color: Colors.green.shade700,)),
                        ),
                      ),Obx(()=>InkWell(
                        onTap: (){
                          Get.to(()=>Cart());
                        },
                        child: Container(
                          height: 40,width: 40,
                          child: Stack(
                            children: [
                              Center(child: Icon(Icons.shopping_cart,size: 35,color: Colors.green.shade700,)),
                              Align(alignment: Alignment.topRight,
                                child: Card(
                                  elevation: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.orange,
                                        shape: BoxShape.circle
                                    ),height: 20,width: 20,
                                    child: Center(child: Text("${cartController.cartList.length.toString()}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      )],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                  child: Center(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 170.0,
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 8,
                        enableInfiniteScroll: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        viewportFraction: 0.8,
                      ),
                      items: dashboardController.imageList.map((item) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: const BoxDecoration(color: Colors.white),
                              child: Image.network(item, fit: BoxFit.cover),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: Colors.green.shade700,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16,top: 8,bottom: 8,right: 8),
                              child: Text("Categories",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            ),
                          ),
                          Container(
                            child: InkWell(
                              onTap: (){
                                Get.to(()=>Categories());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('view all',style: TextStyle(color: Colors.green.shade700,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          if (dashboardController.loading.value) {
                            return Center(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // Number of columns
                                    crossAxisSpacing: 8.0, // Horizontal spacing between items
                                    mainAxisSpacing: 8.0, // Vertical spacing between items
                                    childAspectRatio: 1.0, // Space between rows
                                  ),
                                  itemCount: 8, // Number of shimmer items
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                    );
                                  },
                                ),
                              ),
                            ),);
                          }
                          if (dashboardController.itemsGroupList.isEmpty) {
                            return Center(child: Text('No data found'));
                          }
                          return GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // Number of columns
                              crossAxisSpacing: 8.0, // Horizontal spacing between items
                              mainAxisSpacing: 8.0, // Vertical spacing between items
                              childAspectRatio: 1.0, // Aspect ratio of each item
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              final group = dashboardController.itemsGroupList[index];
                              return InkWell(
                                onTap: (){
                                  Get.to(()=>Itemscreen(category: group.productGroup.toString()));
                                },
                                child: Card(
                                  elevation: 5,
                                  shadowColor: Colors.green,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.green)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: Image.asset(index%2==0?'assets/images/group1.jpg':'assets/images/group2.jpg',fit: BoxFit.cover,)),
                                        Container(width: double.infinity,
                                          color: Colors.green,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(
                                                group.productGroup,
                                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),

                      SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
          
              SizedBox(height: 10,),

              Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            color: Colors.orange.shade700,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16,top: 8,bottom: 8,right: 8),
                              child: Text("Products",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            ),
                          ),
                          Container(
                            child: InkWell(
                              onTap: (){
                                Get.to(()=>Itemscreen(category: ''));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('view all',style: TextStyle(color: Colors.orange.shade700,fontWeight: FontWeight.bold),),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(() {
                          if (dashboardController.loading.value) {
                            return Center(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, // Number of columns
                                    crossAxisSpacing: 8.0, // Horizontal spacing between items
                                    mainAxisSpacing: 8.0, // Vertical spacing between items
                                    childAspectRatio: 1.0, // Space between rows
                                  ),
                                  itemCount: 8, // Number of shimmer items
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                    );
                                  },
                                ),
                              ),
                            ),);
                          }
                          if (dashboardController.itemsGroupList.isEmpty) {
                            return Center(child: Text('No data found'));
                          }
                          return GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns
                              crossAxisSpacing: 8.0, // Horizontal spacing between items
                              mainAxisSpacing: 8.0, // Vertical spacing between items
                              childAspectRatio: 1.0, // Aspect ratio of each item
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              final group = dashboardController.itemsList[index];
                              return InkWell(
                                onTap: (){
                                  Get.to(()=>Itemdetails(product: group, productname: group.itmNam,));
                                },
                                child: Card(
                                  elevation: 5,
                                  shadowColor: Colors.orange,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.orange)
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: Image.asset(index%2==0?'assets/images/group1.jpg':'assets/images/group2.jpg',fit: BoxFit.cover,)),
                                        Container(width: double.infinity,
                                          color: Colors.orange,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(
                                                group.productGroup,
                                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),

                      SizedBox(height: 20,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
