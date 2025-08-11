import 'package:dio/dio.dart';

class ApiFailure implements Exception {
  ApiFailure([
    this.message = "An unknown exception occurred.",
    this.statusCode,
    this.data,
  ]);

  int? statusCode;
  late String message;
  dynamic data;

  factory ApiFailure.fromDioException(DioException dioError) {
    String? message;

    try {
      message = dioError.response?.data?["message"];
      message ??= dioError.response?.data?["detail"];
    } catch (_) {
      message = null;
    }

    return ApiFailure(
      message ?? dioError.message ?? "An unknown exception occurred.",
      dioError.response?.statusCode,
      dioError.response?.data,
    );
  }

  factory ApiFailure.fromResponse(Response response) {
    String? message;

    try {
      message = response.data?["message"];
    } catch (e) {
      message = null;
    }

    return ApiFailure(
      message ?? "An unknown exception occurred.",
      response.statusCode,
      response.data,
    );
  }
}
