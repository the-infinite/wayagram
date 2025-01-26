import 'package:flutter/material.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:gap/gap.dart';

class CardLoadingState extends StatelessWidget {
  final int count;
  const CardLoadingState({super.key, this.count = 2});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final wayaTheme = Theme.of(context);
    return ListView.builder(
        shrinkWrap: true,
        itemCount: count,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.scaffoldColor,
                    border:
                        Border.all(color: wayaTheme.colorScheme.greyColor100),
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: wayaTheme.colorScheme.greyColor100,
                      ),
                    ),
                    const Gap(10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 15,
                          decoration: BoxDecoration(
                              color: wayaTheme.colorScheme.greyColor100,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        const Gap(3),
                        Container(
                          width: 200,
                          height: 15,
                          decoration: BoxDecoration(
                              color: wayaTheme.colorScheme.greyColor100,
                              borderRadius: BorderRadius.circular(8)),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Gap(10)
            ],
          );
        });
  }
}
