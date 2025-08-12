part of 'home_screen.dart';

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseCubit, CourseState>(
      builder: (context, state) {
        List<Course> courses = state.data;

        return ListView.builder(
          itemBuilder: (context, index) {
            Course course = courses[index];

            return InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: CachedNetworkImage(
                        imageUrl: course.img,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        course.name,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: courses.length,
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopicCubit, TopicState>(
      builder: (context, state) {
        List<Topic> topics = state.topics;

        return Column(
          children: topics.map(
            (e) {
              return _TopicCard(e);
            },
          ).toList(),
        );
      },
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard(this.data);

  final Topic data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: data.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            data.name,
          ),
          Text(data.description),
        ],
      ),
    );
  }
}

class _TopicGenerator extends StatefulWidget {
  const _TopicGenerator();

  @override
  State<_TopicGenerator> createState() => _TopicGeneratorState();
}

class _TopicGeneratorState extends State<_TopicGenerator> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopicGeneratorCubit, TopicGeneratorState>(
      listener: (context, state) {
        state.whenOrNull(
          completed: (draftTopic) {
            nameController.clear();
            descController.clear();
          },
        );
      },
      builder: (context, state) {
        bool isLoading = state.maybeMap(
          loading: (value) => true,
          orElse: () => false,
        );

        DraftTopic? topic = state.draftTopic;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter name",
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter description",
                    ),
                    maxLines: 5,
                    minLines: 1,
                  ),
                  const SizedBox(height: 12),
                  isLoading
                      ? const CupertinoActivityIndicator()
                      : IconButton(
                          onPressed: () {
                            context.read<TopicGeneratorCubit>().generate(
                                  name: nameController.text,
                                  description: descController.text,
                                  level: "Advanced",
                                );
                          },
                          icon: const Icon(Icons.send),
                        ),
                  const SizedBox(height: 12),
                  if (topic != null) ...[
                    BlocBuilder<SaveTopicCubit, SaveTopicState>(
                      builder: (context, state) {
                        String label = "Save";
                        bool isLoading = state.maybeWhen(
                          loading: (total, totalSaved) {
                            label =
                                "${((totalSaved / total) * 100).toInt()} % Saved";
                            return true;
                          },
                          orElse: () => false,
                        );

                        return ElevatedButton(
                          onPressed: () {
                            if (!isLoading) {
                              context.read<SaveTopicCubit>().save(topic);
                            }
                          },
                          child: Text(label),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 16),
            (topic == null)
                ? const Spacer()
                : Expanded(
                    child: Builder(
                      builder: (context) {
                        // Create a map of language codes to their translations
                        final translations = {
                          "English": topic.en,
                          "Spanish": topic.es,
                          "Italian": topic.it,
                          "German": topic.de,
                          "Czech": topic.cs,
                          "Swedish": topic.sv,
                          "Chinese": topic.zh,
                          "Norwegian": topic.nb,
                          "Portuguese": topic.pt,
                          "Russian": topic.ru,
                          "French": topic.fr,
                          "Dutch": topic.nl,
                          "Ukrainian": topic.uk,
                        };

                        return Column(
                          children: [
                            Image.file(
                              File(topic.image),
                              height: 400,
                              fit: BoxFit.fitHeight,
                            ),
                            Text(
                              "Level: ${topic.level}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            ...translations.entries.map(
                              (entry) => Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.key,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(entry.value.name),
                                    const SizedBox(height: 4),
                                    Text(entry.value.description),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ],
        );
      },
    );
  }
}
