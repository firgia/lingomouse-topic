part of 'course_cubit.dart';

@freezed
class CourseState with _$CourseState {
  const factory CourseState.initial({
    required List<Course> data,
    Course? selected,
  }) = _Initial;

  const factory CourseState.loading({
    required List<Course> data,
    Course? selected,
  }) = _Loading;

  const factory CourseState.loaded({
    required List<Course> data,
    Course? selected,
  }) = _Loaded;

  const factory CourseState.error({
    required List<Course> data,
    Course? selected,
    required String message,
  }) = _Error;
}
