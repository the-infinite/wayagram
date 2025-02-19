import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/features/ugt/data/model/register_for_contest_model.dart';

final uuid = Uuid();

class RegisterFormNotifier extends StateNotifier<List<DynamicField>> {
  late TextEditingController fullName;
  late TextEditingController emailAddress;
  late TextEditingController address;
  late TextEditingController phoneNumber;
  String university = "";
  String selectedState = "";

  RegisterFormNotifier() : super([..._addDefault()]) {
    fullName = TextEditingController();
    emailAddress = TextEditingController();
    address = TextEditingController();
    phoneNumber = TextEditingController();
  }

  // Add a text input field
  void addTextField() {
    state = [
      ...state,
      /*  DynamicField(
        id: uuid.v4(),
        type: FieldType.text,
        textController: TextEditingController(),
      ), */
    ];
  }

  // Add an image field
  void addImageField() {
    state = [
      ...state,
      /*  DynamicField(
        id: uuid.v4(),
        type: FieldType.image,
      ), */
    ];
  }

  void submitDetail() {
    List<Map<String, dynamic>> detailsList = state
        .map(
          (model) => <String, dynamic>{
            "title": model.title,
            "titleDetails": model.textController?.text ?? "",
            "imagePath": model.imagePath,
            "modeltype": model.type
          },
        )
        .toList();
    print("Mean $detailsList");

    var map = {
      "fullName": fullName.text,
      "email": emailAddress.text,
      "address": address.text,
      "phoneNumber": phoneNumber.text,
      "university": university,
      "state": selectedState,
      "list": detailsList
    };
    print("Mean2 $map");
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
  final String title; // Only for images
  final bool isRequired; // Only for images

  DynamicField({
    required this.id,
    required this.type,
    required this.isRequired,
    this.textController,
    this.imagePath,
    required this.title,
  });

  DynamicField copyWith({String? imagePath}) {
    return DynamicField(
      id: id,
      type: type,
      title: title,
      isRequired: isRequired,
      textController: textController,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

List<DynamicField> _addDefault() {
  var fieldList = <DynamicField>[];
  var list = [
    RegisterForContestModel(
        id: uuid.v4(),
        title: "Name of School",
        isRequired: true,
        isFile: false),
    RegisterForContestModel(
        id: uuid.v4(),
        title: "Birth Certificate",
        isRequired: true,
        isFile: true),
    RegisterForContestModel(
        id: uuid.v4(), title: "Birth Name", isRequired: false, isFile: false),
  ];

  for (var model in list) {
    if (model.isFile) {
      fieldList.add(
        DynamicField(
          id: uuid.v4(),
          isRequired: model.isRequired,
          title: model.title,
          type: FieldType.image,
        ),
      );
    } else {
      fieldList.add(DynamicField(
        id: uuid.v4(),
        isRequired: model.isRequired,
        title: model.title,
        type: FieldType.text,
        textController: TextEditingController(),
      ));
    }
  }
  return fieldList;
}
