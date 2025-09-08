import 'package:cronometro/models/vueltas_model.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../viewmodels/notification_viewmodel.dart';

class MainView extends StatelessWidget {
  final NotificationViewModel _viewModel = NotificationViewModel();

  MainView({super.key}) {
    _viewModel.initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return const TimerScreen();
  }
}

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  final NotificationViewModel _viewModel = NotificationViewModel();
  final List<VueltaModel> _vueltas = [];

  late Timer _timer;
  Timer? _pauseReminderTimer;
  int _seconds = 0;
  int _tiempoVuelta = 0;
  bool _isRunning = false;

  // Agrega una vuelta a la lista
  void _addVuelta(String tiempo, String total) {
    final newVuelta = VueltaModel(
      number: _vueltas.length + 1,
      tiempo: tiempo,
      total: total,
    );
    setState(() {
      _vueltas.insert(0, newVuelta);
    });
  }

  // Inicia el cronómetro
  void _play() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _pauseReminderTimer?.cancel();
    _viewModel.showRunningNotification(_formatTime(_seconds));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
      _viewModel.showRunningNotification(_formatTime(_seconds));
    });
  }

  // Detiene el cronómetro
  void _stop() {
    if (_isRunning) {
      _timer.cancel();
      setState(() {
        _isRunning = false;
      });

      _viewModel.cancelAllNotifications();

      _pauseReminderTimer = Timer(const Duration(seconds: 10), () {
        if (!_isRunning) {
          _viewModel.showPauseReminder();
        }
      });
    }
  }

  // Registra una vuelta
  void _vuelta() {
    if (_isRunning) {
      final totalVuelta = _seconds;
      final tiempoVuelta = totalVuelta - _tiempoVuelta;
      _tiempoVuelta = totalVuelta;

      final lapTime = _formatTime(tiempoVuelta);
      final total = _formatTime(totalVuelta);

      _addVuelta(lapTime, total);
      _viewModel.showLapNotification(lapTime, total);
    }
  }

  // Reinicia cronómetro y borra todas las vueltas
  void _reinicia() {
    if (_isRunning) _timer.cancel();

    setState(() {
      _seconds = 0;
      _isRunning = false;
      _vueltas.clear();
      _tiempoVuelta = 0;
    });

    _viewModel.cancelAllNotifications();
  }

  // Formatea segundos a HH:MM:SS
  String _formatTime(int seconds) {
    final int hours = seconds ~/ 3600;
    final int minutes = (seconds % 3600) ~/ 60;
    final int secs = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    if (_isRunning) _timer.cancel();
    _pauseReminderTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Colores de alto contraste
    const backgroundColor = Color.fromARGB(255, 31, 31, 31);
    const textColor = Colors.white;
    const buttonColor = Color.fromARGB(255, 186, 74, 255);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Cronómetro'),
        backgroundColor: const Color.fromARGB(255, 182, 127, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                _formatTime(_seconds),
                style: const TextStyle(
                  fontSize: 64, // fuente grande
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 223, 223, 223),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _isRunning
                  ? [
                      ElevatedButton(
                        onPressed: _vuelta,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 219, 219, 219),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: const Text(
                          'Vuelta',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _stop,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: const Text(
                          'Parar',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ]
                  : [
                      ElevatedButton(
                        onPressed: _play,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 219, 219, 219),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: const Text(
                          'Iniciar',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _reinicia,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:const Color.fromARGB(255, 219, 219, 219),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        ),
                        child: const Text(
                          'Reiniciar',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _vueltas.length,
                itemBuilder: (context, index) {
                  final vuelta = _vueltas[index];
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Text(
                        '${vuelta.number}',
                        style: const TextStyle(color: textColor, fontSize: 20),
                      ),
                      title: Text(
                        'Vuelta: ${vuelta.tiempo}',
                        style: const TextStyle(color: textColor, fontSize: 20),
                      ),
                      subtitle: Text(
                        'Total: ${vuelta.total}',
                        style: const TextStyle(color: textColor, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
