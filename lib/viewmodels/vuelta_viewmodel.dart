import 'package:flutter/foundation.dart';
import '../models/vueltas_model.dart';

class LapViewModel extends ChangeNotifier {
  final List<VueltaModel> _vueltas = [];

  List<VueltaModel> get vueltas => List.unmodifiable(_vueltas);

  void addLap(String tiempo, String total) {
    final newLap = VueltaModel(
      number: _vueltas.length + 1,
      tiempo: tiempo,
      total: total,
    );
    _vueltas.add(newLap);
    notifyListeners();
  }

  void clearLaps() {
    _vueltas.clear();
    notifyListeners();
  }
}
