import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/timer_bloc.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                context: context,
                icon: Icons.refresh,
                onPressed: () => context.read<TimerBloc>().add(const TimerReset()),
              ),
              _buildControlButton(
                context: context,
                icon: state is TimerRunInProgress ? Icons.pause : Icons.play_arrow,
                onPressed: () {
                  if (state is TimerInitial) {
                    context.read<TimerBloc>().add(TimerStarted(duration: state.duration));
                  } else if (state is TimerRunInProgress) {
                    context.read<TimerBloc>().add(const TimerPaused());
                  } else if (state is TimerRunPause) {
                    context.read<TimerBloc>().add(const TimerResumed());
                  } else if (state is TimerRunComplete) {
                    context.read<TimerBloc>().add(TimerStarted(duration: state.totalDuration));
                  }
                },
                primary: true,
              ),
              _buildControlButton(
                context: context,
                icon: Icons.stop,
                onPressed: () {
                  context.read<TimerBloc>().add(const TimerReset());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onPressed,
    bool primary = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: primary ? 70 : 60,
        height: primary ? 70 : 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primary ? const Color(0xFFFAD05C) : const Color(0xFF2D2F5A),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Icon(
          icon,
          size: primary ? 35 : 25,
          color: primary ? const Color(0xFF1F2040) : Colors.white,
        ),
      ),
    );
  }
}

