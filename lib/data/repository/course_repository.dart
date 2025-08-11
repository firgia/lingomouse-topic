import 'dart:developer';

import 'package:dio/dio.dart';

import '../../common/common.dart';
import '../model/model.dart';
import '../provider/provider.dart';

abstract class CourseRepository {
  Future<List<Course>> getActiveCourses();
}

class CourseRepositoryImpl extends CourseRepository {
  final ApiProvider apiProvider;

  CourseRepositoryImpl({
    required this.apiProvider,
  });

  @override
  Future<List<Course>> getActiveCourses() async {
    try {
      Response response = await apiProvider.getActiveCourses();

      final List<dynamic> data = response.data["data"];
      List<Course> courses = [];

      for (var map in data) {
        courses.add(Course.fromJson(map));
      }

      return courses;
    } on DioException catch (e) {
      throw ApiFailure.fromDioException(e);
    } on ApiFailure catch (_) {
      rethrow;
    } catch (e) {
      throw ApiFailure();
    }
  }
}
