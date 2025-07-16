// This is the main entry point of the application
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clone/screens/home/bloc/video_bloc.dart';
import 'package:youtube_clone/screens/home/services/api_service.dart';

import 'package:youtube_clone/screens/splash_screen.dart';
import 'package:youtube_clone/utils/theme.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => VideoBloc(ApiService()))],
      child: YouTubeClone(),
    ),
  );
}

class YouTubeClone extends StatelessWidget {
  const YouTubeClone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Clone',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
