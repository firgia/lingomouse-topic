part of 'save_topic_cubit.dart';

@freezed
class SaveTopicState with _$SaveTopicState {
  const factory SaveTopicState.initial() = _Initial;

  const factory SaveTopicState.loading({
    required int total,
    required int totalSaved,
  }) = _Loading;

  const factory SaveTopicState.successfully() = _Successfully;

  const factory SaveTopicState.error({
    required String message,
  }) = _Error;
}
