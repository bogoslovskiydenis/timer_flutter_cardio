import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/timer_bloc.dart';
import 'timer_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Таймер на Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF1F2040),
      ),
      home: BlocProvider(
        create: (context) => TimerBloc(),
        child: const TimerScreen(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}