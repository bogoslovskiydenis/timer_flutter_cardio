import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/timer_bloc.dart';
import '../painters/circular_timer_painter.dart';

class CircularTimerWidget extends StatelessWidget {
  final AnimationController pulseController;

  const CircularTimerWidget({
    Key? key,
    required this.pulseController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timerBloc = BlocProvider.of<TimerBloc>(context);

    return Center(
      child: AnimatedBuilder(
        animation: pulseController,
        builder: (context, child) {
          return BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              return Container(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Внешний круг с делениями и секундной стрелкой
                    CustomPaint(
                      size: const Size(280, 280),
                      painter: CircularTimerPainter(
                        timeTotal: state.totalDuration,
                        timePassed: state.totalDuration - state.duration,
                        isRunning: state is TimerRunInProgress,
                        animationValue: pulseController.value,
                        secondValue: timerBloc.getSecondValue(),
                      ),
                    ),
                    // Внутренний желтый круг
                    Container(
                      width: 220,
                      height: 220,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFAD05C),
                      ),
                      child: Center(
                        child: Text(
                          timerBloc.formatTime(state.duration),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2040),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

