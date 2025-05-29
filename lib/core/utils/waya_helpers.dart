// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:timeago/timeago.dart' as timeago;

class WayaHelpers {
  static String extractFileName(File? imageFile) {
    return imageFile == null ? 'null' : imageFile.uri.pathSegments.last;
  }

  static String? getContentType(File file) {
    final mimeType = lookupMimeType(file.path);

    return mimeType ?? 'application/octet-stream';
  }
  //?using imagePath
    static String? getContentTypeFromPath(String contentPathUrl) {
    final mimeType = lookupMimeType(contentPathUrl);

    return mimeType ?? 'application/octet-stream';
  }

  static String formatMetrics(int number) {
    if (number == 0) return "0";

    const List<String> suffixes = ["", "K", "M", "B", "T"];
    int suffixIndex = (number == 0) ? 0 : (math.log(number) ~/ math.log(1000));

    if (suffixIndex == 0) {
      return number.toString();
    }

    double shortValue = number / math.pow(1000, suffixIndex);
    return "${shortValue.toStringAsFixed(1)}${suffixes[suffixIndex]}";
  }

  static String formatTimeAgo(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return timeago.format(dateTime);
  }

  static String toOrdinal(int number) {
    if (number < 1) return number.toString();
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '${number}th';
    }
    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  static String formatPrice(int price) {
    String formattedCurrency = NumberFormat.currency(locale: 'en_US', symbol: '₦').format(price);

    return formattedCurrency;
  }

  static void countFormCharacters(TextEditingController controller, int length) {
    if (controller.text.length >= length) {
      controller.text = controller.text.substring(0, length);

      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    }
  }

  static String formatDateString(String? isoDateString) {
    if (isoDateString == null) return '';
    // Parse the ISO 8601 date string into a DateTime object
    DateTime date = DateTime.parse(isoDateString);

    // Define the desired format using DateFormat
    DateFormat dateFormat = DateFormat('MMMM dd, yyyy'); // "August 10, 2020"

    // Format the DateTime object into the desired string
    return dateFormat.format(date);
  }

  static String formatDateMonthYear(String isoDate) {
    // Parse the ISO 8601 string into a DateTime object
    DateTime dateTime = DateTime.parse(isoDate);

    // Format the DateTime object to the desired string format (e.g., "December 2021")
    return DateFormat('MMMM yyyy').format(dateTime);
  }

  static Future<MultipartFile> formattedImage(File file) async {
    final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

    return await MultipartFile.fromFile(
      file.path,
      filename: file.uri.pathSegments.last,
      contentType: MediaType.parse(mimeType),
    );
  }

  static Future<MultipartFile> formattedImageFromUrl(String imageUrl) async {
    // Download
    debugPrint("?? $imageUrl");
    final response = await http.get(Uri.parse(imageUrl));
    debugPrint("??? 2");
    if (response.statusCode == 200) {
      final fileName = basename(Uri.parse(imageUrl).path);

      final mimeType = lookupMimeType(fileName) ?? 'application/octet-stream';

      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/$fileName');
      await tempFile.writeAsBytes(response.bodyBytes);

      return MultipartFile.fromFile(
        tempFile.path,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      );
    } else {
      throw Exception('Failed to download image from URL');
    }
  }

  static String calculatedDiscountPrice(String price, int pct) {
    int intPrice = double.parse(price).toInt();

    double discount = intPrice - (intPrice * (pct / 100));

    return formatPrice(discount.toInt());
  }

  static String removeCamelCaseAndUnderscore(String text) {
    final regex = RegExp(r'(?<=[a-z])(?=[A-Z])|_');
    final words = text.split(regex);
    return words
        .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '')
        .join(' ');
  }

  static String abbreviateNumber(int number) {
    if (number >= 1000000000) {
      return _formatNumber(number, 1000000000, "B");
    } else if (number >= 1000000) {
      return _formatNumber(number, 1000000, "M");
    } else if (number >= 1000) {
      return _formatNumber(number, 1000, "K");
    } else {
      return number.toString();
    }
  }

  static String _formatNumber(int number, int divisor, String suffix) {
    double result = number / divisor;
    return result % 1 == 0 ? "${result.toInt()}$suffix" : "${result.toStringAsFixed(1)}$suffix";
  }

  static String format24HRSToAPM(String time) {
    // Parse the input time (HH:mm)
    final parsedTime = DateFormat("HH:mm").parse(time);

    // Format it to 12-hour format with am/pm
    return DateFormat("h:mma").format(parsedTime).toLowerCase();
  }
}
