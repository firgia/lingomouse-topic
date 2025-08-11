import 'dart:io';

import 'package:dio/dio.dart';

abstract class ApiPath {
  static String get baseUrl => "https://lingo-mouse.com/api";

  static String get getActiveCourses =>
      "$baseUrl/courses/courses/list-course-active/";
  static String getTopics(String courseID) =>
      "$baseUrl/courses/courses/$courseID/get-topics/";
  static String addTopic(String courseID) =>
      "$baseUrl/courses/courses/$courseID/add-topic/";
}

abstract class ApiProvider {
  /// Header for request to LingoMouse api
  Map<String, String> get headers;

  /// Get active course
  Future<Response> getActiveCourses();

  Future<Response> getTopics({
    required String courseID,
  });

  Future<Response> addTopic({
    required String courseID,
    required File image,
    required String name,
    required String description,
    required String level,
    required bool isActive,
  });
}

class ApiProviderImpl extends ApiProvider {
  final Dio dio;

  ApiProviderImpl({
    required this.dio,
  });

  @override
  Map<String, String> get headers {
    String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU1NTA4NTM3LCJpYXQiOjE3NTQ5MDM3MzcsImp0aSI6ImRmMzcxZGUzZjJmMzQ4OTNhMzUzZDI3MDY1ZjMyMDA3IiwidXNlcl9pZCI6MTA0NTk3fQ.5WaJr6abVcmyvR8eJD0DcdmFA9f1gK3J4qzmeM_SE00";

    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  @override
  Future<Response> getActiveCourses() {
    return dio.get(
      ApiPath.getActiveCourses,
      options: Options(
        headers: headers,
      ),
    );
  }

  @override
  Future<Response> getTopics({
    required String courseID,
  }) {
    return dio.get(
      ApiPath.getTopics(courseID),
      options: Options(
        headers: headers,
      ),
    );
  }

  @override
  Future<Response> addTopic({
    required String courseID,
    required File image,
    required String name,
    required String description,
    required String level,
    required bool isActive,
  }) async {
    FormData? formData;

    formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
      "name": name,
      "description": description,
      "level": level,
      "is_active": "True",
    });

    return dio.post(
      ApiPath.addTopic(courseID),
      data: formData,
      options: Options(
        headers: headers,
      ),
    );
  }
}
