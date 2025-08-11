import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'cubit/cubit.dart';
import 'data/data.dart';

/// Service locator
final sl = GetIt.instance;

Future<void> setupInjection() async {
  OpenAI openAI = OpenAI.instance.build(
    token: "",
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 60)),
    enableLog: true,
  );

  sl.registerFactory<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: ApiPath.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    ),
  );

  /* --------------------------------> DATA <-------------------------------- */
  sl.registerSingleton<ApiProvider>(ApiProviderImpl(
    dio: sl<Dio>(),
  ));

  sl.registerSingleton<CourseRepository>(CourseRepositoryImpl(
    apiProvider: sl<ApiProvider>(),
  ));

  sl.registerSingleton<TopicRepository>(TopicRepositoryImpl(
    apiProvider: sl<ApiProvider>(),
  ));

  sl.registerSingleton<CourseCubit>(CourseCubit(
    courseRepository: sl<CourseRepository>(),
  ));

  sl.registerSingleton<TopicCubit>(
    TopicCubit(
      courseCubit: sl<CourseCubit>(),
      topicRepository: sl<TopicRepository>(),
    ),
  );

  sl.registerSingleton<TopicGeneratorCubit>(
    TopicGeneratorCubit(
      openAI: openAI,
    ),
  );

  sl.registerSingleton<SaveTopicCubit>(SaveTopicCubit(
    topicGeneratorCubit: sl<TopicGeneratorCubit>(),
    topicRepository: sl<TopicRepository>(),
  ));
}
