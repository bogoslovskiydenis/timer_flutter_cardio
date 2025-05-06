import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/timer_bloc.dart';
import '../model/preset_time.dart';

class PresetTimeSelector extends StatelessWidget {
  const PresetTimeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final presetTimes = PresetTime.getPresetTimes();

    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        final bool isSelectingEnabled = !(state is TimerRunInProgress);

        return Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: presetTimes.length,
            itemBuilder: (context, index) {
              final preset = presetTimes[index];
              final isSelected = state.totalDuration == preset.duration;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: isSelectingEnabled
                      ? () => context.read<TimerBloc>().add(
                      TimerDurationSelected(duration: preset.duration))
                      : null,
                  child: Opacity(
                    opacity: isSelectingEnabled ? 1.0 : 0.5,
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? const Color(0xFFFAD05C)
                            : const Color(0xFF2D2F5A),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Text(
                        preset.label,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF1F2040)
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}