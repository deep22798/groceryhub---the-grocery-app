import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grocery/controller/dashboardcontroller.dart';
import 'package:grocery/view/items/itemscreen.dart';
import 'package:shimmer/shimmer.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final DashboardController dashboardController = Get.put(DashboardController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('All Categories',style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,actionsIconTheme: IconThemeData(color: Colors.white),iconTheme: IconThemeData(color: Colors.white),),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 20,),
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
                          itemCount: dashboardController.itemsGroupList.length, // Number of shimmer items
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
                    itemCount: dashboardController.itemsGroupList.length,
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

              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
