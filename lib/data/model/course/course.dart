import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/common.dart';

part 'course.freezed.dart';
part 'course.g.dart';

@freezed
class Course with _$Course {
  const Course._();

  const factory Course({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "course") required String name,
    @JsonKey(name: "img") required String img,
    @JsonKey(name: "foreign") required String foreign,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Language? get language {
    List<String> english = ["angielski", "inggris", "inglés"];
    List<String> czech = ["czeski"];
    List<String> french = ["francuski", "french"];
    List<String> spanish = ["spanish", "hiszpański"];
    List<String> dutch = ["niderlandzki"];
    List<String> german = ["niemiecki"];
    List<String> norwegian = ["norweski"];
    List<String> portuguese = ["portugalski"];
    List<String> russian = ["rosyjski"];
    List<String> sweden = ["szwedzki"];
    List<String> ukrainian = ["ukraiński"];
    List<String> italian = ["włoski"];

    String? courseName = name
        .split(" ")
        .firstOrNull
        ?.toLowerCase()
        .replaceAll(RegExp(r'\d'), "");

    if (courseName != null) {
      if (english.contains(courseName)) {
        return Language.english;
      } else if (czech.contains(courseName)) {
        return Language.czech;
      } else if (french.contains(courseName)) {
        return Language.french;
      } else if (spanish.contains(courseName)) {
        return Language.spanish;
      } else if (dutch.contains(courseName)) {
        return Language.dutch;
      } else if (german.contains(courseName)) {
        return Language.german;
      } else if (norwegian.contains(courseName)) {
        return Language.norwegian;
      } else if (portuguese.contains(courseName)) {
        return Language.portuguese;
      } else if (russian.contains(courseName)) {
        return Language.russian;
      } else if (sweden.contains(courseName)) {
        return Language.sweden;
      } else if (ukrainian.contains(courseName)) {
        return Language.ukrainian;
      } else if (italian.contains(courseName)) {
        return Language.italian;
      }
    }

    return null;
  }
}
