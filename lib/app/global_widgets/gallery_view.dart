import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wayagram/app/global_widgets/view_photo.dart';
import 'package:wayagram/core/theme/app_colors.dart';
import 'package:wayagram/app/global_widgets/helpers/dark_mode_helper.dart';

class GalleryView extends StatelessWidget {
  final List<String> imageUrlList;
  final int crossAxisCount;
  GalleryView({super.key, required this.imageUrlList, this.crossAxisCount = 3});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: getAppColor(AppColors.background),
      body: GridView.builder(
          itemCount: imageUrlList.length,
          padding: EdgeInsets.only(left: 6, right: 6),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 6.0,
              mainAxisSpacing: 6.0),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
               /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) {
                          return ViewPhotos(
                            imageIndex: index,
                            imageList: imageUrlList,
                            heroTitle: "image$index",
                          );
                        },
                        fullscreenDialog: true));*/
              },
              child: Hero(
                  tag: "photo$index",
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: imageUrlList[index],
                    placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
            );
          }),
    );
  }
}
