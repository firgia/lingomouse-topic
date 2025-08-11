import 'dart:io';
import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lingomouse_topic/cubit/cubit.dart';

import '../../data/data.dart';

part 'save_topic_state.dart';
part 'save_topic_cubit.freezed.dart';

class SaveTopicCubit extends Cubit<SaveTopicState> {
  final TopicRepository topicRepository;
  final TopicGeneratorCubit topicGeneratorCubit;

  SaveTopicCubit({
    required this.topicRepository,
    required this.topicGeneratorCubit,
  }) : super(const SaveTopicState.initial());

  void save(DraftTopic draftTopic) async {
    List<String> english = [
      "110123",
      "1101231",
      "20231224",
      "20240215",
      "20240216",
      "20240517",
      "20240530",
      "2303091",
      "23042102",
      "3010323"
    ];
    List<String> spanish = [
      "100223",
      "20240516",
      "20240528",
      "20240529",
      "23041901",
      "23042101",
      "44010324"
    ];
    List<String> italian = ["1010323", "23051101", "23052201"];
    List<String> german = ["2010323", "23061301", "23061302"];
    List<String> czech = ["20240911", "20240912", "20240913"];
    List<String> sweden = ["20241114", "20241115", "20241116"];
    List<String> chinese = ["20250505", "20250506", "20250507"];
    List<String> norwegianBokmal = ["23050901", "23082901", "23082902"];
    List<String> portuguese = ["23052701", "23052702", "23053101"];
    List<String> russian = ["23052901", "23052902", "23052903"];
    List<String> french = ["23053001", "23053002", "23053003", "33010324"];
    List<String> dutch = ["23061401", "23061402", "23061403"];
    List<String> ukrainian = ["23061404", "23061405", "23061406"];

    int total = spanish.length +
        italian.length +
        english.length +
        german.length +
        czech.length +
        sweden.length +
        chinese.length +
        norwegianBokmal.length +
        portuguese.length +
        russian.length +
        french.length +
        dutch.length +
        ukrainian.length;

    int totalSaved = 0;
    emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));

    await _save(
      ids: english,
      topic: draftTopic,
      data: draftTopic.en,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    await _save(
      ids: spanish,
      topic: draftTopic,
      data: draftTopic.es,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    await _save(
      ids: italian,
      topic: draftTopic,
      data: draftTopic.it,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    await _save(
      ids: german,
      topic: draftTopic,
      data: draftTopic.de,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    await _save(
      ids: czech,
      topic: draftTopic,
      data: draftTopic.cs,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    await _save(
      ids: sweden,
      topic: draftTopic,
      data: draftTopic.sv,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    await _save(
      ids: chinese,
      topic: draftTopic,
      data: draftTopic.zh,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    await _save(
      ids: norwegianBokmal,
      topic: draftTopic,
      data: draftTopic.nb,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    await _save(
      ids: portuguese,
      topic: draftTopic,
      data: draftTopic.pt,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    await _save(
      ids: russian,
      topic: draftTopic,
      data: draftTopic.ru,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    await _save(
      ids: french,
      topic: draftTopic,
      data: draftTopic.fr,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    await _save(
      ids: dutch,
      topic: draftTopic,
      data: draftTopic.nl,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    await _save(
      ids: ukrainian,
      topic: draftTopic,
      data: draftTopic.uk,
      onCompleted: () {
        totalSaved++;
        emit(SaveTopicState.loading(total: total, totalSaved: totalSaved));
      },
    );

    emit(const SaveTopicState.successfully());
  }

  Future<void> _save({
    required List<String> ids,
    required DraftTopic topic,
    required TopicTranslation data,
    required VoidCallback onCompleted,
  }) async {
    for (var id in ids) {
      try {
        await topicRepository.addTopic(
          courseID: id,
          image: File(topic.image),
          name: data.name,
          description: data.description,
          level: topic.level,
          isActive: true,
        );

        onCompleted();
      } catch (_) {
        print("Failed: to save ($id, ${data.name})");
      }
    }
  }
}
