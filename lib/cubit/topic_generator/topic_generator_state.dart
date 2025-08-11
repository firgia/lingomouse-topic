part of 'topic_generator_cubit.dart';

@freezed
class TopicGeneratorState with _$TopicGeneratorState {
  const factory TopicGeneratorState.initial({
    required DraftTopic? draftTopic,
  }) = _Initial;

  const factory TopicGeneratorState.loading({
    required DraftTopic? draftTopic,
  }) = _Loading;

  const factory TopicGeneratorState.completed({
    required DraftTopic draftTopic,
  }) = _Loaded;

  const factory TopicGeneratorState.error({
    required DraftTopic? draftTopic,
    required String message,
  }) = _Error;
}
