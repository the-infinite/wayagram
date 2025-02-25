import 'package:wayagram/core/data/model/model.dart';
class FilterOptions {
  static const List<String> categories = [
    'All Category',
    'Fashion',
    'Gaming',
    'Gadgets',
    'Electronics',
    'Jewelries',
    'Food',
    'Kitchen Appliances',
    'Others',
  ];

  static final List<Select> deliveryTypes = [
    Select(label: 'Delivery', value: 'Delivery'),
    Select(label: 'Pickup', value: 'Pickup'),
    Select(label: 'Both', value: 'Both')
  ];


  static const List<String> discountTypes = [
    '50% or More',
    '40% or More',
    '30% or More',
    '20% or More',
    '10% or More',
  ];

  static const List<String> heightOptions = [
    'Less than 30m',
    'Greater than 30m',
    'Less than 40m',
    'Greater than 40m',
    'Less than 50m',
  ];

  static const List<String> depthOptions = [
    'Less than 6ft',
    'Greater than 6ft',
    'Less than 10ft',
    'Greater than 10ft',
    'Less than 12ft',
  ];

  static final List<Select> conditions = [
    Select(label: 'New', value: 'New'),
    Select(label: 'Used', value: 'Used'),
  ];

  static const List<String> locationOptions = [
    'Less than 6ft',
    'Greater than 6ft',
    'Less than 10ft',
    'Greater than 10ft',
    'Less than 12ft',
  ];


 static final List<Select> colorOptions = [
    Select(value: "#FF0000", label: "Red"),
    Select(value: "#00FF00", label: "Green"),
    Select(value: "#0000FF", label: "Blue"),
    Select(value: "#FFFF00", label: "Yellow"),
    Select(value: "#800080", label: "Purple"),
    Select(value: "#FFA500", label: "Orange"),
    Select(value: "#FFC0CB", label: "Pink"),
    Select(value: "#008080", label: "Teal"),
    Select(value: "#A52A2A", label: "Brown"),
    Select(value: "#808080", label: "Gray"),
    Select(value: "#000000", label: "Black"),
    Select(value: "#FFFFFF", label: "White"),
    Select(value: "#FF4500", label: "Orange Red"),
    Select(value: "#1E90FF", label: "Dodger Blue"),
    Select(value: "#32CD32", label: "Lime Green"),
    Select(value: "#FFD700", label: "Gold"),
    Select(value: "#8A2BE2", label: "Blue Violet"),
    Select(value: "#FF69B4", label: "Hot Pink"),
    Select(value: "#00CED1", label: "Dark Turquoise"),
    Select(value: "#DC143C", label: "Crimson"),
  ];
}