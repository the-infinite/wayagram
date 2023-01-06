import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wayagram/app/modules/home/widgets/product_view.dart';

import '../../../controllers/home_controller.dart';
import '../../../data/model/all_events_entity.dart';
import '../../../data/model/all_posts_entity.dart';
import '../../../data/model/products_model_entity.dart';
import '../../../data/providers/api_response.dart';
import '../../../data/providers/my_pref.dart';
import '../widgets/posts_view.dart';

class ShopsTab extends StatelessWidget {
  ShopsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerWayagram>(builder: (controller) {
      return SizedBox(
        width: Get.width,
        height: Get.height*0.75,
        child: TabBarView(
          controller: controller.shopController,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<ApiResponse>(
                      future: controller.getAllProducts,
                      builder: (context, snapshot) {
                        var savedPosts = MyPref.allProducts.val;
                        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                          final posts = snapshot.data!.data as ProductsModelEntity;
                          return ProductView(posts: posts.data!);
                        } else if(savedPosts.isNotEmpty){
                          var posts = ProductsModelEntity.fromJson(jsonDecode(savedPosts));
                          return ProductView(posts: posts.data!);
                        }else{
                          if(snapshot.connectionState == ConnectionState.done){
                            return SizedBox.shrink();
                          }
                          return ProductView(isLoading: true);
                        }
                      }),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<ApiResponse>(
                      future: controller.getMyProducts,
                      builder: (context, snapshot) {
                        var savedPosts = MyPref.myProducts.val;
                        if (snapshot.connectionState == ConnectionState.done && snapshot.data!.isSuccessful) {
                          final posts = snapshot.data!.data as ProductsModelEntity;
                          return ProductView(posts: posts.data!,showBuyButton: false);
                        } else if(savedPosts.isNotEmpty){
                          var posts = ProductsModelEntity.fromJson(jsonDecode(savedPosts));
                          return ProductView(posts: posts.data!,showBuyButton: false);
                        }else{
                          if(snapshot.connectionState == ConnectionState.done){
                            return SizedBox.shrink();
                          }
                          return ProductView(isLoading: true,showBuyButton: false);
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}