import 'dart:convert';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/data.dart';

part 'topic_generator_state.dart';
part 'topic_generator_cubit.freezed.dart';

class TopicGeneratorCubit extends Cubit<TopicGeneratorState> {
  final OpenAI openAI;

  TopicGeneratorCubit({
    required this.openAI,
  }) : super(
          const TopicGeneratorState.initial(draftTopic: null),
        );

  void generate({
    required String name,
    required String description,
    required String level,
  }) async {
    try {
      emit(const TopicGeneratorState.loading(draftTopic: null));

      final imageResult = await openAI.generateImage(
        GenerateImage(
          _imagePrompt("$name - $description"),
          1,
          model: DallE3(),
          size: ImageSize.size1024,
          quality: "standard",
        ),
      );

      String? imageUrl = imageResult?.data?.first?.url;

      if (imageUrl == null) {
        emit(TopicGeneratorState.error(
          draftTopic: state.draftTopic,
          message: "Failed to generate image",
        ));

        return;
      }

      final response = await openAI.onChatCompletion(
        request: ChatCompleteText(
          model: Gpt4OChatModel(),
          maxToken: 4096,
          messages: [
            Messages(
              role: Role.system,
              content: prompt,
            ).toJson(),
            Messages(
              role: Role.user,
              content: '''
            {
              "name": "$name",
              "description": "$description"
            }
            ''',
            ).toJson(),
          ],
        ),
      );

      final resultMessage = response?.choices.firstOrNull?.message;

      if (resultMessage != null) {
        // Step 1: Remove Markdown wrapper
        final cleaned = resultMessage.content
            .replaceAll('```json', '')
            .replaceAll('```', '')
            .trim();

        // Step 2: Parse JSON
        final Map<String, dynamic> jsonData = json.decode(cleaned);

        emit(TopicGeneratorState.completed(
            draftTopic: DraftTopic.fromJson({
          "level": level,
          "image": imageUrl,
          ...jsonData,
        })));
      }
    } catch (e) {
      emit(TopicGeneratorState.error(
        draftTopic: state.draftTopic,
        message: "Unknown error",
      ));
    }
  }

  String get prompt => '''
    You are a multilingual teacher. Your job is to translate the conversation topic from English to Spanish, Italian, German, Czech, Sweden, Chinese (Simplified - Pinyin), Norwegian Bokmål, Portuguese, Russian, French, Dutch, and Ukrainian.

    Use a casual and beginner-friendly tone which easy to understand by our students.

    The response must be in valid JSON and follow this exact structure:
      {
      "es": {
        "name": "Dar Opiniones",
        "description": "Aprende formas fáciles y divertidas de decir lo que piensas o sientes sobre algo."
      },
      "it": {
        "name": "Esprimere Opinioni",
        "description": "Impara modi semplici e divertenti per dire cosa pensi o provi su qualcosa."
      },
      "en": {
        "name": "Giving Opinions",
        "description": "Learn fun and simple ways to share what you think or feel about something."
      },
      "de": {
        "name": "Meinung Äußern",
        "description": "Lerne auf einfache und lustige Weise zu sagen, was du denkst oder fühlst."
      },
      "cs": {
        "name": "Vyjadřování Názoru",
        "description": "Nauč se jednoduchým a zábavným způsobem říct, co si myslíš nebo cítíš."
      },
      "sv": {
        "name": "Ge Åsikter",
        "description": "Lär dig enkla och roliga sätt att säga vad du tycker eller känner."
      },
      "zh": {
        "name": "Biaodá Yìjiàn",
        "description": "Xuéxí yòng jiǎndān yǒuqù de fāngshì biǎodá nǐ de xiǎngfǎ hé gǎnshòu."
      },
      "nb": {
        "name": "Gi Meninger",
        "description": "Lær enkle og morsomme måter å si hva du mener eller føler."
      },
      "pt": {
        "name": "Dar Opiniões",
        "description": "Aprenda maneiras simples e divertidas de dizer o que você pensa ou sente."
      },
      "ru": {
        "name": "Выражение Мнения",
        "description": "Научись простыми и интересными способами говорить, что ты думаешь или чувствуешь."
      },
      "fr": {
        "name": "Donner son Avis",
        "description": "Apprends des façons simples et amusantes de dire ce que tu penses ou ressens."
      },
      "nl": {
        "name": "Mening Geven",
        "description": "Leer op een eenvoudige en leuke manier te vertellen wat je denkt of voelt."
      },
      "uk": {
        "name": "Висловлення Думок",
        "description": "Навчися просто і цікаво казати, що ти думаєш або відчуваєш."
      }
    }

    Guidelines:
    - "name" should be short and engaging (max 50 characters).
    - "description" should be 1-2 sentences in a casual tone (max 150 characters).
    - Ensure the translation languages convey the same meaning.
    - Return only the JSON array without any extra text or formatting.
  ''';

  String _imagePrompt(String topic) {
    return "An illustrative scene set in a language learning class. There are three people of diverse descents involved namely, a Hispanic female teacher standing in front of a blackboard, a Caucasian male student introducing himself in English and sitting at a desk, and a Middle-Eastern female student introducing herself in French and also sitting at a desk. Feature cues for the language learning activity, such as flashcards with vocabulary words, textbooks, and a blackboard with '$topic' written on it.";
  }
}
