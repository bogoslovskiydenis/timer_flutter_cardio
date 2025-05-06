import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/timer_bloc.dart';
import '../widgets/circular_timer_widget.dart';
import '../widgets/control_buttons.dart';
import 'widgets/preset_time_selector.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Связываем контроллер анимации с BLoC
    context.read<TimerBloc>().setPulseController(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            // Круговой таймер с делениями и секундной стрелкой
            CircularTimerWidget(pulseController: _pulseController),
            const SizedBox(height: 20),
            // Пресеты времени
            const PresetTimeSelector(),
            const SizedBox(height: 20),
            // Кнопки управления
            const ControlButtons(),
          ],
        ),
      ),
    );
  }
}