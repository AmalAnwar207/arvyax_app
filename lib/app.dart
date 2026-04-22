import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'data/models/journal_entry.dart';
import 'data/repositories/ambiences_repository.dart';
import 'data/repositories/journal_repository.dart';
import 'features/ambience/cubit/ambience_cubit.dart';
import 'features/journal/cubit/journal_cubit.dart';
import 'features/player/cubit/player_cubit.dart';
import 'shared/mainlayout.dart';
import 'shared/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AmbienceCubit(AmbiencesRepository())..loadAmbiences(),
        ),
        BlocProvider(
          create: (_) => PlayerCubit(),
        ),
        BlocProvider(
          create: (_) => JournalCubit(
            JournalRepository(Hive.box<JournalEntry>('journalBox')),
          )..load(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const MainLayout(),
      ),
    );
  }
}