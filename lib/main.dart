import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'injection.dart';
import 'presentation/presentation.dart';

void main() async {
  await setupInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CourseCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<TopicCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<TopicGeneratorCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<SaveTopicCubit>(),
        ),
      ],
      child: MaterialApp(
        title: "Home",
        theme: ThemeData.light(),
        home: const HomeScreen(),
      ),
    );
  }
}
