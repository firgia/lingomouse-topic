import 'dart:convert';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dio/dio.dart' hide Response;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path_provider/path_provider.dart';

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

      String? dallEPrompt = await _generateDallEPrompt(
        name: name,
        description: description,
        level: level,
      );

      if (dallEPrompt == null) {
        emit(TopicGeneratorState.error(
          draftTopic: state.draftTopic,
          message: "Failed to generate image prompt",
        ));

        return;
      }

      final imageResult = await openAI.generateImage(
        GenerateImage(
          dallEPrompt,
          1,
          model: DallE3(),
          size: ImageSize.size1024,
          quality: "standard",
          style: "natural",
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

      File imageFile = await _downloadImage(imageUrl);

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
          "image": imageFile.path,
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

  Future<String?> _generateDallEPrompt({
    required String name,
    required String description,
    required String level,
  }) async {
    final responseImagePrompt = await openAI.onChatCompletion(
      request: ChatCompleteText(
        model: Gpt4OChatModel(),
        maxToken: 4096,
        messages: [
          Messages(
            role: Role.system,
            content: _fetchImagePrompt,
          ).toJson(),
          Messages(
            role: Role.user,
            content: '''
            {
              "name": "$name",
              "description": "$description",
              "level": $level,
            }
            ''',
          ).toJson(),
        ],
      ),
    );

    final resultMessage = responseImagePrompt?.choices.firstOrNull?.message;

    return resultMessage?.content;
  }

  String get prompt => '''
    You are a multilingual teacher. Your job is to translate the conversation topic from English to Spanish, Italian, German, Czech, Sweden, Chinese (Simplified - Pinyin), Norwegian Bokmål, Portuguese, Russian, French, Dutch, and Ukrainian.

    Use a casual and beginner-friendly tone which easy to understand by our students.

    The response must be in valid JSON and follow this sample structure:
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

  String get _fetchImagePrompt {
    return '''
        You are an AI prompt generator for DALL·E.
        I will give you a JSON array of conversation topics, each with a name, description, and level.
        For each topic, create a realistic, high-quality image prompt that visually represents the activity or situation described in the topic name and description.

        Image requirements:
        - Depict real, diverse people (natural appearance, various ages and ethnicities) in a relevant and believable setting for the topic.
        - Use a wide scene composition so the image works for a 16:4 aspect ratio — avoid close-ups, include background context, and use medium or wide shots.
        - Spread the action across the frame so the subject does not get cropped.
        - Add environmental details (e.g., objects, scenery, decor) that enhance the realism.
        - Photography style: wide-angle view, cinematic composition, soft natural light or warm lighting, candid expressions, modern casual clothing, shallow depth of field, high resolution.
        - End each prompt with “16:9 aspect ratio.”
    ''';
  }

  Future<File> _downloadImage(String imageUrl) async {
    // 1. Download the image and save it as a file
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${DateTime.now()}.jpg';

    final response = await Dio().download(imageUrl, filePath);
    if (response.statusCode != 200) {
      throw Exception('Failed to download image');
    }

    File imageFile = File(filePath);

    XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '${imageFile.path}_compressed.jpg',
      format: CompressFormat.jpeg,
      keepExif: true,
    );

    if (compressedFile != null) {
      imageFile = File(compressedFile.path);
    }

    return imageFile;
  }
}
