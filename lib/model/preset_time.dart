class PresetTime {
  final int duration;
  final String label;

  const PresetTime({
    required this.duration,
    required this.label,
  });

  // Форматирование отображения времени
  String get displayTime {
    if (duration < 60) {
      return '$duration сек';
    } else {
      final minutes = duration ~/ 60;
      return '$minutes мин';
    }
  }

  // Список пресетов с готовыми временными интервалами
  static List<PresetTime> getPresetTimes() {
    return [
      const PresetTime(duration: 10, label: '10s'),
      const PresetTime(duration: 15, label: '15s'),
      const PresetTime(duration: 20, label: '20s'),
      const PresetTime(duration: 25, label: '25s'),
      const PresetTime(duration: 30, label: '30s'),
      const PresetTime(duration: 45, label: '45s'),
      const PresetTime(duration: 60, label: '1m'),
      const PresetTime(duration: 90, label: '1.5m'),
      const PresetTime(duration: 120, label: '2m'),
      const PresetTime(duration: 180, label: '3m'),
      const PresetTime(duration: 240, label: '4m'),
      const PresetTime(duration: 300, label: '5m'),
    ];
  }
}