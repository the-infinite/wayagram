import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:svg_flutter/svg.dart';
import 'package:wayagram/assetsgen/assets.gen.dart';
import 'package:wayagram/core/theme/extension/colors_extension.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/moments/data/model/moment_state.dart';
import 'package:wayagram/features/moments/vm/moment_vm.dart';
import 'package:wayagram/features/moments/widgets/post_moment_widget.dart';

class Moment extends ConsumerStatefulWidget {
  static const route = "/moment";
  const Moment({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MomentViewState();
}

class _MomentViewState extends ConsumerState<Moment> {




  Future<void> _openImagePicker() async {
    await ref.read(momentVmProvider.notifier).pickMedia(context);
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(momentVmProvider);
    final wayaTheme = Theme.of(context);

     if (status.type == StatusType.media &&
         
          status.isImagePickerOpen) {
        _openImagePicker();
      }
    
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: status.backgroundColor,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: wayaTheme.colorScheme.white,
                          size: 22,
                        ),
                        onPressed: () {
                          ref.read(momentVmProvider.notifier).reset();
                          WayaNav.goBack();
                        }),
                    const Spacer(),
                    IconButton(
                      icon: SvgPicture.asset(WayaAssets.icons.cColorType.path),
                      onPressed: () {
                        ref
                            .read(momentVmProvider.notifier)
                            .cycleBackgroundColor();
                      },
                    ),
                    IconButton(
                      icon: SvgPicture.asset(WayaAssets.icons.cFontStyle.path),
                      onPressed: () {
                        ref.read(momentVmProvider.notifier).cycleFontStyle();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                  child:
                      textMoment(context: context, ref: ref, status: status)),
              if (status.text.isEmpty) ...[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  decoration: BoxDecoration(
                    color: wayaTheme.colorScheme.white.withOpacity(0.1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _TabButton(
                        label: 'Text',
                        isSelected: status.type == StatusType.text,
                        onTap: () {
                          ref
                              .read(momentVmProvider.notifier)
                              .setStatusType(StatusType.text);
                        },
                      ),
                      _TabButton(
                        label: 'Media',
                        isSelected: status.type == StatusType.media,
                        onTap: () {
                          ref
                              .read(momentVmProvider.notifier)
                              .setStatusType(StatusType.media);
                          _openImagePicker();
                        },
                      ),
                    ],
                  ),
                ),
              ] else ...[
                PostMomentWidget()
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget textMoment(
      {required BuildContext context,
      required WidgetRef ref,
      required MomentState status}) {
    final wayaTheme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); // keyboard
      },
      child: Container(
        padding: const EdgeInsets.all(24.0),
        alignment: Alignment.center,
        child: TextField(
          style: status.textStyle,
          decoration: InputDecoration(
            border: InputBorder.none,
            counterText: '',
            hintText: 'Type your moment',
            hintStyle: status.textStyle.copyWith(
              color: wayaTheme.colorScheme.white.withOpacity(0.5),
            ),
          ),
          textAlign: TextAlign.center,
          maxLines: null,
          maxLength: 100,
          onChanged: (value) {
            ref.read(momentVmProvider.notifier).updateText(value);
          },
          onSubmitted: (value) {
            ref.read(momentVmProvider.notifier).submitMoment();
          },
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final wayaTheme = Theme.of(context);
    return Expanded(
      child: Material(
        color: wayaTheme.colorScheme.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? wayaTheme.colorScheme.white
                    : wayaTheme.colorScheme.white.withOpacity(0.5),
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
