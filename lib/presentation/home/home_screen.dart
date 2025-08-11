import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/cubit.dart';
import '../../data/data.dart';

part 'home_screen.component.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    context.read<CourseCubit>().fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          bool isLoading = state.maybeMap(
            loading: (value) => true,
            orElse: () => false,
          );

          if (isLoading) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }

          return Row(
            children: [
              const SizedBox(
                width: 300,
                child: _Sidebar(),
              ),
              const SizedBox(
                height: double.infinity,
                child: VerticalDivider(
                  width: 1,
                  thickness: 1,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _TopicGenerator(),
                      //   _Section(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
