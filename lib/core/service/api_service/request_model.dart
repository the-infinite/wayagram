class WayaRequestResponse {
  final bool success;
  final String? message;
  final dynamic data;
  final String? responseCodeError;
  final int? statusCode;

  WayaRequestResponse({
    required this.success,
    this.data,
    this.message,
    this.responseCodeError,
    this.statusCode,
  });
}
