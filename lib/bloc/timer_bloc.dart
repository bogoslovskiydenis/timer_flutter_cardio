import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'timer_event.dart';
part 'timer_state.dart';


class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _defaultDuration = 60;

  Timer? _timer;
  final List<int> presetTimes = [10, 15, 20, 25, 30, 35, 40, 45, 60, 90, 120, 180, 240, 300];

  // Запоминаем контроллер анимации
  AnimationController? pulseController;

  TimerBloc() : super(const TimerInitial(duration: _defaultDuration)) {
    on<TimerStarted>(_onStarted);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<TimerTicked>(_onTicked);
    on<TimerDurationSelected>(_onDurationSelected);
  }

  // Устанавливаем контроллер анимации
  void setPulseController(AnimationController controller) {
    pulseController = controller;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(
      duration: event.duration,
      totalDuration: event.duration,
    ));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(TimerTicked(
        remainingDuration: state.duration - 1,
      ));
    });
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _timer?.cancel();
      emit(TimerRunPause(
        duration: state.duration,
        totalDuration: state.totalDuration,
      ));
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunPause) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        add(TimerTicked(
          remainingDuration: state.duration - 1,
        ));
      });
      emit(TimerRunInProgress(
        duration: state.duration,
        totalDuration: state.totalDuration,
      ));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _timer?.cancel();
    emit(TimerInitial(duration: state.totalDuration));
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    if (event.remainingDuration > 0) {
      emit(TimerRunInProgress(
        duration: event.remainingDuration,
        totalDuration: state.totalDuration,
      ));
    } else {
      _timer?.cancel();
      emit(const TimerRunComplete());
    }
  }

  void _onDurationSelected(TimerDurationSelected event, Emitter<TimerState> emit) {
    _timer?.cancel();
    emit(TimerInitial(duration: event.duration));
  }

  int getSecondValue() {
    if (state is TimerRunInProgress) {
      return state.totalDuration - state.duration;
    }
    return 0;
  }

  bool isRunning() {
    return state is TimerRunInProgress;
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
