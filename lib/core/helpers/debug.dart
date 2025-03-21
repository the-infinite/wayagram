class WayaDebugHelpers {
  WayaDebugHelpers._();

  static StackTrace getStackTrace(dynamic e) {
    if (e is Error) {
      return e.stackTrace ?? StackTrace.current;
    }

    return StackTrace.current;
  }

  static String getMessage(dynamic e) {
    if (e is String) {
      return e;
    }

    if (e is Exception) {
      return (e as dynamic).message.toString();
    }

    return e.toString();
  }
}
