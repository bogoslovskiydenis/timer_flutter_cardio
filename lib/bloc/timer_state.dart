part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int duration;
  final int totalDuration;

  const TimerState({
    required this.duration,
    required this.totalDuration,
  });

  @override
  List<Object?> get props => [duration, totalDuration];
}

// Состояние таймера: Начальное
class TimerInitial extends TimerState {
  const TimerInitial({required int duration})
      : super(duration: duration, totalDuration: duration);
}

// Состояние таймера: Запущен
class TimerRunInProgress extends TimerState {
  const TimerRunInProgress({
    required int duration,
    required int totalDuration,
  }) : super(duration: duration, totalDuration: totalDuration);
}

// Состояние таймера: Приостановлен
class TimerRunPause extends TimerState {
  const TimerRunPause({
    required int duration,
    required int totalDuration,
  }) : super(duration: duration, totalDuration: totalDuration);
}

// Состояние таймера: Завершен
class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(duration: 0, totalDuration: 0);
}