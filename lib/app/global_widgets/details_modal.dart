import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsMedia extends StatelessWidget {
  const DetailsMedia({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;
  

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.4,
      child: Stack(
        children: [
          CarouselSlider.builder(
            itemCount: 3,
            itemBuilder: (context, i, x) => CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
            ),
            options:
                CarouselOptions(viewportFraction: 1, height: double.infinity),
          ),
          Center(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Positioned(
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            top: 0,
            right: 0,
            left: 0,
          ),
        ],
      ),
    );
  }
}
