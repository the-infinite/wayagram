import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

class WayaHelpers {
  static String extractFileName(File? imageFile) {
    return imageFile == null ? 'file is null' : imageFile.path.split('/').last;
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
    String formattedCurrency =
        NumberFormat.currency(locale: 'en_US', symbol: '₦').format(price);

    return formattedCurrency;
  }

  static void countFormCharacters(TextEditingController contoller, int length) {
    if (contoller.text.length >= length) {
      contoller.text = contoller.text.substring(0, length);

      contoller.selection = TextSelection.fromPosition(
        TextPosition(offset: contoller.text.length),
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

  static String calculatedDiscountPrice(String price, int pct) {
    int intPrice = double.parse(price).toInt();

    double discount = intPrice - (intPrice * (pct / 100));

    return formatPrice(discount.toInt());
  }

  static String removecamelCase(String text) {
    final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
    final words = text.split(regex);
    return words.map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
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

}
