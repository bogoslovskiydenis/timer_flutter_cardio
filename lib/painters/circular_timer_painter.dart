import 'dart:math' as math;
import 'package:flutter/material.dart';

class CircularTimerPainter extends CustomPainter {
  final int timeTotal;
  final int timePassed;
  final bool isRunning;
  final double animationValue;
  final int secondValue;

  CircularTimerPainter({
    required this.timeTotal,
    required this.timePassed,
    required this.isRunning,
    required this.animationValue,
    required this.secondValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Рисуем внешний круг
    final Paint circlePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Радианы для начала и конца кардиограммы
    final double cardioStartAngle = -math.pi / 2 - math.pi / 8;
    final double cardioEndAngle = -math.pi / 2 + math.pi / 8;

    // Рисуем почти полный круг (исключая верхнюю часть для кардиограммы)
    final Path circlePath = Path();
    circlePath.addArc(
      Rect.fromCircle(center: center, radius: radius),
      cardioEndAngle,
      2 * math.pi - (cardioEndAngle - cardioStartAngle),
    );

    canvas.drawPath(circlePath, circlePaint);

    // Создаем градиентную заливку для кардиограммы
    final Rect gradientRect = Rect.fromCircle(center: center, radius: radius);
    final Gradient cardioGradient = SweepGradient(
      center: Alignment.center,
      startAngle: 0,
      endAngle: math.pi * 2,
      tileMode: TileMode.clamp,
      colors: [
        Colors.blue.shade400,
        Colors.purple.shade300,
        Colors.red.shade300,
        Colors.orange.shade300,
        Colors.blue.shade400,
      ],
      // Смещаем градиент в зависимости от прогресса секундной стрелки
      transform: GradientRotation(2 * math.pi * (secondValue / 60.0)),
    );

    // Рисуем кардиограмму на верхней части круга с анимацией
    _drawCardiogram(canvas, center, radius, cardioStartAngle, cardioEndAngle, gradientRect, cardioGradient);

    // Рисуем деления на круге
    _drawMarkings(canvas, center, radius);

    // Рисуем прогресс (если таймер активен)
    if (timeTotal > 0 && timePassed > 0 && isRunning) {
      _drawProgress(canvas, center, radius, gradientRect);
    }

    // Рисуем секундную стрелку с точками
    if (isRunning) {
      _drawSecondHand(canvas, center, radius);
    }
  }

  // Метод для отрисовки кардиограммы
  void _drawCardiogram(
      Canvas canvas,
      Offset center,
      double radius,
      double cardioStartAngle,
      double cardioEndAngle,
      Rect gradientRect,
      Gradient cardioGradient
      ) {
    final Path cardioPath = Path();

    // Начальная точка - левый край кардиограммы
    final double startX = center.dx + radius * math.cos(cardioStartAngle);
    final double startY = center.dy + radius * math.sin(cardioStartAngle);
    cardioPath.moveTo(startX, startY);

    // Вычисляем точки для кардиограммы
    final double cardioWidth = 2 * radius * math.sin(math.pi / 8); // Ширина дуги

    // Модификатор амплитуды на основе анимации и прогресса таймера
    double amplitudeModifier = 1.0;
    if (isRunning) {
      // Пульсация увеличивается с уменьшением оставшегося времени
      final double timeProgress = timeTotal > 0 ? timePassed / timeTotal : 0;
      amplitudeModifier = 1.0 + (animationValue * 0.5) + (timeProgress * 0.5);
    } else {
      amplitudeModifier = 1.0 + (animationValue * 0.2);
    }

    // Точки для кардиограммы в локальных координатах (относительно startX)
    final List<Offset> cardioPoints = [
      Offset(cardioWidth * 0.35, 0),
      Offset(cardioWidth * 0.42, -0),
      // Амплитуда пика зависит от animationValue и прогресса таймера
      Offset(cardioWidth * 0.48, -20 * amplitudeModifier),
      Offset(cardioWidth * 0.45, 1.5),
      Offset(cardioWidth * 0.48, -20 * amplitudeModifier),
      Offset(cardioWidth * 0.10, 5),
      Offset(cardioWidth * 0.44, -20 * amplitudeModifier),
      Offset(cardioWidth * 0.65, 0),
    ];

    // Конвертируем локальные координаты в глобальные и добавляем в путь
    for (int i = 1; i < cardioPoints.length; i++) {
      final double angle = cardioStartAngle + (i / (cardioPoints.length - 1)) * (cardioEndAngle - cardioStartAngle);

      final double x = center.dx + (radius + cardioPoints[i].dy) * math.cos(angle);
      final double y = center.dy + (radius + cardioPoints[i].dy) * math.sin(angle);

      cardioPath.lineTo(x, y);
    }

    // Конечная точка - правый край кардиограммы
    final double endX = center.dx + radius * math.cos(cardioEndAngle);
    final double endY = center.dy + radius * math.sin(cardioEndAngle);
    cardioPath.lineTo(endX, endY);

    // Рисуем кардиограмму с градиентом
    final Paint cardioPaint = Paint()
      ..shader = cardioGradient.createShader(gradientRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = isRunning ? 2.5 : 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(cardioPath, cardioPaint);

    // Если таймер активен, добавляем эффект свечения
    if (isRunning) {
      cardioPaint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 * animationValue);
      canvas.drawPath(cardioPath, cardioPaint);
    }
  }

  // Метод для отрисовки делений на циферблате
  void _drawMarkings(Canvas canvas, Offset center, double radius) {
    final int sections = 8; // Кол-во делений
    final double sectionAngle = 2 * math.pi / sections;

    for (int i = 0; i < sections; i++) {
      final angle = -math.pi / 2 + i * sectionAngle; // Начинаем с верхней позиции

      // Координаты для маленького штриха
      final innerX = center.dx + (radius - 5) * math.cos(angle);
      final innerY = center.dy + (radius - 5) * math.sin(angle);

      // Координаты для внешнего штриха
      final outerX = center.dx + (radius + 5) * math.cos(angle);
      final outerY = center.dy + (radius + 5) * math.sin(angle);

      // Рисуем штрих
      final Paint markPaint = Paint()
        ..color = Colors.white.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      canvas.drawLine(
        Offset(innerX, innerY),
        Offset(outerX, outerY),
        markPaint,
      );

      // Добавляем маленькую точку возле деления
      canvas.drawCircle(
        Offset(outerX, outerY),
        2,
        Paint()..color = Colors.white.withOpacity(0.7),
      );

      // Добавляем номер рядом с делением для четных секций
      if (i % 2 == 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${i + 1}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        // Размещаем текст немного дальше от внешнего штриха
        final textX = center.dx + (radius + 15) * math.cos(angle) - textPainter.width / 2;
        final textY = center.dy + (radius + 15) * math.sin(angle) - textPainter.height / 2;

        textPainter.paint(canvas, Offset(textX, textY));
      }
    }
  }

  // Метод для отрисовки прогресса таймера
  void _drawProgress(Canvas canvas, Offset center, double radius, Rect gradientRect) {
    final double progress = timePassed / timeTotal;
    final double sweepAngle = 2 * math.pi * progress;

    // Создаем градиент для прогресса
    final Gradient progressGradient = SweepGradient(
      center: Alignment.center,
      startAngle: -math.pi / 2,
      endAngle: 2 * math.pi * progress - math.pi / 2,
      colors: [
        Colors.blue.shade400,
        Colors.purple.shade300,
        Colors.red.shade300,
      ],
      stops: [0.0, 0.5, 1.0],
    );

    final Paint progressPaint = Paint()
      ..shader = progressGradient.createShader(gradientRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Начинаем с верхней позиции
      sweepAngle,
      false,
      progressPaint,
    );

    // Добавляем свечение для прогресса
    progressPaint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2 * animationValue);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  // Метод для отрисовки секундной стрелки
  void _drawSecondHand(Canvas canvas, Offset center, double radius) {
    // Рисуем линию секундной стрелки
    final double secondHandLength = radius * 0.8; // Длина секундной стрелки
    final double angle = -math.pi / 2 + (2 * math.pi * secondValue / 60);

    // Координаты конца секундной стрелки
    final endX = center.dx + secondHandLength * math.cos(angle);
    final endY = center.dy + secondHandLength * math.sin(angle);

    // Создаем градиент для секундной стрелки
    final Gradient secondHandGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white,
        Colors.blue.shade400,
        Colors.purple.shade300,
      ],
      stops: [0.0, 0.5, 1.0],
      transform: GradientRotation(angle + math.pi / 2),
    );

