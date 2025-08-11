import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/common.dart';
import '../../data/data.dart';

part 'course_state.dart';
part 'course_cubit.freezed.dart';

class CourseCubit extends Cubit<CourseState> {
  final CourseRepository courseRepository;

  CourseCubit({
    required this.courseRepository,
  }) : super(const CourseState.initial(data: []));

  void fetch() async {
    try {
      emit(
        CourseState.loading(
          data: state.data,
          selected: state.selected,
        ),
      );

      List<Course> courses = await courseRepository.getActiveCourses();

      emit(CourseState.loaded(
        data: courses,
        selected: courses.firstOrNull,
      ));
    } on ApiFailure catch (e) {
      emit(
        CourseState.error(
          data: state.data,
          selected: state.selected,
          message: e.message,
        ),
      );
    } catch (e) {
      print(e.runtimeType);
      emit(
        CourseState.error(
          data: state.data,
          selected: state.selected,
          message: "An unknown exception occurred.",
        ),
      );
    }
  }

  void setSelected(Course course) {
    emit(CourseState.loaded(
      data: state.data,
      selected: course,
    ));
  }
}
