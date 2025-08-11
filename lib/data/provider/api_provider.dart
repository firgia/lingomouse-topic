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
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzU1NDM1NDc3LCJpYXQiOjE3NTQ4MzA2NzcsImp0aSI6IjRlNzg1MTM1NWQ3MjQxNWZiODBjOWFlYzVjZGM0YjQ3IiwidXNlcl9pZCI6MTA0NTk3fQ.ynlIOFKzEG9KCXtODp0APx8qSnEolB3D9Jkd1cSYLb4";

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
      "is_active": isActive,
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
