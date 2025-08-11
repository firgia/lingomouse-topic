import 'dart:io';

import 'package:dio/dio.dart';

import '../../common/common.dart';
import '../model/model.dart';
import '../provider/provider.dart';

abstract class TopicRepository {
  Future<void> addTopic({
    required String courseID,
    required File image,
    required String name,
    required String description,
    required String level,
    required bool isActive,
  });

  Future<List<Topic>> getTopics({
    required String courseID,
  });
}

class TopicRepositoryImpl extends TopicRepository {
  final ApiProvider apiProvider;

  TopicRepositoryImpl({
    required this.apiProvider,
  });

  @override
  Future<void> addTopic({
    required String courseID,
    required File image,
    required String name,
    required String description,
    required String level,
    required bool isActive,
  }) async {
    try {
      await apiProvider.addTopic(
        courseID: courseID,
        image: image,
        name: name,
        description: description,
        level: level,
        isActive: isActive,
      );
    } on DioException catch (e) {
      throw ApiFailure.fromDioException(e);
    } on ApiFailure catch (_) {
      rethrow;
    } catch (e) {
      throw ApiFailure();
    }
  }

  @override
  Future<List<Topic>> getTopics({required String courseID}) async {
    try {
      Response response = await apiProvider.getTopics(courseID: courseID);

      if (response.statusCode == 200) {
        List<dynamic>? responseData = Parser.getListDynamic(response.data);

        if (responseData != null) {
          List<Topic> data = [];

          for (dynamic item in responseData) {
            final map = Parser.getMap(item);

            if (map != null) {
              final newItem = Topic.fromJson(map);
              data.add(newItem);
            }
          }

          return data;
        }
      }

      throw ApiFailure();
    } on DioException catch (e) {
      throw ApiFailure.fromDioException(e);
    } on ApiFailure catch (_) {
      rethrow;
    } catch (e) {
      throw ApiFailure();
    }
  }
}