    // Рисуем основную линию секундной стрелки с градиентом
    final Paint secondHandPaint = Paint()
      ..shader = secondHandGradient.createShader(
        Rect.fromPoints(center, Offset(endX, endY)),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawLine(center, Offset(endX, endY), secondHandPaint);

    // Рисуем точки по линии секундной стрелки с градиентом
    final int dotsCount = 5; // Количество точек на линии
    for (int i = 0; i < dotsCount; i++) {
      final double dotRadius = i == 0 ? 3.0 : 2.0; // Первая точка больше
      final double t = i / (dotsCount - 1); // Нормализованная позиция от 0 до 1

      final double dotX = center.dx + t * (endX - center.dx);
      final double dotY = center.dy + t * (endY - center.dy);

      // Цвет для точки берем из градиента секундной стрелки
      final Color dotColor = i == 0
          ? Colors.white
          : Color.lerp(Colors.white, Colors.purple.shade300, t)!;

      canvas.drawCircle(
        Offset(dotX, dotY),
        dotRadius * (1.0 + (i == 0 ? 0 : 0.3 * animationValue)), // Анимация размера точек
        Paint()
          ..color = dotColor.withOpacity(0.8 + 0.2 * animationValue)
          ..style = PaintingStyle.fill
          ..maskFilter = i == 0 ? null : MaskFilter.blur(BlurStyle.normal, animationValue * 1.5),
      );
    }

    // Добавляем свечение на кончик секундной стрелки
    canvas.drawCircle(
      Offset(endX, endY),
      4.0 * animationValue,
      Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..style = PaintingStyle.fill
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3),
    );
  }

  @override
  bool shouldRepaint(CircularTimerPainter oldDelegate) {
    return oldDelegate.timeTotal != timeTotal ||
        oldDelegate.timePassed != timePassed ||
        oldDelegate.isRunning != isRunning ||
        oldDelegate.animationValue != animationValue ||
        oldDelegate.secondValue != secondValue;
  }
}