
import 'package:flutter/cupertino.dart';

class PageState{
  final TextEditingController pageName;
  final TextEditingController pageDescription;

  final bool isFocused;
  final bool isLoading;

  PageState({
    TextEditingController? pageName,
    TextEditingController? pageDescription,

    this.isFocused = false,
    this.isLoading = false,
}):  pageName = pageName ?? TextEditingController(),
     pageDescription = pageDescription ?? TextEditingController();

  PageState copyWith({
    TextEditingController? pageName,
    TextEditingController? pageDescription,

    bool? isFocused,
    bool? isLoading,
}){
    return PageState(
      pageName: pageName ?? this.pageName,
      pageDescription: pageDescription ?? this.pageDescription,

      isFocused: isFocused ?? this.isFocused,
      isLoading: isLoading ?? this.isLoading,
    );
}
}