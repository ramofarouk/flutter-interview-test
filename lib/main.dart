import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_interview/injection.dart';
import 'package:flutter_interview/presentation/bloc/repository_bloc.dart';
import 'package:flutter_interview/presentation/bloc/repository_event.dart';
import 'package:flutter_interview/themes/app_theme.dart';
import 'package:flutter_interview/presentation/pages/home_screen.dart';
import 'package:flutter_interview/injection.dart' as di;

void main() {
  di.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omar App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(create:(ctx) => sl<RepositoryBloc>()..add(FetchRepositories()),child: const HomeScreen(),),
    );
  }
}
