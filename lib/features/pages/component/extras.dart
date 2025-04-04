import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Widget requiredIndicator() => const Row(children: [
      Text('*'),
      Padding(
          padding: EdgeInsets.only(left: 2), child: Text('Indicates Required'))
    ]);

Widget circleImage(String? url,
        {double radius = 25,
        String placeholder = 'assets/images/pages/user_placeholder.png'}) =>
    ClipOval(
        child: normalImage(url,
            placeholder: placeholder, width: radius * 2, height: radius * 2));

Widget normalImage(
  String? url, {
  String placeholder = 'assets/images/pages/image_placeholder.png',
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  List<String?> images = const [],
}) {
  int currentIndex = 0;
  return Stack(
    children: [
      CachedNetworkImage(
          imageUrl: url ?? '',
          fadeInDuration: const Duration(milliseconds: 300),
          fadeOutDuration: const Duration(milliseconds: 100),
          width: width,
          height: height,
          fit: fit,
          placeholder: (c, s) => Image.asset(placeholder, fit: fit, width: width, height: height),
          errorWidget: (c, s, o) => Image.asset(placeholder, fit: fit, width: width, height: height)),

    ],
  );
}

class NormalImage extends StatefulWidget {
  NormalImage({super.key, this.width, this.height, this.fit, this.images, this.url});
  double? width;
  double? height;
  BoxFit? fit = BoxFit.cover;
  List<String?>? images = const [];
  String? url;

  @override
  State<NormalImage> createState() => _NormalImageState();
}

class _NormalImageState extends State<NormalImage> {
  late PageController _pageController;
  String placeholder = 'assets/images/pages/image_placeholder.png';
  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    // TODO: implement initState
    super.initState();
  }

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      widget.images!.length == 1 ?  CachedNetworkImage(
          imageUrl: widget.url ?? '',
          fadeInDuration: const Duration(milliseconds: 300),
          fadeOutDuration: const Duration(milliseconds: 100),
          width: double.maxFinite,
          height: 350,
          fit: BoxFit.cover,
          placeholder: (c, s) => Image.asset(placeholder, fit: widget.fit, width: widget.width, height: widget.height),
          errorWidget: (c, s, o) => Image.asset(placeholder, fit: widget.fit, width: widget.width, height: widget.height))
          :  CarouselSlider(
          items: widget.images?.map((imgPath) {
            return  CachedNetworkImage(
                imageUrl: imgPath ?? '',
                fadeInDuration: const Duration(milliseconds: 300),
                fadeOutDuration: const Duration(milliseconds: 100),
                width: double.maxFinite,
                height: 350,
                fit: BoxFit.cover,
                placeholder: (c, s) => Image.asset(placeholder, fit: widget.fit, width: widget.width, height: widget.height),
                errorWidget: (c, s, o) => Image.asset(placeholder, fit: widget.fit, width: widget.width, height: widget.height));
          }).toList(),
          options: CarouselOptions(
            height: 350,
            viewportFraction: 1,
            autoPlay: false,
            enlargeCenterPage: false,
            onPageChanged: (index, reason){
              setState(() {
                _currentIndex = index;
              });
            }
          ),
        ),
        /*Positioned(
            right: 20,
            top: 20,
            child: SvgPicture.asset("assets/icons/brands/multi_image.svg")),*/
        widget.images!.length < 2 ? const SizedBox.shrink() : Positioned(
          bottom: 10,
          right: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.images!.map((url) {
              int index = widget.images!.indexOf(url);
              return Container(
                width: 15,
                height: 5.0,
                margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  //shape: BoxShape.circle,
                  borderRadius: BorderRadius.circular(10),
                  color: _currentIndex == index
                      ? const Color(0xFF1A237E)
                      : Colors.white,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

