part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

// События, которые могут происходить с таймером
class TimerStarted extends TimerEvent {
  final int duration;

  const TimerStarted({required this.duration});

  @override
  List<Object?> get props => [duration];
}

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class TimerTicked extends TimerEvent {
  final int remainingDuration;

  const TimerTicked({required this.remainingDuration});

  @override
  List<Object?> get props => [remainingDuration];
}

class TimerDurationSelected extends TimerEvent {
  final int duration;

  const TimerDurationSelected({required this.duration});

  @override
  List<Object?> get props => [duration];
}