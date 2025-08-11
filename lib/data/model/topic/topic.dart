import 'package:freezed_annotation/freezed_annotation.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

@freezed
class Topic with _$Topic {
  const factory Topic({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "description") required String description,
    @JsonKey(name: "image") required String image,
    @JsonKey(name: "level") required String level,
    @JsonKey(name: "is_active") required bool isActive,
    @JsonKey(name: "platform") required String platform,
    @JsonKey(name: "system_version") required String systemVersion,
  }) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}
