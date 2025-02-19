import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

final uuid = Uuid();

class RegisterFormNotifier extends StateNotifier<List<DynamicField>> {
  late TextEditingController fullName;
  late TextEditingController emailAddress;
  late TextEditingController address;
  late TextEditingController phoneNumber;
  String university = "";
  String selectedState = "";

  RegisterFormNotifier() : super([]) {
    fullName = TextEditingController();
    emailAddress = TextEditingController();
    address = TextEditingController();
    phoneNumber = TextEditingController();
  }

  // Add a text input field
  void addTextField() {
    state = [
      ...state,
      DynamicField(
        id: uuid.v4(),
        type: FieldType.text,
        textController: TextEditingController(),
      ),
    ];
  }

  // Add an image field
  void addImageField() {
    state = [
      ...state,
      DynamicField(
        id: uuid.v4(),
        type: FieldType.image,
      ),
    ];
  }

  // Remove a field by ID
  void removeField(String id) {
    state = state.where((field) => field.id != id).toList();
  }

  // Update image path for an image field
  void updateImage(String id, String imagePath) {
    state = state.map((field) {
      if (field.id == id && field.type == FieldType.image) {
        return field.copyWith(imagePath: imagePath);
      }
      return field;
    }).toList();
  }

  // Dispose text controllers when the notifier is destroyed
  @override
  void dispose() {
    for (var field in state) {
      field.textController?.dispose();
    }
    super.dispose();
  }
}

// Provider for the StateNotifier
final registerFormProvider =
    StateNotifierProvider<RegisterFormNotifier, List<DynamicField>>(
  (ref) => RegisterFormNotifier(),
);

enum FieldType { text, image }

class DynamicField {
  final String id;
  final FieldType type;
  final TextEditingController? textController; // Only for text fields
  final String? imagePath; // Only for images

  DynamicField({
    required this.id,
    required this.type,
    this.textController,
    this.imagePath,
  });

  DynamicField copyWith({String? imagePath}) {
    return DynamicField(
      id: id,
      type: type,
      textController: textController,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
