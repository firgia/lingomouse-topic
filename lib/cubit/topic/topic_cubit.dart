import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common/common.dart';
import '../../data/data.dart';
import '../course/course_cubit.dart';

part 'topic_state.dart';
part 'topic_cubit.freezed.dart';

class TopicCubit extends Cubit<TopicState> {
  final CourseCubit courseCubit;
  final TopicRepository topicRepository;

  Course? _course;

  TopicCubit({
    required this.courseCubit,
    required this.topicRepository,
  }) : super(const TopicState.initial(topics: [])) {
    if (courseCubit.state.selected != null) {
      _course = courseCubit.state.selected;
      fetch();
    }

    courseCubit.stream.listen(
      (event) {
        if (_course != event.selected) {
          _course = event.selected;

          if (_course == null) {
            emit(const TopicState.initial(topics: []));
          } else {
            fetch();
          }
        }
      },
    );
  }

  void fetch() async {
    try {
      if (_course == null) {
        emit(const TopicState.initial(topics: []));
        return;
      }

      emit(
        TopicState.loading(topics: state.topics),
      );

      List<Topic> topics =
          await topicRepository.getTopics(courseID: _course!.id);

      emit(TopicState.loaded(topics: topics));
    } on ApiFailure catch (e) {
      emit(
        TopicState.error(
          topics: state.topics,
          message: e.message,
        ),
      );
    } catch (e) {
      emit(
        TopicState.error(
          topics: state.topics,
          message: "An unknown exception occurred.",
        ),
      );
    }
  }
}
