import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic_translation.freezed.dart';
part 'topic_translation.g.dart';

@freezed
class TopicTranslation with _$TopicTranslation {
  const factory TopicTranslation({
    @JsonKey(name: "description") required String description,
    @JsonKey(name: "name") required String name,
  }) = _TopicTranslation;

  factory TopicTranslation.fromJson(Map<String, dynamic> json) =>
      _$TopicTranslationFromJson(json);
}
