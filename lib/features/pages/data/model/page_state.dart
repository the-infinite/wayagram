
import 'package:flutter/cupertino.dart';

class PageState{
  final TextEditingController pageName;
  final TextEditingController pageDescription;
  final TextEditingController content;

  final bool isFocused;
  final bool isLoading;

  PageState({
    TextEditingController? pageName,
    TextEditingController? pageDescription,
    TextEditingController? content,

    this.isFocused = false,
    this.isLoading = false,
}):  pageName = pageName ?? TextEditingController(),
     pageDescription = pageDescription ?? TextEditingController(),
     content = content ?? TextEditingController();

  PageState copyWith({
    TextEditingController? pageName,
    TextEditingController? pageDescription,
    TextEditingController? content,

    bool? isFocused,
    bool? isLoading,
}){
    return PageState(
      pageName: pageName ?? this.pageName,
      pageDescription: pageDescription ?? this.pageDescription,
      content: content ?? this.content,

      isFocused: isFocused ?? this.isFocused,
      isLoading: isLoading ?? this.isLoading,
    );
}
}