import 'package:freezed_annotation/freezed_annotation.dart';

import '../topic_translation/topic_translation.dart';

part 'draft_topic.freezed.dart';
part 'draft_topic.g.dart';

@freezed
class DraftTopic with _$DraftTopic {
  const factory DraftTopic({
    @JsonKey(name: "level") required String level,
    @JsonKey(name: "image") required String image,
    @JsonKey(name: "en") required TopicTranslation en,
    @JsonKey(name: "es") required TopicTranslation es,
    @JsonKey(name: "it") required TopicTranslation it,
    @JsonKey(name: "de") required TopicTranslation de,
    @JsonKey(name: "cs") required TopicTranslation cs,
    @JsonKey(name: "sv") required TopicTranslation sv,
    @JsonKey(name: "zh") required TopicTranslation zh,
    @JsonKey(name: "nb") required TopicTranslation nb,
    @JsonKey(name: "pt") required TopicTranslation pt,
    @JsonKey(name: "ru") required TopicTranslation ru,
    @JsonKey(name: "fr") required TopicTranslation fr,
    @JsonKey(name: "nl") required TopicTranslation nl,
    @JsonKey(name: "uk") required TopicTranslation uk,
  }) = _DraftTopic;

  factory DraftTopic.fromJson(Map<String, dynamic> json) =>
      _$DraftTopicFromJson(json);
}
