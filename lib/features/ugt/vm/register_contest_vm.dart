import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:wayagram/core/components/components.dart';
import 'package:wayagram/core/data/local_data_source.dart';
import 'package:wayagram/core/utils/utils.dart';
import 'package:wayagram/features/ugt/data/model/ugt_post_model.dart';
import 'package:wayagram/features/ugt/data/repository/ContestRepo.dart';
import 'package:wayagram/features/ugt/ugt_home.dart';
import 'package:wayagram/shared/features/file/repo/default.dart';

final uuid = Uuid();

class RegisterFormNotifier extends StateNotifier<List<DynamicField>> {
  final ContestRepo _contestRepository;
  final WayaLocalDataSource _localDataSource;
  late TextEditingController fullName;
  late TextEditingController emailAddress;
  late TextEditingController address;
  late TextEditingController age;
  late TextEditingController phoneNumber;
  String university = "";
  String selectedState = "";
  String? postId = "";
  Contest? post;

  RegisterFormNotifier(this._contestRepository, this._localDataSource)
      : super([]) {
    fullName = TextEditingController();
    emailAddress = TextEditingController();
    address = TextEditingController();
    phoneNumber = TextEditingController();
    age = TextEditingController();
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

  void addDefault(List<FormRequirement> model, Contest post) {
    postId = post.id;
    this.post = post;

    var fieldList = <DynamicField>[];
/*     var list = [
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
    ]; */

    for (var model in model) {
      //  debugPrint("Model type ${model.requirementType}");
      if (model.requirementType == "TEXT") {
        fieldList.add(
          DynamicField(
            id: uuid.v4(),
            isRequired: model.required ?? false,
            title: model.requirementName ?? "Title",
            type: FieldType.text,
            textController: TextEditingController(),
          ),
        );
      } else {
        fieldList.add(DynamicField(
          id: uuid.v4(),
          isRequired: model.required ?? false,
          title: model.requirementName ?? "Title",
          type: FieldType.image,
          // textController: TextEditingController(),
        ));
      }
    }
    state = [...fieldList];
  }

  Future<void> submitDetail(BuildContext context, ValueNotifier<bool> isLoading,
      String mySelectedState, VoidCallback onPressed) async {
    isLoading.value = true;
    debugPrint("Mean  werr $state");
    List<Map<String, dynamic>> detailsList = state.map(
      (model) {
        String? image = model.imagePath;
        debugPrint("Mean1  ${model.imagePath}");
        debugPrint("Mean1  ${model.title}");
        debugPrint("Mean2  ${model.textController?.text}");
        // debugPrint("Mean  sow ${model.textController?.text}");
        /*  if(model.type== FieldType.image ){
            image = await WayaFileRepository.instance.uploadFile(
      File(image!),
    );
        } */
        return <String, dynamic>{
          "title": model.title,
          "data": image,
          "type": model.type
        };
      },
    ).toList();
    debugPrint("Mean $detailsList");
    List<Map<String, dynamic>> detailsListRight = [];
    var mapNew = {};
    for (var oldMap in detailsList) {
      if (oldMap["type"] == FieldType.image) {
        String? myImage = await WayaFileRepository.instance.uploadFile(
          File(oldMap["data"]),
        );
        mapNew[oldMap["title"]] = myImage;
      } else {
        mapNew[oldMap["title"]] = oldMap["data"];
        // detailsListRight.add({oldMap["title"]: oldMap["data"]});
      }
    }

    debugPrint("Mean 1 $detailsListRight");

    var map = {
      "userId": _localDataSource.getUserId().toString(),
      "contestId": postId,

      "fullName": fullName.text,
      "email": emailAddress.text,
      "address": address.text,
      "phoneNumber": phoneNumber.text,
      "age": age.text,
      // "university": university,
      "state": mySelectedState,
      "applicationData": mapNew
    };
    debugPrint(map.toString());
    final response = await _contestRepository.registerContest(map);
    isLoading.value = false;

    if (response.success) {
      WayaSnackBar.showToast(
          "Application sent, Your Application is under review");
      Future.delayed(Duration(seconds: 1), () {
        WayaNav.removeAllUntil(UgtHome(), "/ugt-home");
      });
    }
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

  void updateText(String id, String text) {
    state = state.map((field) {
      if (field.id == id && field.type == FieldType.text) {
        debugPrint("Mean jjj ");
        return field.copyWith(imagePath: text);
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
  (ref) => RegisterFormNotifier(ContestRepo(), WayaLocalDataSource()),
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
