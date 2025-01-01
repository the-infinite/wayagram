class WayaRequestResponse {
  final bool success;
  final dynamic data;
  final String? responseCodeError;
  final int? statusCode;

  WayaRequestResponse({
    required this.success,
    this.data,
    this.responseCodeError,
    this.statusCode,

  });
}
