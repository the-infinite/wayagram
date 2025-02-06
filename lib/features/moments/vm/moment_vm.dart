import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wayagram/features/moments/data/model/moment_state.dart';

class MomentVm extends StateNotifier<MomentState> {
  final Ref ref;
  MomentVm(this.ref)
      : super(MomentState(
          backgroundColor: const Color(0xFF1D2939),
          textStyle: GoogleFonts.roboto(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ));

  void updateBackgroundColor(Color color) {
    state = state.copyWith(backgroundColor: color);
  }

  void updateTextStyle(TextStyle style) {
    state = state.copyWith(textStyle: style);
  }

  void updateText(String text) {
    state = state.copyWith(text: text);
  }
   void setStatusType(StatusType type) {
    state = state.copyWith(type: type);
  }

   void updateCaption(String caption) {
    state = state.copyWith(caption: caption);
  }

  void setSelectedImage(File? image) {
    state = state.copyWith(selectedImage: image);
  }

   void clearImage() {
    state = state.copyWith(selectedImage: null, caption: '');
  }
   void toggleCaptionVisibility() {
    state = state.copyWith(showCaption: !state.showCaption);
  }

  void cycleBackgroundColor() {
    final colors = [
      const Color(0xFF1D2939),
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
    ];

    final currentIndex = colors.indexOf(state.backgroundColor);
    final nextIndex = (currentIndex + 1) % colors.length;
    updateBackgroundColor(colors[nextIndex]);
  }

  void cycleFontStyle() {
    final fonts = [
      GoogleFonts.roboto(),
      GoogleFonts.playfairDisplay(),
      GoogleFonts.lobster(),
      GoogleFonts.pacifico(),
      GoogleFonts.permanentMarker(),
    ];

    final currentFont = state.textStyle.fontFamily;
    final currentIndex =
        fonts.indexWhere((font) => font.fontFamily == currentFont);
    final nextIndex = (currentIndex + 1) % fonts.length;

    updateTextStyle(fonts[nextIndex].copyWith(
      fontSize: 32,
      color: Colors.white,
      fontWeight: FontWeight.w500,
    ));
  }

  Future<void> submitMoment() async {
    final text = state.text;
    final backgroundColor = state.backgroundColor;
    final textStyle = state.textStyle;

    
    print('Submitting moment:');
    print('Text: $text');
    print('Background Color: $backgroundColor');
    print('Text Style: $textStyle');
  }
}

final momentVmProvider = StateNotifierProvider<MomentVm, MomentState>((ref) {
  return MomentVm(ref);
});
