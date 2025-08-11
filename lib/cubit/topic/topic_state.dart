part of 'topic_cubit.dart';

@freezed
class TopicState with _$TopicState {
  const factory TopicState.initial({
    required List<Topic> topics,
  }) = _Initial;

  const factory TopicState.loading({
    required List<Topic> topics,
  }) = _Loading;

  const factory TopicState.loaded({
    required List<Topic> topics,
  }) = _Loaded;

  const factory TopicState.error({
    required List<Topic> topics,
    required String message,
  }) = _Error;
}
